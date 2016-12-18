defmodule Keypad do
  def to_code(instructions) do
    instructions
    |> Instruction.to_sequence(5)
  end
end

defmodule Instruction do
  def to_sequence(instructions, from) do
    instructions
    |> parse
    |> find_sequence(from)
  end

  defp parse(instructions) do
    instructions
    |> String.trim
    |> String.split("\n")
    |> Enum.map(&String.graphemes/1)
  end

  defp find_sequence(instructions, from) do
    instructions
    |> Enum.reduce([from], &reduce_to_sequence/2)
    |> Enum.reverse
    |> tl
    |> Enum.join
  end

  defp reduce_to_sequence(moves, [from | _] = acc), do: [find_button(moves, from) | acc]

  defp find_button(moves, from), do: moves |> Enum.reduce(from, &Move.move/2)
end

defmodule Move do
  def move("U", from) when from in [4, 5, 6, 7, 8, 9], do: from - 3
  def move("D", from) when from in [1, 2, 3, 4, 5, 6], do: from + 3
  def move("L", from) when from in [2, 3, 5, 6, 8, 9], do: from - 1
  def move("R", from) when from in [1, 2, 4, 5, 7, 8], do: from + 1
  def move(_, from), do: from 
end
