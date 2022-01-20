defmodule ExWeb3EcRecover do
  @moduledoc """
  Documentation for `ExWeb3RecoverSignature`.
  """

  @doc """
  Returns the address that created the signature for a personal signed message on the ETH network.
  Useful for checking metamask signatures. Raises an error if sig is invalid.

  ## Examples

      iex> ExWeb3EcRecover.recover_personal_signature(
      ...>   "hello world",
      ...>   "0x1dd3657c91d95f350ab25f17ee7cbcdbccd3f5bc52976bfd4dd03bd6bc29d2" <>
      ...>   "ac23e656bee509ca33b921e0e6b53eb64082be1bb3c69c3a4adccd993b1d667f" <>
      ...>   "8d1b"
      ...> )
      "0xb117a8bc3ecf2c3f006b89da6826e49b4193977a"

      iex> ExWeb3EcRecover.recover_personal_signature(
      ...>   "0x0cc175b9c0f1b6a831c399e26977266192eb5ffee6ae2fec3ad71c777531578f",
      ...>   "0x9ff8350cc7354b80740a3580d0e0fd4f1f02062040bc06b893d70906f872" <>
      ...>   "8bb5163837fd376bf77ce03b55e9bd092b32af60e86abce48f7b8d3539988e" <>
      ...>   "e5a9be1c"
      ...> )
      "0xbe93f9bacbcffc8ee6663f2647917ed7a20a57bb"


  """
  require Logger

  def recover_personal_signature(message, sig_hexstring) do
    ExWeb3EcRecover.RecoverSignature.recover_personal_signature(message, sig_hexstring)
  end

  @doc """
  Returns the address that created the signature for a typed structured data signed message on the
  ETH network. Useful for checking metamask signatures. Raises an error if sig is invalid.

  ## Examples

  ```
    sig = "0xf75d91c136214ad9d73b4117109982ac905d0e90b5fff7c69ba59dba0669e56"<>
      "922cc936feb67993627b56542d138e151de0e196962e38aabf834b002b01592211c"

    message = ExWeb3EcRecover.Message.from_map(raw_message)

    ExWeb3EcRecover.recover_typed_signature(
      message,
      sig,
      :v4
    )
  ```
  """
  defdelegate recover_typed_signature(message, sig, version),
    to: ExWeb3EcRecover.RecoverSignature

  @doc """
  This function transforms 0x prefixed hex string into an elixir binary

  ## Examples

      iex> ExWeb3EcRecover.parse_hex("0x00")
      <<0>>
  """
  def parse_hex(hex_string) do
    hex_string
    |> String.trim_leading("0x")
    |> Base.decode16!(case: :mixed)
  end
end
