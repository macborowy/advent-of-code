defmodule Keypad do
  def to_code(instructions, shape), do: instructions |> Instruction.to_sequence(shape)
end

defmodule Instruction do
  def to_sequence(instructions, shape, from \\ "5") do
    instructions
    |> parse
    |> find_sequence(from, shape)
  end

  defp parse(instructions) do
    instructions
    |> String.trim
    |> String.split("\n")
    |> Enum.map(&String.graphemes/1)
  end

  defp find_sequence(instructions, from, shape) do
    instructions
    |> Enum.reduce([from], &(reduce_to_sequence(&1, &2, shape)))
    |> Enum.reverse
    |> tl
    |> Enum.join
  end

  defp reduce_to_sequence(moves, [from | _] = acc, shape), do: [find_button(moves, from, shape) | acc]

  defp find_button(moves, from, shape) do
    moves
    |> Enum.reduce(from, fn (m, acc) -> Move.move(m, acc, shape) end)
  end
end

defmodule Move do
  def move("U", from, :rectangle) when from in ["4", "5", "6", "7", "8", "9"], do: do_move(from, &(&1 - 3))
  def move("D", from, :rectangle) when from in ["1", "2", "3", "4", "5", "6"], do: do_move(from, &(&1 + 3))
  def move("L", from, :rectangle) when from in ["2", "3", "5", "6", "8", "9"], do: do_move(from, &(&1 - 1))
  def move("R", from, :rectangle) when from in ["1", "2", "4", "5", "7", "8"], do: do_move(from, &(&1 + 1))

  def move("L", from, :diamond) when from in ["3", "4", "6", "7", "8", "9", "B", "C"], do:
  do_move(from, &(&1 - 1))
  def move("R", from, :diamond) when from in ["2", "3", "5", "6", "7", "8", "A", "B"], do:
  do_move(from, &(&1 + 1))

  def move("U", "3",  :diamond), do: "1"
  def move("U", from, :diamond) when from in ["6", "7", "8"], do: do_move(from, &(&1 - 4))
  def move("U", from, :diamond) when from in ["A", "B", "C"], do: do_move(from, &(&1 - 4 - 7))
  def move("U", "D",  :diamond), do: "B"

  def move("D", "1",  :diamond), do: "3"
  def move("D", from, :diamond) when from in ["2", "3", "4"], do: do_move(from, &(&1 + 4))
  def move("D", from, :diamond) when from in ["6", "7", "8"], do: do_move(from, &(&1 + 4 + 7))
  def move("D", "B",  :diamond), do: "D"

  def move(_move, from, _keypad_shape), do: from

  defp do_move(from, func) do
    from
    |> to_charlist
    |> hd
    |> func.()
    |> to_button
  end

  defp to_button(value), do: <<value>>
end
