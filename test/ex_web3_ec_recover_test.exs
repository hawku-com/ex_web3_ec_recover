defmodule ExWeb3EcRecoverTest do
  use ExUnit.Case

  doctest ExWeb3EcRecover

  alias ExWeb3EcRecover.SignedType.Message

  @domain %{
    "name" => "example.metamask.io",
    "version" => "3",
    "chainId" => 1,
    "verifyingContract" => "0x"
  }

  describe "recover_typed_signature/3" do
    test "Recovers address from a signature and the message" do
      # This sig was genarated using Meta Mask
      sig =
        "0xf6cda8eaf5137e8cc15d48d03a002b0512446e2a7acbc576c01cfbe40ad" <>
          "9345663ccda8884520d98dece9a8bfe38102851bdae7f69b3d8612b9808e6" <>
          "337801601b"

      message = %Message{
        types: %{
          "Message" => [%{"name" => "data", "type" => "string"}]
        },
        primary_type: "Message",
        message: %{
          "data" => "test"
        },
        domain: @domain
      }

      expected_address = "0x29c76e6ad8f28bb1004902578fb108c507be341b"

      assert expected_address ==
               ExWeb3EcRecover.recover_typed_signature(message, sig, :v4)
    end

    test "Recovers address from a signature and the message with zero V" do
      # This sig was genarated using Meta Mask
      sig =
        "0xf6cda8eaf5137e8cc15d48d03a002b0512446e2a7acbc576c01cfbe40ad" <>
          "9345663ccda8884520d98dece9a8bfe38102851bdae7f69b3d8612b9808e6" <>
          "3378016000"

      message = %Message{
        types: %{
          "Message" => [%{"name" => "data", "type" => "string"}],
        },
        primary_type: "Message",
        message: %{
          "data" => "test"
        },
        domain: @domain
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
        },
        primary_type: "Message",
        message: %{
          "data" => "test"
        },
        domain: @domain
      }

      expected_address = "0x29c76e6ad8f28bb1004902578fb108c507be341b"

      assert expected_address ==
               ExWeb3EcRecover.recover_typed_signature(message, sig, :v4)
    end

    test "Order message support" do
      message = %Message{
        types: %{
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
          "verifyingContract" => "0xfede379e48c873c75f3cc0c81f7c784ad730a8f7"
        },
        message: %{
          "makerAddress" => "0x1bbeb0a1a075d870bed8c21dfbe49a37015e4124",
          "takerAddress" => "0x0000000000000000000000000000000000000000",
          "senderAddress" => "0x0000000000000000000000000000000000000000",
          "feeRecipientAddress" => "0x0000000000000000000000000000000000000000",
          "expirationTimeSeconds" => 1_641_635_545,
          "salt" => 1,
          "makerAssetAmount" => 1,
          "takerAssetAmount" => 50_000_000_000_000_000,
          "makerAssetData" =>
            "0x02571792000000000000000000000000a5f1ea7df861952863df2e8d1312f7305dabf2150000000000000000000000000000000000000000000000000000000000002b5b",
          "takerAssetData" =>
            "0xf47261b00000000000000000000000007ceb23fd6bc0add59e62ac25578270cff1b9f619",
          "takerFeeAssetData" => "0x",
          "makerFeeAssetData" => "0x",
          "takerFee" => 0,
          "makerFee" => 0
        }
      }

      sig =
        "0x16818763816e1aae13ee603e677cfc79e50909518bf0941ff9ed5a8e74b7b4ee50820810b3598f6d5bd90db7dd43e8992a628c1b003d13c86c0b2a3a2cde67531b"

      target = "0x29c76e6ad8f28bb1004902578fb108c507be341b"
      assert target == ExWeb3EcRecover.recover_typed_signature(message, sig, :v4)
    end

    test "tests hash message" do
      # This sig was genarated using Meta Mask

      msg = %Message{
        types: %{
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
          "verifyingContract" => "0xfede379e48c873c75f3cc0c81f7c784ad730a8f7"
        },
        message: %{
          "makerAddress" => "0x1bbeb0a1a075d870bed8c21dfbe49a37015e4124",
          "takerAddress" => "0x0000000000000000000000000000000000000000",
          "senderAddress" => "0x0000000000000000000000000000000000000000",
          "feeRecipientAddress" => "0x0000000000000000000000000000000000000000",
          "expirationTimeSeconds" => 1_641_627_054,
          "salt" => 1,
          "makerAssetAmount" => 1,
          "takerAssetAmount" => 50_000_000_000_000_000,
          "makerAssetData" =>
            "0x02571792000000000000000000000000a5f1ea7df861952863df2e8d1312f7305dabf2150000000000000000000000000000000000000000000000000000000000002b5b",
          "takerAssetData" =>
            "0xf47261b00000000000000000000000007ceb23fd6bc0add59e62ac25578270cff1b9f619",
          "takerFeeAssetData" =>
            "0xf47261b00000000000000000000000007ceb23fd6bc0add59e62ac25578270cff1b9f619",
          "makerFeeAssetData" =>
            "0xf47261b00000000000000000000000007ceb23fd6bc0add59e62ac25578270cff1b9f619",
          "takerFee" => 0,
          "makerFee" => 0
        }
      }

      encrypted =
        ExWeb3EcRecover.RecoverSignature.hash_eip712(msg)
        |> Base.encode16(case: :lower)

      assert "0x493c8aaeec442571358fb4f5c39284a0f3ca40443c2e5ba693eea4615349fcf4" ==
               "0x" <> encrypted
    end

    test "Return {:error, :unsupported_version} when version is invalid" do
      # This sig was genarated using Meta Mask
      sig =
        "0xf6cda8eaf5137e8cc15d48d03a002b0512446e2a7acbc576c01cfbe40ad" <>
          "9345663ccda8884520d98dece9a8bfe38102851bdae7f69b3d8612b9808e6" <>
          "337801601b"

      message = %Message{
        types: %{
          "Message" => [%{"name" => "data", "type" => "string"}],
        },
        primary_type: "Message",
        message: %{
          "data" => "test"
        },
        domain: %{}
      }

      assert {:error, :unsupported_version} ==
               ExWeb3EcRecover.recover_typed_signature(message, sig, :v5)
    end

    test "Return {:error, :invalid_signature} when signature is invalid" do
      sig = "invalid_sig"

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

      assert {:error, :invalid_signature} ==
               ExWeb3EcRecover.recover_typed_signature(message, sig, :v4)
    end
  end

  describe "recover_personal_signature/2" do
    test "Recover address from signature when signature is valid" do
      signature =
        "0xaa69ef02d4c01b5014187a5838a00a94176505c4efb9d814d7c2179c090efc361" <>
          "c219e3849d0b996064bd28732faeefa8e303e85787171e18489cb97b1d75fd01b"

      message = "some message"

      expected_address = "0x2ff0416047e1a6c06dd2eb0195c984c787adf735"

      assert expected_address == ExWeb3EcRecover.recover_personal_signature(message, signature)
    end

    test "Return {:error, :invalid_signature} when signature is invalid" do
      signature = "some invalid signature"

      message = "some message"

      assert {:error, :invalid_signature} ==
               ExWeb3EcRecover.recover_personal_signature(message, signature)
    end
  end
end
