defmodule ExWeb3EcRecoverTest do
  use ExUnit.Case
  doctest ExWeb3EcRecover

  test "Recovers address from a signature and the message" do
    # This sig was genarated using Meta Mask
    sig =
      "0xf6cda8eaf5137e8cc15d48d03a002b0512446e2a7acbc576c01cfbe40ad" <>
        "9345663ccda8884520d98dece9a8bfe38102851bdae7f69b3d8612b9808e6" <>
        "337801601b"

    types = %{"Message" => [%{"name" => "data", "type" => "string"}]}
    primary_type = "Message"

    message = %{
      "data" => "test"
    }

    expected_address = "0x29c76e6ad8f28bb1004902578fb108c507be341b"

    assert expected_address ==
             ExWeb3EcRecover.RecoverSignature.recover_typed_signature(
               message,
               [],
               types,
               primary_type,
               %{},
               sig,
               :v4
             )
  end

  test "Recovers address from a signature and the message with provided domain" do
    # This sig was genarated using Meta Mask
    sig =
      "0xf75d91c136214ad9d73b4117109982ac905d0e90b5fff7c69ba59dba0669e56922cc936feb67993627b56542d138e151de0e196962e38aabf834b002b01592211c"

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
      "verifyingContract" => "0000000000000000000000000000000000000000" |> Base.decode16!()
    }

    assert expected_address ==
             ExWeb3EcRecover.RecoverSignature.recover_typed_signature(
               message,
               domain_types,
               types,
               primary_type,
               domain,
               sig,
               :v4
             )
  end
end
