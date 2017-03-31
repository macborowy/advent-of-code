defmodule Script do
  def select_triangles(input) do
    input
    |> parse
    |> select
  end

  defp parse(input) do
    Regex.scan(~r/(\d+)/, input, capture: :first)
    |> List.flatten
    |> Enum.map(&String.to_integer/1)
    |> make_triangles
  end

  defp make_triangles(list) do
    # based on https://github.com/jeg2/advent_of_code_2016 idea
    Enum.concat([
      list |> Enum.take_every(3),
      list |> Enum.drop(1) |> Enum.take_every(3),
      list |> Enum.drop(2) |> Enum.take_every(3)
    ])
    |> Enum.chunk(3)
  end

  defp select(list), do: list |> Enum.filter(&is_triangle?/1)

  defp is_triangle?([a, b, c]) when a + b > c and a + c > b and b + c > a, do: true
  defp is_triangle?(_), do: false
end

System.argv
|> hd
|> File.read!
|> Script.select_triangles
|> length
|> IO.inspect
