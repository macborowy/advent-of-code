defmodule Script do
  def get_sum_of_sectors(input) do
    input
    |> parse
    |> Enum.filter(&Room.is_real?/1)
    |> Enum.reduce(0, fn (encrypted_name, acc) -> encrypted_name |> Room.sector |> Kernel.+(acc) end)
  end

  defp parse(input), do: input |> String.trim |> String.split("\n")
end

defmodule Room do
  def is_real?(encrypted_name) do
    checksum = encrypted_name |> checksum
    cipher = encrypted_name |> Cipher.create

    cipher == checksum
  end

  def sector(input) do
    Regex.run(~r/\-(\d+)\[/, input, capture: :all_but_first)
    |> List.first
    |> String.to_integer
  end

  defp checksum(input), do: Regex.run(~r/\[(\w+)\]/, input, capture: :all_but_first) |> List.first
end

defmodule Cipher do
  def create(input) do
    input
    |> parse
    |> get_most_common_letters
    |> to_cipher
  end

  defp parse(input) do
    input
    |> String.replace(~r/[^a-z]/, "")
    |> to_charlist
    |> Enum.drop(-5)
  end

  defp get_most_common_letters(charlist) do
    charlist
    |> Enum.group_by(&(&1))
    |> Enum.sort_by(fn {_, list} -> list |> length end, &>=/2)
    |> Enum.take(5)
  end

  defp to_cipher(list) do
    list
    |> Enum.reduce([], fn ({letter, _}, acc) -> [letter | acc] end)
    |> Enum.reverse
    |> List.to_string
  end
end
