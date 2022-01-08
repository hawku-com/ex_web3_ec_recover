defmodule ExWeb3EcRecover.SignedTypedData.Message do
  @moduledoc """
  This module represents a message data structure that is used
  to sign and recover, based on EIP 712.

  ## Domain
  For details look at this [website](https://eips.ethereum.org/EIPS/eip-712#definition-of-domainseparator).

  ```
  - string name the user readable name of signing domain, i.e. the name of the DApp or the protocol.
  - string version the current major version of the signing domain. Signatures from different versions are not compatible.
  - uint256 chainId the EIP-155 chain id. The user-agent should refuse signing if it does not match the currently active chain.
  - address verifyingContract the address of the contract that will verify the signature. The user-agent may do contract specific phishing prevention.
  - bytes32 salt an disambiguating salt for the protocol. This can be used as a domain separator of last resort.
  ```
  Source: https://eips.ethereum.org/EIPS/eip-712#definition-of-domainseparator

  ## Types
  This field contains types available to be used by `message` field.

  It should contain a list of maps containing `name` and `type` values.
  For list of available types consult [EIP website](https://eips.ethereum.org/EIPS/eip-712#specification).

  ### Example

  ```
  %{
    "Message" => [
      %{"name" => "data", "type" => "Child"},
      %{"name" => "intData", "type" => "int8"},
      %{"name" => "uintData", "type" => "uint8"},
      %{"name" => "bytesData", "type" => "bytes3"},
      %{"name" => "boolData", "type" => "bool"},
      %{"name" => "addressData", "type" => "address"}
    ],
    "Child" => [%{"name" => "data", "type" => "GrandChild"}],
    "GrandChild" => [%{"name" => "data", "type" => "string"}]
  }
  ```

  ## Primary type
  A string designating the root type. The root of the message is expected to be of the `primary_type`.

  ## Message
  Message is map with the data that will be used to build data structure to be encoded.
  """

  @enforce_keys [:domain, :message, :types, :primary_type]
  defstruct @enforce_keys

  @type t :: %__MODULE__{
          domain: map(),
          message: map(),
          types: map(),
          primary_type: String.t()
        }

  @doc """
  This function generates a struct representing a message.

  Check module doc for details.
  """
  @spec from_map(message :: map()) :: {:ok, t()} | :error
  def from_map(%{
        "domain" => domain,
        "message" => message,
        "types" => types,
        "primary_type" => primary_type
      }) do
    data = %__MODULE__{
      domain: domain,
      message: message,
      types: types,
      primary_type: primary_type
    }

    {:ok, data}
  end

  def from_map(_), do: :error
end
