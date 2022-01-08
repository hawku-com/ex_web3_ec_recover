defmodule ExWeb3EcRecover do
  @moduledoc """
  Documentation for `ExWeb3RecoverSignature`.
  """

  @doc """
  Returns the address that created the signature for a personal signed message on the ETH network.
  Useful for checking metamask signatures. Raises an error if sig is invalid.

  ## Examples

      iex> ExWeb3EcRecover.recover_personal_signature("hello world", "0x1dd3657c91d95f350ab25f17ee7cbcdbccd3f5bc52976bfd4dd03bd6bc29d2ac23e656bee509ca33b921e0e6b53eb64082be1bb3c69c3a4adccd993b1d667f8d1b" |> ExWeb3EcRecover.Signature.from_binary())
      "0xb117a8bc3ecf2c3f006b89da6826e49b4193977a"

  """
  require Logger

  def recover_personal_signature(message, %ExWeb3EcRecover.Signature{} = sig) do
    ExWeb3EcRecover.RecoverSignature.recover_personal_signature(message, sig)
  end

  @doc """
  Returns the address that created the signature for a typed structured data signed message on the
  ETH network. Useful for checking metamask signatures. Raises an error if sig is invalid.

  ## Examples

  ```
    sig = "0xf75d91c136214ad9d73b4117109982ac905d0e90b5fff7c69ba59dba0669e56"<>
      "922cc936feb67993627b56542d138e151de0e196962e38aabf834b002b01592211c"

    message = ExWeb3EcRecover.SignedTypedData.Message.from_map(raw_message)

    ExWeb3EcRecover.RecoverSignature.recover_typed_signature(
      message,
      sig,
      :v4
    )
  ```
  """
  defdelegate recover_typed_signature(message, sig, version),
    to: ExWeb3EcRecover.RecoverSignature
end
