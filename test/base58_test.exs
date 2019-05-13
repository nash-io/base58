defmodule Base58Test do
  use ExUnit.Case

  test "encode" do
    assert Base58.encode(<<0>>) == "1"
    assert Base58.encode(<<57>>) == "z"
    assert Base58.encode(:binary.encode_unsigned(1024)) == "Jf"
    assert Base58.encode(:binary.encode_unsigned(123_456_789)) == "BukQL"
  end

  test "decode" do
    assert Base58.decode("1") == <<0>>
    assert Base58.decode("z") == <<57>>
    assert Base58.decode("Jf") == :binary.encode_unsigned(1024)
    assert Base58.decode("BukQL") == :binary.encode_unsigned(123_456_789)
  end
end
