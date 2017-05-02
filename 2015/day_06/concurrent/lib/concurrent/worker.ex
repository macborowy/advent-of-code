defmodule Concurrent.Worker do
  @spec process([atom], atom, number, number) :: [atom]
  def process(list, state, from, length) do
    {head, rest} = list |> Enum.split(from)
    {to_change, tail} = rest |> Enum.split(length)

    head ++ change(to_change, state) ++ tail
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
