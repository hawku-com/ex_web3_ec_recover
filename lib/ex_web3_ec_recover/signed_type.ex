defmodule ExWeb3EcRecover.SignedTypedData do
  @max_depth 5
  def hash_message(message, types, primary_type) do
    encode(message, types, primary_type)
    |> ExKeccak.hash_256()
  end

  def encode(message, types, primary_type) do
    [
      encode_types(types, primary_type),
      encode_type(message, primary_type, types)
    ]
    |> :erlang.iolist_to_binary()
  end

  def encode_type(data, primary_type, spec) do
    spec[primary_type]
    |> Enum.map(fn %{"name" => name, "type" => type} ->
      value = data[name]

      if custom_type?(spec, type) do
        hash_message(value, spec, type)
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
        raise "Malformed type in spec"
    end
  end

  def encode_types(spec, primary_type) do
    sorted_deps =
      spec
      |> find_deps(primary_type)
      |> MapSet.to_list()
      |> Enum.sort()

    [primary_type | sorted_deps]
    |> Enum.map(&format_dep(&1, spec))
    |> :erlang.iolist_to_binary()
    |> ExKeccak.hash_256()
  end

  defp find_deps(spec, primary_types, acc \\ MapSet.new(), depth \\ @max_depth) do
    spec[primary_types]
    |> Enum.reduce(acc, fn %{"type" => type}, acc ->
      if custom_type?(spec, type) do
        acc = MapSet.put(acc, type)
        find_deps(spec, type, acc, depth - 1)
      else
        acc
      end
    end)
  end

  defp custom_type?(spec, type) do
    # TODO verify not a builtin type
    Map.has_key?(spec, type)
  end

  defp format_dep(dep, spec) do
    arguments =
      spec[dep]
      |> Enum.map(fn %{"name" => name, "type" => type} -> [type, " ", name] end)
      |> Enum.intersperse(",")

    [dep, "(", arguments, ")"]
  end
end
