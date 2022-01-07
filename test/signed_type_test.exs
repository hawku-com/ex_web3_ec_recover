defmodule ExWeb3EcRecover.SignedTypedDataTest do
  use ExUnit.Case, async: true

  alias ExWeb3EcRecover.SignedTypedData

  test "Encodes a simple message" do
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

    assert target == SignedTypedData.encode(message, types, primary_type)
  end

  test "Encodes a simple type" do
    spec = %{"Message" => [%{"name" => "data", "type" => "string"}]}

    target =
      <<205, 223, 65, 176, 116, 38, 225, 167, 97, 243, 218, 87, 227, 84, 116, 174, 61, 234, 165,
        181, 150, 48, 101, 49, 246, 81, 198, 220, 19, 33, 228, 253>>

    assert target == SignedTypedData.encode_types(spec, "Message")
  end

  test "Encodes type with references" do
    spec = %{
      "Message" => [%{"name" => "data", "type" => "Test"}, %{"name" => "data", "type" => "ATest"}],
      "Test" => [%{"name" => "data", "type" => "string"}],
      "ATest" => [%{"name" => "data", "type" => "string"}]
    }

    target =
      <<230, 128, 231, 58, 29, 152, 213, 193, 76, 198, 57, 141, 140, 221, 114, 248, 168, 91, 178,
        243, 130, 213, 123, 82, 11, 206, 99, 66, 39, 146, 241, 137>>

    assert target == SignedTypedData.encode_types(spec, "Message")
  end
end
