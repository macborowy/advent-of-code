defmodule Delivery do
  @starting_location {0, 0}

  def visit_all(instructions) when is_list(instructions) do
    instructions |> Enum.reduce([@starting_location], &move/2)
  end

  def visit_all(instructions) when is_binary(instructions) do
    instructions |> String.split("") |> visit_all
  end

  def visit_all(instructions, [help: :robosanta]) do
    instructions
    |> String.split("")
    |> separate
    |> Enum.map(&visit_all/1)
    |> List.flatten
  end

  def visit_all(_, keywords) do
     IO.warn("Unknown keywords #{inspect(keywords)}. Currently supported keyword is [help: :robosanta].")
     []
  end

  defp move("^", visited = [{x, y} | _]), do: [{x, y + 1} | visited]
  defp move("<", visited = [{x, y} | _]), do: [{x - 1, y} | visited]
  defp move("v", visited = [{x, y} | _]), do: [{x, y - 1} | visited]
  defp move(">", visited = [{x, y} | _]), do: [{x + 1, y} | visited]
  defp move(_,   visited), do: visited

  defp separate(instructions = [_ | rest]) do
    santa_path = instructions |> Enum.take_every(2)
    robosanta_path = rest |> Enum.take_every(2)
    [santa_path, robosanta_path]
  end
end

input = "input.txt" |> File.read!
parse_results = fn enum -> enum |> Enum.group_by(&(&1)) |> Map.keys |> Enum.count end

input |> Delivery.visit_all                   |> parse_results.() |> IO.puts
input |> Delivery.visit_all(help: :robosanta) |> parse_results.() |> IO.puts
