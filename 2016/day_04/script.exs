defmodule Exercise do
  def sum_of_sectors(input) do
    input
    |> parse
    |> filter_real_rooms
    |> Enum.reduce(0, &reduce_rooms/2)
  end

  def real_room_names(input) do
    input
    |> parse
    |> filter_real_rooms
    |> Enum.map(fn cipher -> {Room.real_name(cipher), Room.sector(cipher)} end)
  end

  defp parse(input), do: input |> String.trim_trailing |> String.split("\n")

  defp filter_real_rooms(list), do: list |> Enum.filter(&Cipher.is_valid?/1)

  defp reduce_rooms(real_room, acc), do: real_room |> Room.sector |> Kernel.+(acc)
end

defmodule Room do
  def sector(cipher), do: cipher |> parse |> Enum.at(1) |> String.to_integer

  def real_name(cipher) do
    [cipher_name, sector] = cipher |> parse
    sector = sector |> String.to_integer

    cipher_name
    |> String.replace("-", " ")
    |> String.trim
    |> String.graphemes
    |> Enum.map(&(Shift.forward(&1, sector)))
    |> List.to_string
  end

  defp parse(cipher), do: Regex.run(~r/([\w\-]+)-(\d+)/, cipher) |> tl
end

defmodule Cipher do
  def is_valid?(cipher) do
    [text, checksum] = Regex.scan(~r/[\w\-]+/, cipher) |> List.flatten

    text
    |> String.replace(~r/[^a-z]/, "")
    |> String.graphemes
    |> Enum.group_by(&(&1))
    |> Enum.sort_by(fn {_, list} -> list |> length end, &>=/2)
    |> Enum.take(5)
    |> Enum.map(fn {char, _} -> char end)
    |> List.to_string
    |> Kernel.==(checksum)
  end
end

defmodule Shift do
  def forward(" ", _), do: " "
  def forward(<<c::8>>, shift) when c + rem(shift,26) > 122, do: <<c + rem(shift, 26) - 26>>
  def forward(<<c::8>>, shift), do: <<c + rem(shift, 26)>>
end
