defmodule ExWeb3EcRecover.CompactSignatureTest do
  @moduledoc false
  # Test data provided by https://eips.ethereum.org/EIPS/eip-2098#example-implementation-in-python
  use ExUnit.Case, async: true

  test "parity 0" do
    sig =
      "0x68a020a209d3d56c46f38cc50a33f704f4a9a10a59377f8dd762ac66910e9b907e865ad05c4035ab5792787d4a0297a43617ae897930a6fe4d822b8faea520641b"

    canon = ExWeb3EcRecover.Signature.from_hexstring(sig)
    result = ExWeb3EcRecover.CompactSignature.from_canonical(canon)

    assert Base.encode16(result.r, case: :lower) ==
             "68a020a209d3d56c46f38cc50a33f704f4a9a10a59377f8dd762ac66910e9b90"

    assert Base.encode16(result.y_parity_and_s, case: :lower) ==
             "7e865ad05c4035ab5792787d4a0297a43617ae897930a6fe4d822b8faea52064"
  end

  test "parity 1" do
    sig =
      "0x9328da16089fcba9bececa81663203989f2df5fe1faa6291a45381c81bd17f76139c6d6b623b42da56557e5e734a43dc83345ddfadec52cbe24d0cc64f5507931c"

    canon = ExWeb3EcRecover.Signature.from_hexstring(sig)
    result = ExWeb3EcRecover.CompactSignature.from_canonical(canon)

    assert Base.encode16(result.r, case: :lower) ==
             "9328da16089fcba9bececa81663203989f2df5fe1faa6291a45381c81bd17f76"

    assert Base.encode16(result.y_parity_and_s, case: :lower) ==
             "939c6d6b623b42da56557e5e734a43dc83345ddfadec52cbe24d0cc64f550793"
  end
end
