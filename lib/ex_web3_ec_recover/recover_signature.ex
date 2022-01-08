defmodule ExWeb3EcRecover.RecoverSignature do
  @moduledoc false

  @prefix_1901 Base.decode16!("1901")
  @eip712 "EIP712Domain"

  @allowed_versions [:v3, :v4]

  alias ExWeb3EcRecover.PersonalType
  alias ExWeb3EcRecover.SignedTypedData
  alias ExWeb3EcRecover.SignedTypedData.Message

  def recover_typed_signature(message, sig, version)

  def recover_typed_signature(%Message{} = message, sig, version)
      when version in @allowed_versions do
    domain_separator = SignedTypedData.hash_message(message.domain, message.types, @eip712)

    message_hash =
      SignedTypedData.hash_message(message.message, message.types, message.primary_type)

    [
      @prefix_1901,
      domain_separator,
      message_hash
    ]
    |> :erlang.iolist_to_binary()
    |> ExKeccak.hash_256()
    |> do_recover_sig(sig)
  end

  def recover_typed_signature(_message, _sig, _version), do: {:error, :unsupported_version}

  def recover_personal_signature(message, sig) do
    message
    |> PersonalType.create_hash_from_personal_message()
    |> do_recover_sig(sig)
  end

  defp do_recover_sig(hash, sig) do
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
