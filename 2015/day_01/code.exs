defmodule Exercise do
  @moduledoc false

  @doc """
  Returns floor at which Santa should deliver gift
  """
  @spec delivery_floor(String.t) :: number
  def delivery_floor(input), do: input |> prepare |> do_reduce(:normal) |> elem(1)

  @doc """
  Returns at which move Santa visits basement for the first time
  """
  @spec basement_at(String.t) :: number
  def basement_at(input), do: input |> prepare |> do_reduce(:basement) |> elem(2)

  defp prepare(input), do: input |> String.codepoints

  @doc """
  If parameter `type` is `:basement` reducer halts when it meets basement (`acc = -1`) for the first time. Otherwise, it continues to end.
  """
  defp do_reduce(enum, type), do: enum |> Enum.reduce_while({type, 0, 0}, &reducer/2)

  defp reducer(")", {:basement, 0, move}), do: {:halt, {:basement, -1, move + 1}}
  defp reducer("(", {type, acc, move}),    do: {:cont, {type, acc + 1, move + 1}}
  defp reducer(")", {type, acc, move}),    do: {:cont, {type, acc - 1, move + 1}}
  defp reducer(_,   tuple),                do: {:cont, tuple}
end

input = "input.txt" |> File.read!
input |> Exercise.delivery_floor |> IO.puts
input |> Exercise.basement_at |> IO.puts
