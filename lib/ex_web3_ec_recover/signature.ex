defmodule ExWeb3EcRecover.Signature do
  @enforce_keys [:r, :s, :v_num]
  defstruct @enforce_keys


  def from_hexstring("0x"<>signature) when byte_size(signature) == 130 do
    # 65 bytes of data, each byte takes two bytes in hexstring
    sig_binary = Base.decode16!(signature, case: :lower)
    byte_size(sig_binary) |> IO.inspect(limit: :infinity)

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
