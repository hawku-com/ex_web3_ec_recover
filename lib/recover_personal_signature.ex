defmodule ExWeb3EcRecover.RecoverPersonalSignature do
  @moduledoc false

  def recover_personal_signature(%{sig: signature_hex, msg: message}) do
    {r, s, v_num} = convert_sig_to_components(signature_hex)

    message
    |> create_hash_from_personal_message()
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

  defp create_hash_from_personal_message(orig_message) do
    ("\u0019Ethereum Signed Message:\n#{byte_size(orig_message)}" <> orig_message)
    |> ExKeccak.hash_256()
  end
end
