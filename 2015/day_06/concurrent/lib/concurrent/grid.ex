defmodule Concurrent.Grid do
  alias Concurrent.Command, as: Command

  ##############
  # Client API #
  ##############

  def new(default \\ 0) do
    1..1_000
    |> Enum.map(fn _ ->
      1..1000
      |> Enum.map(fn _ -> default end)
    end)
  end

  def split_rows(grid, from, length), do: split_list(grid, from, length)

  def apply_command(row, %Command{action: action, x: from, width: length}, index) do
    {head, to_change, tail} = split_list(row, from, length)

    {head ++ change_brightness(to_change, action) ++ tail, index}
  end

  def total_brightness(grid), do: grid |> Enum.reduce(0, &(&2 + Enum.sum(&1)))

  #####################
  # Private functions #
  #####################

  defp split_list(list, from, length) do
    {head, rest} = list |> Enum.split(from)
    {to_change, tail} = rest |> Enum.split(length)

    {head, to_change, tail}
  end

  defp change_brightness(list, :turn_on),  do: list |> Enum.map(&(&1 + 1))
  defp change_brightness(list, :turn_off), do: list |> Enum.map(&decrease_brightness/1)
  defp change_brightness(list, :toggle),   do: list |> Enum.map(&(&1 + 2))

  defp decrease_brightness(0), do: 0
  defp decrease_brightness(value), do: value - 1
end
