defmodule ExWeb3EcRecoverTest do
  use ExUnit.Case

  doctest ExWeb3EcRecover

  alias ExWeb3EcRecover.SignedType.Message

  test "Recovers address from a signature and the message" do
    # This sig was genarated using Meta Mask
    sig =
      "0xf6cda8eaf5137e8cc15d48d03a002b0512446e2a7acbc576c01cfbe40ad" <>
        "9345663ccda8884520d98dece9a8bfe38102851bdae7f69b3d8612b9808e6" <>
        "337801601b"




    message = %Message{
      types: %{
        "Message" => [%{"name" => "data", "type" => "string"}],
        "EIP712Domain" => []
      },
      primary_type: "Message",
      message: %{
        "data" => "test"
      },
      domain: %{}
    }

    expected_address = "0x29c76e6ad8f28bb1004902578fb108c507be341b"

    assert expected_address ==
             ExWeb3EcRecover.recover_typed_signature(message, sig, :v4)
  end

  test "Recovers address from a signature and the message with provided domain" do
    # This sig was genarated using Meta Mask
    sig =
      "0xf75d91c136214ad9d73b4117109982ac905d0e90b5fff7c69ba59dba0669e56922cc936feb67993627b56542d138e151de0e196962e38aabf834b002b01592211c"

    message = %Message{
      types: %{
        "Message" => [%{"name" => "data", "type" => "string"}],
        "EIP712Domain" => [
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
      },
      primary_type: "Message",
      message: %{
        "data" => "test"
      },
      domain: %{
        "name" => "example.metamask.io",
        "version" => "3",
        "chainId" => 1,
        "verifyingContract" => "0x"
      }
    }

    expected_address = "0x29c76e6ad8f28bb1004902578fb108c507be341b"

    assert expected_address ==
             ExWeb3EcRecover.recover_typed_signature(message, sig, :v4)
  end
test "Order message support" do
    message = %Message{
      types: %{
        "EIP712Domain" => [
          %{"name" => "name", "type" => "string"},
          %{"name" => "version", "type" => "string"},
          %{"name" => "chainId", "type" => "uint256"},
          %{"name" => "verifyingContract", "type" => "address"}
        ],
        "Order" => [
          %{"name" => "makerAddress", "type" => "address"},
          %{"name" => "takerAddress", "type" => "address"},
          %{"name" => "feeRecipientAddress", "type" => "address"},
          %{"name" => "senderAddress", "type" => "address"},
          %{"name" => "makerAssetAmount", "type" => "uint256"},
          %{"name" => "takerAssetAmount", "type" => "uint256"},
          %{"name" => "makerFee", "type" => "uint256"},
          %{"name" => "takerFee", "type" => "uint256"},
          %{"name" => "expirationTimeSeconds", "type" => "uint256"},
          %{"name" => "salt", "type" => "uint256"},
          %{"name" => "makerAssetData", "type" => "bytes"},
          %{"name" => "takerAssetData", "type" => "bytes"},
          %{"name" => "makerFeeAssetData", "type" => "bytes"},
          %{"name" => "takerFeeAssetData", "type" => "bytes"}
        ]
      },
      primary_type: "Order",
      domain: %{
        "name" => "0x Protocol",
        "version" => "3.0.0",
        "chainId" => 137,
        "verifyingContract" =>
          "0xfede379e48c873c75f3cc0c81f7c784ad730a8f7"
      },
      message: %{
        "makerAddress" =>
          "0x1bbeb0a1a075d870bed8c21dfbe49a37015e4124",
        "takerAddress" =>
          "0x0000000000000000000000000000000000000000" ,
        "senderAddress" =>
          "0x0000000000000000000000000000000000000000",
        "feeRecipientAddress" =>
          "0x0000000000000000000000000000000000000000",
        "expirationTimeSeconds" => 1_641_635_545,
        "salt" => 1,
        "makerAssetAmount" => 1,
        "takerAssetAmount" => 50_000_000_000_000_000,
        "makerAssetData" =>  ("0x02571792000000000000000000000000a5f1ea7df861952863df2e8d1312f7305dabf2150000000000000000000000000000000000000000000000000000000000002b5b"),
        "takerAssetData" =>
          "0xf47261b00000000000000000000000007ceb23fd6bc0add59e62ac25578270cff1b9f619",
        "takerFeeAssetData" => "0x", 
        "makerFeeAssetData" => "0x",
        "takerFee" => 0,
        "makerFee" => 0
      }
    }

    sig =
      ("0x16818763816e1aae13ee603e677cfc79e50909518bf0941ff9ed5a8e74b7b4ee50820810b3598f6d5bd90db7dd43e8992a628c1b003d13c86c0b2a3a2cde67531b")
 
    target = "0x29c76e6ad8f28bb1004902578fb108c507be341b"
    assert target == ExWeb3EcRecover.recover_typed_signature(message, sig, :v4)
  end


   test "tests hash message" do
    # This sig was genarated using Meta Mask

  msg = %Message{
    types: %{ "EIP712Domain" => [
          %{ "name" => "name", "type" => "string" },
          %{ "name" => "version", "type" => "string" },
          %{ "name" => "chainId", "type" => "uint256" },
          %{ "name" => "verifyingContract", "type" => "address" },
        ],  
          "Order" => [  
          %{ "name" => "makerAddress", "type" => "address" },
          %{ "name" => "takerAddress", "type" => "address" },
          %{ "name" => "feeRecipientAddress", "type" => "address" },
          %{ "name" => "senderAddress", "type" => "address" },
          %{ "name" => "makerAssetAmount", "type" => "uint256" },
          %{ "name" => "takerAssetAmount", "type" => "uint256" },
          %{ "name" => "makerFee", "type" => "uint256" },
          %{ "name" => "takerFee", "type" => "uint256" },
          %{ "name" => "expirationTimeSeconds", "type" => "uint256" },
          %{ "name" => "salt", "type" => "uint256" },
          %{ "name" => "makerAssetData", "type" => "bytes" },
          %{ "name" => "takerAssetData", "type" => "bytes" },
          %{ "name" => "makerFeeAssetData", "type" => "bytes" },
          %{ "name" => "takerFeeAssetData", "type" => "bytes" }]
          },
    primary_type: "Order",
    domain: %{
      "name"=>  "0x Protocol",
      "version" =>  "3.0.0",
      "chainId" =>  137,
      "verifyingContract" => "0xfede379e48c873c75f3cc0c81f7c784ad730a8f7"
    },
    message: %{
      "makerAddress" =>"0x1bbeb0a1a075d870bed8c21dfbe49a37015e4124",
      "takerAddress" => "0x0000000000000000000000000000000000000000",
      "senderAddress" => "0x0000000000000000000000000000000000000000",
      "feeRecipientAddress" => "0x0000000000000000000000000000000000000000",
      "expirationTimeSeconds" => 1641627054,
      "salt"=> 1,
      "makerAssetAmount" => 1,
      "takerAssetAmount" => 50000000000000000,
      "makerAssetData" => "0x02571792000000000000000000000000a5f1ea7df861952863df2e8d1312f7305dabf2150000000000000000000000000000000000000000000000000000000000002b5b",
      "takerAssetData" => "0xf47261b00000000000000000000000007ceb23fd6bc0add59e62ac25578270cff1b9f619",
      "takerFeeAssetData" => "0xf47261b00000000000000000000000007ceb23fd6bc0add59e62ac25578270cff1b9f619",
      "makerFeeAssetData" =>"0xf47261b00000000000000000000000007ceb23fd6bc0add59e62ac25578270cff1b9f619",
      "takerFee" =>  0,
      "makerFee" => 0
    }
  }



    encrypted = ExWeb3EcRecover.RecoverSignature.hash_eip712(msg)
    |> Base.encode16(case: :lower)

  assert  "0x493c8aaeec442571358fb4f5c39284a0f3ca40443c2e5ba693eea4615349fcf4" == "0x" <> encrypted
  end

end
