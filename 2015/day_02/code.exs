defmodule Present do
   def required_paper(dimensions) do
     dimensions
     |> parse
     |> calculate
   end

   defp parse(dimensions) do
     dimensions |> String.split("x") |> Enum.map(&String.to_integer/1)
   end

   defp calculate(dimensions = [a, b, c]) do
      2*a*b + 2*a*c + 2*b*c + slack(dimensions)
   end

   defp slack(dimensions) do
      [a, b, _] = dimensions |> Enum.sort(&(&1<&2))
      a * b
   end
end

"input.txt"
|> File.read!
|> String.split("\n", trim: true)
|> Enum.reduce(0, fn (x, acc) -> acc + Present.required_paper(x) end)
|> IO.puts
