defmodule ExWeb3EcRecover.SignedType.HexStringEncoder do
  @moduledoc """
  This module defines an encoder that expects all binaries to be
  to be hexstrings.
  """

  @behaviour ExWeb3EcRecover.SignedType.Encoder

  def encode_value("string", value), do: ExKeccak.hash_256(value)

  def encode_value("bytes", value) do
    value
    |> EthereumSignatures.parse_hex()
    |> ExKeccak.hash_256()
  end

  def encode_value("int" <> bytes_length, value) when is_number(value),
    do: encode_value_atomic("int", bytes_length, value)

  def encode_value("uint" <> bytes_length, value) when is_number(value),
    do: encode_value_atomic("uint", bytes_length, value)

  def encode_value("int" <> bytes_length, value) when is_binary(value),
    do: encode_value_atomic("int", bytes_length, String.to_integer(value))

  def encode_value("uint" <> bytes_length, value) when is_binary(value),
    do: encode_value_atomic("uint", bytes_length, String.to_integer(value))

  def encode_value("bytes" <> bytes_length, value) do
    value = EthereumSignatures.parse_hex(value)
    encode_value_atomic("bytes", bytes_length, value)
  end

  def encode_value("bool", value),
    do: ABI.TypeEncoder.encode_raw([value], [:bool], :standard)

  def encode_value("address", value) do
    value = EthereumSignatures.parse_hex(value)
    ABI.TypeEncoder.encode_raw([value], [:address], :standard)
  end

  def encode_value_atomic(type, bytes_length, value) do
    case Integer.parse(bytes_length) do
      {number, ""} ->
        ABI.TypeEncoder.encode_raw([value], [{String.to_existing_atom(type), number}], :standard)

      :error ->
        raise "Malformed type `#{type}` in types, with value #{value}"
    end
  end
end
