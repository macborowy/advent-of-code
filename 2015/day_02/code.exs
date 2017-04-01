defmodule Present do
   def required_paper(dimensions), do:
     dimensions |> parse |> calculate_required_paper

   def required_ribbon(dimensions), do:
     dimensions |> parse |> calculate_required_ribbon

   defp parse(dimensions), do:
     dimensions |> String.split("x") |> Enum.map(&String.to_integer/1)

   defp calculate_required_paper(dimensions = [a, b, c]) do
     [x, y] = dimensions |> two_shortest_sides
     2 * a * b + 2 * a * c + 2 * b * c + x * y
   end

   defp calculate_required_ribbon(dimensions = [a, b, c]) do
     [x, y] = dimensions |> two_shortest_sides
     a * b * c + 2 * (x + y)
   end

   defp two_shortest_sides(dimensions), do:
     dimensions |> Enum.sort(&(&1<&2)) |> Enum.take(2)
end

input =  "input.txt" |> File.read!|> String.split("\n", trim: true)
reduce = fn enum, func -> Enum.reduce(enum, 0, &(func.(&1) + &2)) end

input |> reduce.(&Present.required_paper/1) |> IO.puts
input |> reduce.(&Present.required_ribbon/1) |> IO.puts
