defmodule ExWeb3EcRecover do
  @moduledoc """
  Documentation for `ExWeb3RecoverSignature`.
  """

  @doc """
  Returns the address that created the signature for a personal signed message on the ETH network.
  Useful for checking metamask signatures. Raises an error if sig is invalid.

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

  @doc """
  Returns the address that created the signature for a typed structured data signed message on the
  ETH network. Useful for checking metamask signatures. Raises an error if sig is invalid.

  ## Examples

  ```
    sig = "0xf75d91c136214ad9d73b4117109982ac905d0e90b5fff7c69ba59dba0669e56"<>
      "922cc936feb67993627b56542d138e151de0e196962e38aabf834b002b01592211c"

    types = %{"Message" => [%{"name" => "data", "type" => "string"}]}
    primary_type = "Message"

    message = %{
      "data" => "test"
    }

    expected_address = "0x29c76e6ad8f28bb1004902578fb108c507be341b"

    domain_types = [
      %{
        "name" => "name",
        "type" => "string"
      },
      %{
        "name" => "version",
        "type" => "string"
      },
      %{
        "name" => "chainId",
        "type" => "uint256"
      },
      %{
        "name" => "verifyingContract",
        "type" => "address"
      }
    ]

    domain = %{
      "name" => "example.metamask.io",
      "version" => "3",
      "chainId" => 1,
      "verifyingContract" => <<0::160>>
    }

    ExWeb3EcRecover.RecoverSignature.recover_typed_signature(
      message,
      domain_types,
      types,
      primary_type,
      domain,
      sig,
      :v4
    )
  ```
  """
  defdelegate recover_typed_signature(
                data,
                domain_types,
                types,
                primary_type,
                domain,
                sig,
                version
              ),
              to: ExWeb3EcRecover.RecoverSignature
end
