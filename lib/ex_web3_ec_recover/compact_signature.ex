defmodule ExWeb3EcRecover.CompactSignature do
  @moduledoc false
  @enforce_keys [:r, :y_parity_and_s]
  defstruct @enforce_keys

  @type t :: %__MODULE__{
          r: binary(),
          y_parity_and_s: binary()
        }

  @spec from_hexstring(binary()) :: ExWeb3EcRecover.CompactSignature.t()
  def from_hexstring("0x" <> signature) when byte_size(signature) == 64 do
    <<r::binary-size(256), y_parity_and_s::binary-size(256)>> = Base.decode16!(signature)

    %__MODULE__{
      r: r,
      y_parity_and_s: y_parity_and_s
    }
  end

  @spec from_canonical(ExWeb3EcRecover.Signature.t()) :: ExWeb3EcRecover.CompactSignature.t()
  def from_canonical(%ExWeb3EcRecover.Signature{} = sig) do
    y_parity = sig.v_num
    <<s::size(256)>> = sig.s
    y_parity_and_s = Bitwise.bor(Bitwise.bsl(y_parity, 255), s)

    %__MODULE__{
      r: sig.r,
      y_parity_and_s: <<y_parity_and_s::size(256)>>
    }
  end

  @spec serialize(__MODULE__.t()) :: binary()
  def serialize(%__MODULE__{} = cs) do
    cs.r <> cs.y_parity_and_s
  end
end
