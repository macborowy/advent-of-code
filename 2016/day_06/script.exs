defmodule Signal do
  def decode(input, :most_common), do: input |> do_decode(&>/2)
  def decode(input, :least_common), do: input |> do_decode(&</2)

  defp do_decode(input, sort_fn) do
    input
    |> parse
    |> get_message(sort_fn)
    |> to_str
  end

  defp parse(input), do: input |> String.trim |> String.split("\n")
  defp to_str(list), do: list |> Enum.join

  defp get_message(input, sort_fn) do
    message_length = input |> message_length
    input |> most_common_letter_in_column(message_length, sort_fn)
  end

  defp message_length(input), do: input |> Enum.at(0) |> String.length

  defp most_common_letter_in_column(input, message_length, sort_fn, current_column \\ 0, acc \\ [])

  defp most_common_letter_in_column(_, max, _, current, acc) when current == max, do: Enum.reverse(acc)
  defp most_common_letter_in_column(input, max, sort_fn, current, acc) do
    most_common_letter =
      input
      |> Enum.map(&String.at(&1, current))
      |> Enum.group_by(&(&1))
      |> Enum.sort_by(fn {_, list} -> Enum.count(list) end, sort_fn)
      |> Enum.at(0)
      |> elem(0)

    most_common_letter_in_column(input, max, sort_fn, current + 1, [most_common_letter | acc])
  end
end
