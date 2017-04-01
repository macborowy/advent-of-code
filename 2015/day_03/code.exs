defmodule Delivery do
  @starting_location {0, 0}

  def start(location \\ {0, 0}), do: [location]

  def move(visited_locations = [{x, y} | _], "^"), do: [{x, y + 1} | visited_locations]
  def move(visited_locations = [{x, y} | _], "<"), do: [{x - 1, y} | visited_locations]
  def move(visited_locations = [{x, y} | _], "v"), do: [{x, y - 1} | visited_locations]
  def move(visited_locations = [{x, y} | _], ">"), do: [{x + 1, y} | visited_locations]
  def move(visited_locations, _), do: visited_locations

  def visit_all(instructions) do
    instructions
    |> String.split("")
    |> Enum.reduce([@starting_location], fn direction, acc -> move(acc, direction) end)
  end
end

"input.txt"
|> File.read!
|> Delivery.visit_all
|> Enum.group_by(&(&1))
|> Map.keys
|> Enum.count
|> IO.puts
