defmodule Concurrent.Worker do
  @spec process([atom], atom, number, number, number) :: [atom]
  def process(row, state, from, length, index) do
    {head, to_change, tail} = Concurrent.Grid.split_columns(row, from, length)

    {head ++ change(to_change, state) ++ tail, index}
  end

  defp change(list, state) when state == :turn_on or state == :turn_off do
    list |> Enum.map(fn _ -> state end)
  end
  defp change(list, :toggle) do
    list |> Enum.map(fn current ->
      case current do
        :turn_on -> :turn_off
        :turn_off -> :turn_on
      end
    end)
  end
end
