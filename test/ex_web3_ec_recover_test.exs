defmodule ExWeb3EcRecoverTest do
  use ExUnit.Case
  doctest ExWeb3EcRecover

  test "" do
    # sig = "0x4af1bceebf7f3634ec3cff8a2c38e51178d5d4ce585c52d6043e5e2cc3418bb0"
    sig =
      "0xf6cda8eaf5137e8cc15d48d03a002b0512446e2a7acbc576c01cfbe40ad9345663ccda8884520d98dece9a8bfe38102851bdae7f69b3d8612b9808e6337801601b"

    types = %{"Message" => [%{"name" => "data", "type" => "string"}]}
    primary_type = "Message"

    message = %{
      "data" => "test"
    }

    expected_address = "0x29c76e6ad8f28bb1004902578fb108c507be341b"

    assert expected_address ==
             ExWeb3EcRecover.RecoverPersonalSignature.recover_typed_signature(
               message,
               types,
               primary_type,
               [],
               sig,
               :v4
             )
  end
end
