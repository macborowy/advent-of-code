defmodule Signal do
  def decode(input, :most_common), do: input |> do_decode(&>/2)
  def decode(input, :least_common), do: input |> do_decode(&</2)

  defp do_decode(input, sort_fn) do
    input
    |> parse
    |> most_common_letter_in_columns(sort_fn)
    |> to_str
  end

  defp parse(input), do: input |> String.trim |> String.split("\n")
  defp to_str(list), do: list |> Enum.join

  defp most_common_letter_in_columns(input, sort_fn) do
    result_length = input |> result_length
    input |> do_most(result_length, 0, sort_fn, [])
  end

  defp result_length(input), do: input |> Enum.at(0) |> String.length

  defp do_most(_, max, current, _, acc) when max == current, do: Enum.reverse(acc)
  defp do_most(input, max_column, current_column, sort_fn, acc) do
    most_common_char =
      input
      |> Enum.map(&String.at(&1, current_column))
      |> Enum.group_by(&(&1))
      |> Enum.sort_by(fn {_, list} -> Enum.count(list) end, sort_fn)
      |> Enum.at(0)
      |> elem(0)

    do_most(input, max_column, current_column + 1, sort_fn, [most_common_char | acc])
  end
end
