defmodule Gates.Processor do
  use Bitwise, [only_operators: true]

  def process(%{gate: gate, input: {wire_1, wire_2}, output: output}, known_wires) do
    value_1 = get_value(wire_1, known_wires)
    value_2 = get_value(wire_2, known_wires)

    compute(gate, {value_1, value_2}, output)
  end

  #####################
  # Private Functions #
  #####################

  defp get_value(nil,  _), do: nil
  defp get_value(wire, _) when is_integer(wire), do: wire
  defp get_value(wire, known_wires),
    do: known_wires |> Enum.find(fn {w, _} -> w == wire end) |> elem(1)

  defp compute(:and,    {value_1, value_2}, output), do: {output, value_1 &&& value_2}
  defp compute(:or,     {value_1, value_2}, output), do: {output, value_1 ||| value_2}
  defp compute(:lshift, {value_1, value_2}, output), do: {output, value_1 <<< value_2}
  defp compute(:rshift, {value_1, value_2}, output), do: {output, value_1 >>> value_2}
  defp compute(:not,    {value_1, nil},     output), do: {output, ~~~value_1}
  defp compute(nil,     {value_1, nil},     output), do: {output, value_1}
end
