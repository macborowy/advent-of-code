defmodule Gates.Finder do

  ####################
  # Public Functions #
  ####################

  def find(instructions, :signals), do: instructions |> Enum.filter(&is_signal?/1)

  def find([], _, _), do: :no_instructions
  def find(instructions, wire, known_wires) do
    known_wires = known_wires |> Enum.map(fn {wire, _} -> wire end)
    instructions |> Enum.filter(&single_node_and_pairs(&1, wire, known_wires))
  end

  #####################
  # Private Functions #
  #####################

  defp is_signal?(%{input: {signal, nil}}) when is_integer(signal), do: true
  defp is_signal?(%{input: {sig_1, sig_2}}) when is_integer(sig_1) and is_integer(sig_2), do: true
  defp is_signal?(_), do: false

  defp single_node_and_pairs(%{input: {wire, other_wire}}, wire, known_wires), do:
    other_wire == nil || is_integer(other_wire) || other_wire in known_wires
  defp single_node_and_pairs(%{input: {other_wire, wire}}, wire, known_wires), do:
    single_node_and_pairs(%{input: {wire, other_wire}}, wire, known_wires)
  defp single_node_and_pairs(_, _, _), do: false
end
