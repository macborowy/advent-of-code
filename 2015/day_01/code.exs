defmodule Exercise do
  def solve(input) do
    input
    |> String.codepoints
    |> Enum.reduce(0, &reducer/2)
  end

  def reducer("(", acc), do: acc + 1
  def reducer(")", acc), do: acc - 1
  def reducer(_, acc),   do: acc
end

"input.txt" |> File.read! |> Exercise.solve |> IO.puts 
