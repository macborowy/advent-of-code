defmodule MD5 do
  def hash(text), do: text |> :erlang.md5 |> Base.encode16
end

defmodule Password do
  def make(seed, password_length \\ 8), do: do_make(seed, password_length)

  defp do_make(seed, password_length, tail \\ 0, acc \\ [])

  defp do_make(_, length, _, acc) when length(acc) == length, do: acc |> Enum.reverse |> List.to_string
  defp do_make(seed, length, tail, acc) do
    case MD5.hash(seed <> "#{tail}") do
      "00000" <> <<x::8>> <> _rest -> do_make(seed, length, tail + 1, [<<x>> | acc])
      _                            -> do_make(seed, length, tail + 1, acc)
    end
  end
end
