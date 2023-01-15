defmodule ExWeb3EcRecover.SignedTypeTest do
  use ExUnit.Case, async: true

  alias ExWeb3EcRecover.SignedType

  describe "Encodes a message" do
    test "with single basic property" do
      types = %{"Message" => [%{"name" => "data", "type" => "string"}]}
      primary_type = "Message"

      message = %{
        "data" => "test"
      }

      # This was generated with metamask
      target =
        ("cddf41b07426e1a761f3da57e35474ae3deaa5b596306531f651c6dc1321e4fd9c22ff5f" <>
           "21f0b81b113e63f7db6da94fedef11b2119b4088b89664fb9a3cb658")
        |> String.upcase()
        |> Base.decode16!()

      assert target == SignedType.encode(message, types, primary_type)
    end

    test "with all dynamic and atomic values" do
      types = %{
        "Message" => [
          %{"name" => "data", "type" => "string"},
          %{"name" => "data1", "type" => "int8"},
          %{"name" => "data2", "type" => "uint8"},
          %{"name" => "data3", "type" => "bytes8"},
          %{"name" => "data4", "type" => "bool"},
          %{"name" => "data5", "type" => "address"}
        ]
      }

      primary_type = "Message"

      message = %{
        "data" => "test",
        "data1" => 2,
        "data2" => 3,
        "data3" => "c3f426ae",
        "data4" => false,
        "data5" => "5FF3cb18d8866541C66e4A346767a10480c4278D"
      }

      # This was generated with metamask
      target =
        ("77cf5d045714d6093f70690f1206690fca190fba3e645ede4725917151b7aaee")
        |> String.downcase()

      assert target == SignedType.hash_message(message, types, primary_type) |> Base.encode16(case: :lower)
    end

    test "containing references" do
      types = %{
        "Message" => [
          %{"name" => "data", "type" => "Test"}
        ],
        "Test" => [%{"name" => "data", "type" => "ATet"}],
        "ATet" => [%{"name" => "data", "type" => "string"}]
      }

      message = %{
        "data" => %{
          "data" => %{
            "data" => "test"
          }
        }
      }

      target =
        "d5d5d0183e58ac8883e666be66a547e0b76ecb4b4411c92695934e91ca7158ec92eec4cf0549942d6a26ace5f0728db40fa7eb3908a5120f0b88cf5472947781"
        |> String.upcase()
        |> Base.decode16!()

      assert target == SignedType.encode(message, types, "Message")
    end
  end

  describe "Encodes a type" do
    test "with only a basic property" do
      types = %{"Message" => [%{"name" => "data", "type" => "string"}]}

      target =
        <<205, 223, 65, 176, 116, 38, 225, 167, 97, 243, 218, 87, 227, 84, 116, 174, 61, 234, 165,
          181, 150, 48, 101, 49, 246, 81, 198, 220, 19, 33, 228, 253>>

      assert target == SignedType.encode_types(types, "Message")
    end

    test "with nested references" do
      types = %{
        "Message" => [
          %{"name" => "data", "type" => "string"},
          %{"name" => "data", "type" => "Test"}
        ],
        "Test" => [%{"name" => "data", "type" => "ATet"}],
        "ATet" => [%{"name" => "data", "type" => "string"}]
      }

      target =
        "7031b1a85f03f91f16cb21cc404beb084c0901db5d25302c97760c35738c61f9"
        |> String.upcase()
        |> Base.decode16!()

      assert target == SignedType.encode_types(types, "Message")
    end
  end
end
