defmodule ExWeb3EcRecover.SignedType do
  @moduledoc """
  This module was written based on nomenclature
  and algorithm specified in the [EIP-712](https://eips.ethereum.org/EIPS/eip-712#specification)
  """

  @max_depth 5

  @typedoc """
  The map shape of this field must conform to:
  ```
  %{
    "name" => String.t(),
    "type" => String.t()
  }
  ```
  """
  @type field :: %{String.t() => String.t()}

  @type types :: %{String.t() => [field()]}

  @doc """
  Returns a hash of a message.
  """
  @spec hash_message(map(), types(), String.t()) :: hash :: binary()
  def hash_message(message, types, primary_type) do
    encode(message, types, primary_type)
    |> ExKeccak.hash_256()
  end

  @doc """
  Encodes a message according to EIP-712
  """
  @spec encode(map(), [field()], String.t()) :: binary()
  def encode(message, types, primary_type) do
    [
      encode_types(types, primary_type),
      encode_type(message, primary_type, types)
    ]
    |> :erlang.iolist_to_binary()
  end

  @spec encode_type(map(), String.t(), types()) :: binary()
  def encode_type(data, primary_type, types) do
    types[primary_type]
    |> Enum.map(fn %{"name" => name, "type" => type} ->
      value = data[name]

      if custom_type?(types, type) do
        hash_message(value, types, type)
      else
        encode_data(type, value)
      end
    end)
    |> Enum.join()
  end

  defp encode_data(type, value) when type in ["bytes", "string"], do: ExKeccak.hash_256(value)

  defp encode_data("int" <> bytes_length, value),
    do: encode_atomic("int", bytes_length, value)

  defp encode_data("uint" <> bytes_length, value),
    do: encode_atomic("uint", bytes_length, value)

  defp encode_data("bytes" <> bytes_length, value),
    do: encode_atomic("bytes", bytes_length, value)

  defp encode_data("bool", value),
    do: ABI.TypeEncoder.encode_raw([value], [:bool])

  defp encode_data("address", value),
    do: ABI.TypeEncoder.encode_raw([value], [:address])

  defp encode_atomic(type, bytes_length, value) do
    case Integer.parse(bytes_length) do
      {number, ""} ->
        ABI.TypeEncoder.encode_raw([value], [{String.to_existing_atom(type), number}])

      :error ->
        raise "Malformed type in types"
    end
  end

  def encode_types(types, primary_type) do
    sorted_deps =
      types
      |> find_deps(primary_type)
      |> MapSet.to_list()
      |> Enum.sort()

    [primary_type | sorted_deps]
    |> Enum.map(&format_dep(&1, types))
    |> :erlang.iolist_to_binary()
    |> ExKeccak.hash_256()
  end

  defp find_deps(types, primary_types, acc \\ MapSet.new(), depth \\ @max_depth) do
    types[primary_types]
    |> Enum.reduce(acc, fn %{"type" => type}, acc ->
      if custom_type?(types, type) do
        acc = MapSet.put(acc, type)
        find_deps(types, type, acc, depth - 1)
      else
        acc
      end
    end)
  end

  defp custom_type?(types, type) do
    # TODO verify not a builtin type
    Map.has_key?(types, type)
  end

  defp format_dep(dep, types) do
    arguments =
      types[dep]
      |> Enum.map(fn %{"name" => name, "type" => type} -> [type, " ", name] end)
      |> Enum.intersperse(",")

    [dep, "(", arguments, ")"]
  end
end
