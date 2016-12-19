defmodule Script do
  def get_sum_of_sectors(input) do
    input
    |> parse
    |> filter_real_rooms
    |> Enum.reduce(0, fn (encrypted_name, acc) -> encrypted_name |> Room.sector |> Kernel.+(acc) end)
  end

  def get_real_room_names(input) do
    input
    |> parse
    |> filter_real_rooms
    |> Enum.map(&Room.encrypted_name/1)
    |> Enum.map(&Room.real_name/1)
  end

  defp parse(input), do: input |> String.trim |> String.split("\n")

  defp filter_real_rooms(list), do: list |> Enum.filter(&Room.is_real?/1)
end

defmodule Room do
  def real_name(encrypted_name) do
    sector = encrypted_name |> sector

    real_name =
      encrypted_name
      |> String.split_at(-3)
      |> elem(0)
      |> String.replace("-", " ")
      |> String.trim
      |> String.graphemes
      |> Enum.map(fn letter -> Shift.forward(letter, sector) end)
      |> List.to_string

    {real_name, sector}
  end

  def is_real?(encrypted_name) do
    checksum = encrypted_name |> checksum
    cipher = encrypted_name |> Cipher.create

    cipher == checksum
  end

  def sector(encrypted_name) do
    Regex.run(~r/\-(\d+)/, encrypted_name, capture: :all_but_first)
    |> List.first
    |> String.to_integer
  end

  def encrypted_name(name_with_checksum), do: name_with_checksum |> String.split_at(-7) |> elem(0)

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


defmodule Shift do
  def forward(" ", _), do: " "
  def forward(letter = <<_::8>>, times) do
    value = letter |> to_charlist |> hd
    shift = rem(times, 26)

    cond do
      value + shift > 122 -> <<value + shift - 26>>
      true -> <<value + shift>>
    end
  end
end

