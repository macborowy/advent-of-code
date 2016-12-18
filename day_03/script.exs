defmodule Script do
  def select_triangles(input) do
    input
    |> String.split("\n")
    |> Enum.map(&get_sides/1)
    |> Enum.filter(&is_triangle?/1)
  end

  defp get_sides(""), do: [0, 0, 0]
  defp get_sides(str) do
    Regex.run(~r/\s+(\d{1,3})\s+(\d{1,3})\s+(\d{1,3})/, str)
    |> tl
    |> Enum.map(&String.to_integer/1)
  end

  defp is_triangle?([a, b, c]) when a + b > c and a + c > b and b + c > a, do: true
  defp is_triangle?(_), do: false
end

System.argv
|> hd
|> File.read!
|> Script.select_triangles
|> length
|> IO.inspect
