defmodule ExWeb3EcRecover.RecoverSignature do
  @moduledoc false

  @prefix_1901 Base.decode16!("1901")
  @eip712 "EIP712Domain"

  @allowed_versions [:v3, :v4]

  alias ExWeb3EcRecover.PersonalType
  alias ExWeb3EcRecover.SignedTypedData

  def recover_typed_signature(data, domain_types, types, primary_type, domain, sig, version)

  def recover_typed_signature(data, domain_types, types, primary_type, domain, sig, version)
      when version in @allowed_versions do
    {r, s, v_num} = convert_sig_to_components(sig)

    domain_types = Map.merge(types, %{@eip712 => domain_types})
    domain_separator = SignedTypedData.hash_message(domain, domain_types, @eip712)

    [
      @prefix_1901,
      domain_separator,
      ExWeb3EcRecover.SignedTypedData.hash_message(data, types, primary_type)
    ]
    |> :erlang.iolist_to_binary()
    |> ExKeccak.hash_256()
    |> ExSecp256k1.recover(r, s, v_num)
    |> case do
      {:ok, recovered_key} -> get_address_from_recovered_key(recovered_key)
      {:error, _reason} = error -> error
    end
  end

  def recover_typed_signature(
        _data,
        _domain_types,
        _types,
        _primary_type,
        _domain,
        _sig,
        _version
      ),
      do: {:error, :unsupported_version}

  def recover_personal_signature(%{sig: signature_hex, msg: message}) do
    {r, s, v_num} = convert_sig_to_components(signature_hex)

    message
    |> PersonalType.create_hash_from_personal_message()
    |> ExSecp256k1.recover(r, s, v_num)
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

  defp convert_sig_to_components(signature_hex) do
    sig_binary =
      signature_hex
      |> String.trim_leading("0x")
      |> Base.decode16!(case: :lower)

    r = binary_part(sig_binary, 0, 32)
    s = binary_part(sig_binary, 32, 32)

    v_num =
      binary_part(sig_binary, 64, 1)
      |> :binary.decode_unsigned()

    {r, s, v_num - 27}
  end
end
