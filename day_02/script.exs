defmodule Keypad do
  def to_code(instructions) do
    instructions
    |> parse
    |> find_sequence(5)
    |> to_int
  end

  defp parse(instructions) do
    instructions
    |> String.trim
    |> String.split("\n")
    |> Enum.map(&String.graphemes/1)
  end

  defp find_sequence(instructions, from) do
    instructions
    |> Enum.reduce([from], &make_sequence/2)
    |> Enum.reverse
    |> tl
  end

  defp make_sequence(moves, [from | _] = acc), do: [find_button(moves, from) | acc]

  defp find_button(moves, from), do: moves |> Enum.reduce(from, &move/2)

  defp move("U", from) when from in [4, 5, 6, 7, 8, 9], do: from - 3
  defp move("D", from) when from in [1, 2, 3, 4, 5, 6], do: from + 3
  defp move("L", from) when from in [2, 3, 5, 6, 8, 9], do: from - 1
  defp move("R", from) when from in [1, 2, 4, 5, 7, 8], do: from + 1
  defp move(_, from), do: from

  defp to_int(sequence), do: sequence |> Enum.join |> String.to_integer
end
