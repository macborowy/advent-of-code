defmodule Exercise do
  def solve(input) do
    input
    |> String.codepoints
    |> Enum.reduce(0, &reducer/2)
  end

  def basement_at(input) do
    input
    |> String.graphemes
    |> Enum.reduce_while({0, 0}, &while_reducer/2)
    |> elem(1)
  end

  def reducer("(", acc), do: acc + 1
  def reducer(")", acc), do: acc - 1
  def reducer(_, acc),   do: acc

  def while_reducer(")", {0,   move}),   do: {:halt, {-1, move + 1}}
  def while_reducer("(", {acc, move}),   do: {:cont, {acc + 1, move + 1}}
  def while_reducer(")", {acc, move}),   do: {:cont, {acc - 1, move + 1}}
  def while_reducer(_,   tuple),         do: {:cont, tuple}
end

input = "input.txt" |> File.read!
input |> Exercise.solve |> IO.puts
input |> Exercise.basement_at |> IO.puts
