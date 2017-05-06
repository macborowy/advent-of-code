defmodule Gates.Finder do
  def find([], _), do: :no_instructions
  def find(instructions, wire) do
    instructions
    |> Enum.filter(fn %{input: input} ->
      case input do
        ^wire -> true
        {^wire, shift} when is_integer(shift) -> true
        _ -> false
      end
    end)
  end
end
