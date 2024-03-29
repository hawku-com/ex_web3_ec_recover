defmodule ExWeb3EcRecover.SignedType do
  @moduledoc """
  This module was written based on nomenclature
  and algorithm specified in the [EIP-712](https://eips.ethereum.org/EIPS/eip-712#specification)
  """

  defmodule Encoder do
    @moduledoc false
    @callback encode_value(value :: any(), type :: String.t()) :: binary()
  end

  @default_encoder __MODULE__.HexStringEncoder

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
  @spec hash_message(map(), types(), String.t(), Keyword.t()) :: hash :: binary()
  def hash_message(message, types, primary_type, opts \\ []) do
    encode(message, types, primary_type, opts)
    |> ExKeccak.hash_256()
  end

  def encode(message, opts \\ []) do
    encode(message.message, message.types, message.primary_type, opts)
  end

  @doc """
  Encodes a message according to EIP-712
  """
  @spec encode(map(), [field()], String.t(), Keyword.t()) :: binary()
  def encode(message, types, primary_type, opts \\ []) do
    encoder = Keyword.get(opts, :encoder, @default_encoder)

    array? = is_array_type?(primary_type)
    primary_type = String.trim_trailing(primary_type, "[]")

    if array? do
      encode_array(message, primary_type, types, opts)
    else
      [
        encode_types(types, primary_type),
        encode_type(message, primary_type, types, encoder)
      ]
      |> :erlang.iolist_to_binary()
    end
  end

  def encode_array(data, primary_type, types, opts) do
    Enum.map_join(data, fn single_struct ->
      hash_message(single_struct, types, primary_type, opts)
    end)
  end

  @spec encode_type(map(), String.t(), types(), module()) :: binary()
  def encode_type(data, primary_type, types, encoder) do
    types[String.trim_trailing(primary_type, "[]")]
    |> Enum.map_join(fn %{"name" => name, "type" => type} ->
      value = data[name]

      if custom_type?(types, type) do
        hash_message(value, types, type)
      else
        encoder.encode_value(type, value)
      end
    end)
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
        type = String.trim_trailing(type, "[]")
        acc = MapSet.put(acc, type)
        find_deps(types, type, acc, depth - 1)
      else
        acc
      end
    end)
  end

  defp custom_type?(types, type) do
    # TODO verify not a builtin type
    Map.has_key?(types, String.trim_trailing(type, "[]"))
  end

  defp is_array_type?(type), do: String.ends_with?(type, "[]")

  defp format_dep(dep, types) do
    arguments =
      types[dep]
      |> Enum.map(fn %{"name" => name, "type" => type} -> [type, " ", name] end)
      |> Enum.intersperse(",")

    [dep, "(", arguments, ")"]
  end
end
