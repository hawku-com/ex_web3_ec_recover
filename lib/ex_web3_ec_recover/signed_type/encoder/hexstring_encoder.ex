defmodule ExWeb3EcRecover.SignedType.HexStringEncoder do
  @behaviour ExWeb3EcRecover.SignedType.Encoder

  def encode_value("int" <> bytes_length, value),
    do: encode_value_atomic("int", bytes_length, value)

  def encode_value("uint" <> bytes_length, value),
    do: encode_value_atomic("uint", bytes_length, value)

  def encode_value("bytes" <> _bytes_length, value),
    do: encode_value("bytes", value)

  def encode_value("bool", value),
    do: ABI.TypeEncoder.encode_raw([value], [:bool])

  def encode_value("string", value), do: ExKeccak.hash_256(value)

  def encode_value("bytes", value) do
    value
    |> ExWeb3EcRecover.parse_hex()
    |> ExKeccak.hash_256()
  end

  def encode_value("address", value) do
    value = ExWeb3EcRecover.parse_hex(value)
    ABI.TypeEncoder.encode_raw([value], [:address])
  end

  def encode_value_atomic(type, bytes_length, value) do
    case Integer.parse(bytes_length) do
      {number, ""} ->
        ABI.TypeEncoder.encode_raw([value], [{String.to_existing_atom(type), number}])

      :error ->
        raise "Malformed type in types"
    end
  end
end
