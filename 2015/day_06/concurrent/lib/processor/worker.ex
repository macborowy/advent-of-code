defmodule Worker do
  def update(row, row_index, from, to, action) do
    Range.new(from, to) |> update_row(row, action)
  end

  defp update_row(range, row, action) do
    range
    |> Enum.reduce(row, fn idx, acc -> List.update_at(acc, idx, &do_action(&1, action)) end)
  end

  defp do_action(current_state, action)
  defp do_action(_,         :turn_on),  do: :turn_on
  defp do_action(_,         :turn_off), do: :turn_off
  defp do_action(:turn_on,  :toggle),   do: :turn_off
  defp do_action(:turn_off, :toggle),   do: :turn_on
end
