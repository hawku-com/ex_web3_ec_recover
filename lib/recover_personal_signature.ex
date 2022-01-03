defmodule ExWeb3EcRecover.RecoverPersonalSignature do
  @moduledoc """
  Documentation for `RecoverPersonalSignature`.
  """

  def recover_personal_signature(%{sig: signature_hex, msg: message}) do
    {r, s, v_num} = convert_sig_to_components(signature_hex)
    bin_message = create_hash_from_personal_message(message)
    {:ok, recovered_key} = ExSecp256k1.recover(bin_message, r, s, v_num)

    get_address_from_recovered_key(recovered_key)
  end

  def get_address_from_recovered_key(key) do
    address =
      key
      |> binary_part(1, 64)
      |> ExKeccak.hash_256()
      |> Base.encode16(case: :lower)
      |> String.slice(-40..-1)

    "0x#{address}"
  end

  def convert_sig_to_components(signature_hex) do
    sig_binary =
      String.trim_leading(signature_hex, "0x")
      |> Base.decode16!(case: :lower)

    r = binary_part(sig_binary, 0, 32)
    s = binary_part(sig_binary, 32, 32)

    v_num =
      binary_part(sig_binary, 64, 1)
      |> :binary.decode_unsigned()

    {r, s, v_num - 27}
  end

  def create_hash_from_personal_message(orig_message) do
    ("\u0019Ethereum Signed Message:\n#{byte_size(orig_message)}" <> orig_message)
    |> ExKeccak.hash_256()
  end

  def legacyToBuffer(binary) do
    case Base.decode16(binary) do
      {:ok, result} -> result
      _ -> binary
    end
  end
end
