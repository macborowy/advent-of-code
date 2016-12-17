defmodule Exercise do
  def walk(""), do: [{0,0}]
  def walk(str) do
    str
    |> to_moves
    |> Enum.reduce({:north, [{0, 0}]}, &reduce/2)
    |> elem(1)
    |> Enum.reverse
  end

  def distance({x, y}), do: abs(x) + abs(y)

  def first_crossroad(coordinates, answer \\ nil)
  def first_crossroad(_, answer) when not is_nil(answer), do: answer
  def first_crossroad([], nil), do: nil
  def first_crossroad([head | tail], answer) do
    answer = tail |> Enum.find(&(&1 == head))
    first_crossroad(tail, answer)
  end

  defp to_moves(str), do: str |> String.trim |> String.split(", ")

  defp reduce(<<direction::8>> <> steps, {facing, [head | _] = acc}) do
    new_direction = turn(facing, direction)
    steps = steps |> Integer.parse |> elem(0)

    result = move(head, new_direction, steps)
    {new_direction, result ++ acc}
  end

  defp turn(:north, ?L), do: :west
  defp turn(:north, ?R), do: :east
  defp turn(:west,  ?L), do: :south
  defp turn(:west,  ?R), do: :north
  defp turn(:south, ?L), do: :east
  defp turn(:south, ?R), do: :west
  defp turn(:east,  ?L), do: :north
  defp turn(:east,  ?R), do: :south

  def move(from, direction, steps) do
    func = case direction do
             :north -> fn {x, y} -> {x,     y + 1} end
             :west  -> fn {x, y} -> {x - 1, y    } end
             :south -> fn {x, y} -> {x,     y - 1} end
             :east  -> fn {x, y} -> {x + 1, y    } end
             _ -> &(&1)
           end
    do_move(from, func, steps)
  end

  defp do_move(start, func, steps, acc \\ [])
  defp do_move(_, _, 0, acc), do: acc
  defp do_move(start, func, steps, acc) do
    new_start = func.(start)
    do_move(new_start, func, steps - 1, [new_start | acc])
  end
end
