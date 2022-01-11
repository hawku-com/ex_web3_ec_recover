defmodule ExWeb3EcRecover.RealWorldCases.OxProtocolTest do
  @moduledoc """
  This module contains tests that validate the project against
  0x Protocol.

  https://github.com/0xProject/0x-protocol-specification/blob/master/v3/v3-specification.md
  """
  use ExUnit.Case, async: true

  alias ExWeb3EcRecover.SignedType.Message

  # https://github.com/0xProject/0x-protocol-specification/blob/master/v3/v3-specification.md#order-message-format
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
          "0xfede379e48c873c75f3cc0c81f7c784ad730a8f7" |> ExWeb3EcRecover.parse_hex()
      },
      message: %{
        "makerAddress" =>
          "0x1bbeb0a1a075d870bed8c21dfbe49a37015e4124" |> ExWeb3EcRecover.parse_hex(),
        "takerAddress" =>
          "0x0000000000000000000000000000000000000000" |> ExWeb3EcRecover.parse_hex(),
        "senderAddress" =>
          "0x0000000000000000000000000000000000000000" |> ExWeb3EcRecover.parse_hex(),
        "feeRecipientAddress" =>
          "0x0000000000000000000000000000000000000000" |> ExWeb3EcRecover.parse_hex(),
        "expirationTimeSeconds" => 1_641_635_545,
        "salt" => 1,
        "makerAssetAmount" => 1,
        "takerAssetAmount" => 50_000_000_000_000_000,
        "makerAssetData" =>
          ("02571792000000000000000000000000a5f1ea7df861952863df2e8d1312f7305d" <>
             "abf215000000000000000000000000000000000000000000000000000000000000" <>
             "2b5b")
          |> ExWeb3EcRecover.parse_hex(),
        "takerAssetData" =>
          "0xf47261b00000000000000000000000007ceb23fd6bc0add59e62ac25578270cff1b9f619"
          |> ExWeb3EcRecover.parse_hex(),
        "takerFeeAssetData" => "0x" |> ExWeb3EcRecover.parse_hex(),
        "makerFeeAssetData" => "0x" |> ExWeb3EcRecover.parse_hex(),
        "takerFee" => 0,
        "makerFee" => 0
      }
    }

    sig =
      "0x16818763816e1aae13ee603e677cfc79e50909518bf0941ff9ed5a8e74b7b4ee50" <>
        "820810b3598f6d5bd90db7dd43e8992a628c1b003d13c86c0b2a3a2cde67531b"

    target = "0x29c76e6ad8f28bb1004902578fb108c507be341b"
    assert target == ExWeb3EcRecover.recover_typed_signature(message, sig, :v4)
  end
end
