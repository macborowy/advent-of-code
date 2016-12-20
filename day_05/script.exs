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

defmodule AdvancedPassword do
  def make(seed, tail \\ 0, password_length \\ 8) do
    password_length
    |> Keylock.new
    |> do_make(seed, tail)
    |> Tuple.to_list
    |> Enum.join
  end

  defp do_make(keylock, seed, tail) do
    case Keylock.is_valid?(keylock) do
      false ->
        {new_tail, pos, value} = find_value_somehow(seed, tail)
        keylock
        |> Keylock.update(pos, value)
        |> IO.inspect
        |> do_make(seed, new_tail)
      _ ->
        keylock
    end
  end

  defp find_value_somehow(seed, tail) do
    case MD5.hash(seed <> "#{tail}") do
      "00000" <> <<pos::8>> <> <<val::8>> <> _rest when pos in 48..57 ->
        pos = <<pos>> |> String.to_integer
        {tail + 1, pos, <<val>>}
      _ -> find_value_somehow(seed, tail + 1)
    end
  end
end

defmodule Keylock do
  def new(spaces), do: Tuple.duplicate(nil, spaces)

  def update(keylock, pos, val) when elem(keylock, pos) == nil do
    put_elem(keylock, pos,val)
  end
  def update(keylock, _, _), do: keylock

  def is_valid?(keylock), do: keylock |> Tuple.to_list |> Enum.all?(&(&1!=nil))
end
