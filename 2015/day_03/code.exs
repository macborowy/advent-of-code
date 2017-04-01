defmodule Delivery do
  @starting_location {0, 0}

  def visit_all(instructions) when is_binary(instructions) do
    instructions
    |> String.split("")
    |> Enum.reduce([@starting_location], fn direction, acc -> move(acc, direction) end)
  end

  def visit_all(instructions) when is_list(instructions) do
    instructions |> Enum.reduce([@starting_location], fn direction, acc -> move(acc, direction) end)
  end

  def visit_all(instructions, [help: :robosanta]) do
    {santa, robosanta} = instructions |> String.split("") |> separate
    visited_by_santa = santa |> visit_all
    visited_by_robosanta = robosanta |> visit_all

    Enum.concat(visited_by_santa, visited_by_robosanta)
  end

  def visit_all(_, keywords) do
     IO.warn("Unknown keywords #{inspect(keywords)}.")
     []
  end

  # TODO: reverse parameters order and simplify Enum.reduce to ([], &move/2)
  defp move(visited = [{x, y} | _], "^"), do: [{x, y + 1} | visited]
  defp move(visited = [{x, y} | _], "<"), do: [{x - 1, y} | visited]
  defp move(visited = [{x, y} | _], "v"), do: [{x, y - 1} | visited]
  defp move(visited = [{x, y} | _], ">"), do: [{x + 1, y} | visited]
  defp move(visited, _), do: visited

  defp separate(instructions = [_ | rest]) do
    santa_path = instructions |> Enum.take_every(2)
    robosanta_path = rest |> Enum.take_every(2)

    {santa_path, robosanta_path}
  end
end

input = "input.txt" |> File.read!
parse_results = fn enum -> enum |> Enum.group_by(&(&1)) |> Map.keys |> Enum.count end

input |> Delivery.visit_all |> parse_results.() |> IO.puts
input |> Delivery.visit_all(help: :robosanta) |> parse_results.() |> IO.puts
