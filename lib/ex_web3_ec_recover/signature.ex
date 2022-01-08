defmodule ExWeb3EcRecover.Signature do
  @enforce_keys [:r, :s, :v_num]
  defstruct @enforce_keys

  def from_binary(signature) do
    sig_binary =
      signature
      |> String.trim_leading("0x")
      |> Base.decode16!(case: :lower)

    r = binary_part(sig_binary, 0, 32)
    s = binary_part(sig_binary, 32, 32)

    v_num =
      binary_part(sig_binary, 64, 1)
      |> :binary.decode_unsigned()

    %__MODULE__{
      r: r,
      s: s,
      v_num: v_num - 27
    }
  end
end
