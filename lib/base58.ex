defmodule ConvertMacro do
  defmacro create_funs(alphabet) do
    alphabet = Enum.with_index(to_charlist(alphabet))

    for {x, index} <- alphabet do
      quote do
        def char_to_index(unquote(x)), do: unquote(index)
        def index_to_char(unquote(index)), do: unquote(x)
      end
    end
  end
end

defmodule Base58 do
  require ConvertMacro
  ConvertMacro.create_funs("123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz")

  @doc """
  Encodes the given integer.
  """
  def encode(x), do: encode(:binary.decode_unsigned(x), <<>>)

  @doc """
  Decodes the given string.
  """
  def decode(enc), do: :binary.encode_unsigned(decode(enc, 0))

  defp encode(0, <<>>), do: <<index_to_char(0)>>
  defp encode(0, acc), do: acc

  defp encode(x, acc) do
    encode(div(x, 58), <<index_to_char(rem(x, 58)), acc::binary>>)
  end

  defp decode(<<>>, acc), do: acc

  defp decode(<<c, rest::binary>>, acc) do
    decode(rest, acc * 58 + char_to_index(c))
  end
end
