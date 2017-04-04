defmodule Word do
  def nice?(word) when is_binary(word) do
    with true <- word |> has_enough_vowels?,
         true <- word |> has_double_letters?,
         true <- word |> has_no_disallowed_string?,
         do: true
  end

  defp has_enough_vowels?(word) do
    word
    |> String.replace(~r/[^aeiou]/, "")
    |> String.length
    |> Kernel.>=(3)
  end

  defp has_double_letters?(word), do: String.match?(word, ~r/(\p{L})\1/)

  defp has_no_disallowed_string?(word), do: not String.match?(word, ~r/(ab|cd|pq|xy)/)
end

defmodule BetterWord do
  def nice?(word) when is_binary(word) do
    with true <- word |> has_at_least_two_pairs_of_letters?,
         true <- word |> has_repeat_with_single_letter_between?,
    do: true
  end

  defp has_at_least_two_pairs_of_letters?(word), do: String.match?(word, ~r/(.{2}).*\1/)

  defp has_repeat_with_single_letter_between?(word), do: String.match?(word, ~r/(.).\1/)
end

test_input = fn func ->
  "input.txt"
  |> File.read!
  |> String.split("\n", trim: true)
  |> Enum.map(&func.(&1))
  |> Enum.filter(&(&1==true))
  |> Enum.count
  |> IO.puts
end

if System.argv == ["--run"] do
  test_input.(&Word.nice?/1)
  test_input.(&BetterWord.nice?/1)
end
