defmodule ExWeb3EcRecover.RecoverSignature do
  @moduledoc false

  @prefix_1901 Base.decode16!("1901")
  @eip712 "EIP712Domain"
  @domain_type %{
    "EIP712Domain" => [
      %{"name" => "name", "type" => "string"},
      %{"name" => "version", "type" => "string"},
      %{"name" => "chainId", "type" => "uint256"},
      %{"name" => "verifyingContract", "type" => "address"}
    ]
  }

  @allowed_versions [:v4]

  alias ExWeb3EcRecover.PersonalType
  alias ExWeb3EcRecover.Signature
  alias ExWeb3EcRecover.SignedType
  alias ExWeb3EcRecover.SignedType.Message

  defguard is_valid_signature?(signature)
           when byte_size(signature) == 132 and binary_part(signature, 0, 2) == "0x"

  def encode_eip712(message) do
    domain_separator =
      SignedType.hash_message(message.domain, @domain_type, @eip712)
      |> tap(fn encoded ->
        encoded
        |> Base.encode16()
        |> IO.inspect(label: "Encoded domain")
      end)

    message_hash =
      SignedType.hash_message(message.message, message.types, message.primary_type)
      |> tap(fn encoded ->
        encoded
        |> Base.encode16()
        |> IO.inspect(label: "Message hash")
      end)

    [
      @prefix_1901,
      domain_separator,
      message_hash
    ]
    |> :erlang.iolist_to_binary()
  end

  def hash_eip712(message) do
    message
    |> encode_eip712()
    |> ExKeccak.hash_256()
  end

  def recover_typed_signature(message, sig, version)

  def recover_typed_signature(%Message{} = message, sig, version)
      when version in @allowed_versions and is_valid_signature?(sig) do
    hash_eip712(message)
    |> do_recover_sig(sig)
  end

  def recover_typed_signature(_message, _sig, version) when version not in @allowed_versions,
    do: {:error, :unsupported_version}

  def recover_typed_signature(_message, _sig, _version), do: {:error, :invalid_signature}

  def recover_personal_signature(message, sig)
      when is_valid_signature?(sig) do
    message
    |> PersonalType.create_hash_from_personal_message()
    |> do_recover_sig(sig)
  end

  def recover_personal_signature(_message, _sig), do: {:error, :invalid_signature}

  defp do_recover_sig(hash, sig_hexstring) do
    sig = Signature.from_hexstring(sig_hexstring)

    hash
    |> ExSecp256k1.recover(sig.r, sig.s, sig.v_num)
    |> case do
      {:ok, recovered_key} -> get_address_from_recovered_key(recovered_key)
      {:error, _reason} = error -> error
    end
  end

  defp get_address_from_recovered_key(key) do
    address =
      key
      |> binary_part(1, 64)
      |> ExKeccak.hash_256()
      |> Base.encode16(case: :lower)
      |> String.slice(-40..-1)

    "0x#{address}"
  end
end
