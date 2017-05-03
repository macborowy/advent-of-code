defmodule Concurrent.Worker do
  @spec process([number], atom, number, number, number) :: [atom]
  def process(row, state, from, length, index) do
    {head, to_change, tail} = Concurrent.Grid.split_columns(row, from, length)

    {head ++ change_brightness(to_change, state) ++ tail, index}
  end

  defp change_brightness(list, :turn_on),  do: list |> Enum.map(&(&1 + 1))
  defp change_brightness(list, :turn_off), do: list |> Enum.map(&decrease_brightness/1)
  defp change_brightness(list, :toggle),   do: list |> Enum.map(&(&1 + 2))

  defp decrease_brightness(0), do: 0
  defp decrease_brightness(value), do: value - 1
end
