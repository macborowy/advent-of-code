defmodule Exercise do
  def delivery_floor(input), do: input |> prepare |> do_reduce(:normal) |> elem(1)

  def basement_at(input), do: input |> prepare |> do_reduce(:basement) |> elem(2)

  defp prepare(input), do: input |> String.codepoints

  defp do_reduce(enum, type), do: enum |> Enum.reduce_while({type, 0, 0}, &reducer/2)

  defp reducer(")", {:basement, 0, move}), do: {:halt, {:basement, -1, move + 1}}
  defp reducer("(", {type, acc, move}),    do: {:cont, {type, acc + 1, move + 1}}
  defp reducer(")", {type, acc, move}),    do: {:cont, {type, acc - 1, move + 1}}
  defp reducer(_,   tuple),                do: {:cont, tuple}
end

input = "input.txt" |> File.read!
input |> Exercise.delivery_floor |> IO.puts
input |> Exercise.basement_at |> IO.puts
