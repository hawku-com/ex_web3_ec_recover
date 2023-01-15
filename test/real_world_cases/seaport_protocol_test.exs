defmodule ExWeb3EcRecover.RealWorldCases.OxProtocolTest do
  @moduledoc """

  """
  use ExUnit.Case, async: true

  alias ExWeb3EcRecover.SignedType.Message

  test "Order message support" do
    message = %Message{
      types: %{
        "ConsiderationItem" => [
          %{"name" => "itemType", "type" => "uint8"},
          %{"name" => "token", "type" => "address"},
          %{"name" => "identifierOrCriteria", "type" => "uint256"},
          %{"name" => "startAmount", "type" => "uint256"},
          %{"name" => "endAmount", "type" => "uint256"},
          %{"name" => "recipient", "type" => "address"}
        ],
        "EIP712Domain" => [
          %{"name" => "name", "type" => "string"},
          %{"name" => "version", "type" => "string"},
          %{"name" => "chainId", "type" => "uint256"},
          %{"name" => "verifyingContract", "type" => "address"}
        ],
        "OfferItem" => [
          %{"name" => "itemType", "type" => "uint8"},
          %{"name" => "token", "type" => "address"},
          %{"name" => "identifierOrCriteria", "type" => "uint256"},
          %{"name" => "startAmount", "type" => "uint256"},
          %{"name" => "endAmount", "type" => "uint256"}
        ],
        "OrderComponents" => [
          %{"name" => "offerer", "type" => "address"},
          %{"name" => "zone", "type" => "address"},
          %{"name" => "offer", "type" => "OfferItem[]"},
          %{"name" => "consideration", "type" => "ConsiderationItem[]"},
          %{"name" => "orderType", "type" => "uint8"},
          %{"name" => "startTime", "type" => "uint256"},
          %{"name" => "endTime", "type" => "uint256"},
          %{"name" => "zoneHash", "type" => "bytes32"},
          %{"name" => "salt", "type" => "uint256"},
          %{"name" => "conduitKey", "type" => "bytes32"},
          %{"name" => "counter", "type" => "uint256"}
        ]
      },
      primary_type: "OrderComponents",
      domain: %{
        "chainId" => "137",
        "name" => "Seaport",
        "verifyingContract" => "0x00000000006c3852cbef3e08e8df289169ede581",
        "version" => "1.1"
      },
      message: %{
        "conduitKey" => "0x0000000000000000000000000000000000000000000000000000000000000000",
        "consideration" => [
          %{
            "endAmount" => 10_000_000_000_000_000_000,
            "identifierOrCriteria" => 0,
            "itemType" => 0,
            "recipient" => "0x9e95cfc198e7c67686923280469b25304b3cc3e6",
            "startAmount" => 10_000_000_000_000_000_000,
            "token" => "0x0000000000000000000000000000000000000000"
          }
        ],
        "counter" => "0",
        "endTime" =>
          115_792_089_237_316_195_423_570_985_008_687_907_853_269_984_665_640_564_039_457_584_007_913_129_639_935,
        "offer" => [
          %{
            "endAmount" => 1,
            "identifierOrCriteria" => 300_881,
            "itemType" => 2,
            "startAmount" => 1,
            "token" => "0x67f4732266c7300cca593c814d46bee72e40659f"
          }
        ],
        "offerer" => "0x9e95cfc198e7c67686923280469b25304b3cc3e6",
        "orderType" => 0,
        "salt" => 1_084_436_668_484_345_387,
        "startTime" => 1_673_293_360,
        "zone" => "0x0000000000000000000000000000000000000000",
        "zoneHash" => "0x0000000000000000000000000000000000000000000000000000000000000000"
      }
    }

    assert ExWeb3EcRecover.SignedType.encode(message)
  end
end
