defmodule Word do
  @parameter_error "parameter is not binary."
  @vowels_error "has not enough vowels"
  @double_letters_error "has no double letters"
  @disallowed_string_error "contains disallowed string"

  def nice?(word) when is_binary(word) do
    with :ok <- has_enough_vowels?(word),
         :ok <- has_double_letters?(word),
         :ok <- not_contain_disallowed_string(word),
         do: true
  end
  def nice?(_), do: {:err, @parameter_error}

  defp has_enough_vowels?(word) do
    result =
      word
      |> String.replace(~r/[^aeiou]/, "")
      |> String.length
      |> Kernel.>=(3)

    if result, do: :ok, else: {:err, @vowels_error}
  end

  defp has_double_letters?(word) do
    case String.match?(word, ~r/(\p{L})\1/) do
      true -> :ok
      _    -> {:err, @double_letters_error}
    end
  end

  defp not_contain_disallowed_string(word) do
    case String.match?(word, ~r/(ab|cd|pq|xy)/) do
      true -> {:err, @disallowed_string_error}
      _    -> :ok
    end
  end
end

defmodule BetterWord do
  @no_pairs_of_two_letters "has no pairs of two letters"
  @no_repeat_letter "has no letter that repeats with exactly one letter between them"

  def nice?(word) do
    with :ok <- has_at_least_two_pairs_of_letters?(word),
         :ok <- has_repeat_with_single_letter_between?(word),
    do: true
  end

  def has_at_least_two_pairs_of_letters?(word) do
    case word |> String.match?(~r/(.{2}).*\1/) do
      true -> :ok
      _    -> {:err, @no_pairs_of_two_letters}
    end
  end

  def has_repeat_with_single_letter_between?(word) do
    case word |> String.match?(~r/(.).\1/) do
      true -> :ok
      _    -> {:err, @no_repeat_letter}
    end
  end
end

test_input = fn func ->
  "input.txt"
  |> File.read!
  |> String.split("\n", trim: true)
  |> Enum.map(&func.(&1))
  |> Enum.filter(&(&1==true))
  |> Enum.count
end

if System.argv == ["--run"] do
  part_1 = test_input.(&Word.nice?/1)
  part_2 = test_input.(&BetterWord.nice?/1)

  IO.puts "Number of nice string for part 1 rules: #{part_1}"
  IO.puts "Number of nice string for part 1 rules: #{part_2}"
end
