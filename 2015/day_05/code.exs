defmodule Word do
  @vowels_reason "hasn't enough vowels (minimum 3 different)"

  def nice?(word) when is_binary(word) do
    nice? =
      word
      |> has_enough_vowels?

    case nice? do
      {:ok, _} -> true
      error -> error
    end
  end
  def nice?(_), do: {:err, "Parameter is not binary."}

  defp has_enough_vowels?(word) do
    nice? =
      word
      |> String.replace(~r/[^aeiou]/, "")
      |> to_charlist
      |> Enum.group_by(&(&1))
      |> Map.keys
      |> length
      |> Kernel.>=(3)

    if nice?, do: {:ok, word}, else: {:err, @vowels_reason}
  end
end

if System.argv == ["--run"] do
  input = "input.txt" |> File.read!
end
