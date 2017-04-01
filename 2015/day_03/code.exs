defmodule Delivery do
  @starting_location {0, 0}

  def visit_all(instructions) do
    instructions
    |> String.split("")
    |> Enum.reduce([@starting_location], fn direction, acc -> move(acc, direction) end)
  end

  defp move(visited = [{x, y} | _], "^"), do: [{x, y + 1} | visited]
  defp move(visited = [{x, y} | _], "<"), do: [{x - 1, y} | visited]
  defp move(visited = [{x, y} | _], "v"), do: [{x, y - 1} | visited]
  defp move(visited = [{x, y} | _], ">"), do: [{x + 1, y} | visited]
  defp move(visited, _), do: visited
end

"input.txt"
|> File.read!
|> Delivery.visit_all
|> Enum.group_by(&(&1))
|> Map.keys
|> Enum.count
|> IO.puts
