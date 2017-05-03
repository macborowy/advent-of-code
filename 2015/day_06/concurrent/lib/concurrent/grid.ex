defmodule Concurrent.Grid do
  def new(default \\ 0) do
    1..1_000
    |> Enum.map(fn _ ->
      1..1000
      |> Enum.map(fn _ -> default end)
    end)
  end

  def split_rows(grid, from, length), do: split_list(grid, from, length)

  def split_columns(row, from, length), do: split_list(row, from, length)

  defp split_list(list, from, length) do
    {head, rest} = list |> Enum.split(from)
    {to_change, tail} = rest |> Enum.split(length)

    {head, to_change, tail}
  end
end
