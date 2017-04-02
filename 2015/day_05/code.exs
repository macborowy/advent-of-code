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

if System.argv == ["--run"] do
  "input.txt"
  |> File.read!
  |> String.split("\n", trim: true)
  |> Enum.map(&Word.nice?/1)
  |> Enum.filter(&(&1==true))
  |> Enum.count
  |> IO.puts
end
