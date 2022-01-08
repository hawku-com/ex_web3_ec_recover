defmodule ExWeb3EcRecover do
  @moduledoc """
  Documentation for `ExWeb3RecoverSignature`.
  """

  @doc """
  Returns the address that created the signature for a personal signed message on the ETH network.  Useful for checking metamask signatures.  Returns error if sig is invalid.

  ## Examples

      iex> ExWeb3EcRecover.recover_personal_signature(%{sig: "0x1dd3657c91d95f350ab25f17ee7cbcdbccd3f5bc52976bfd4dd03bd6bc29d2ac23e656bee509ca33b921e0e6b53eb64082be1bb3c69c3a4adccd993b1d667f8d1b", msg: "hello world"})
      "0xb117a8bc3ecf2c3f006b89da6826e49b4193977a"


  """
  require Logger

  def recover_personal_signature(params = %{sig: _signature_hex, msg: _message}) do
    ExWeb3EcRecover.RecoverSignature.recover_personal_signature(params)
  end

  def recover_personal_signature(_other) do
    raise ArgumentError,
      message:
        "Invalid recover_personal_signature argument.  Should be %{sig: signature, msg: message}"
  end
end
