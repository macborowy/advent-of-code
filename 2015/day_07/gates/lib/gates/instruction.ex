defmodule Gates.Instruction do
  @moduledoc """
  Provides function for converting single instruction (as string) to `%Gates.Instruction{}` struct - see `Gates.Instruction.new/1`.
  """

  @instruction_regex ~r/(\w+) (AND|OR) (\w+) -> (\w+)|(\w+) (LSHIFT|RSHIFT) (\d+) -> (\w+)|(NOT) (\w+) -> (\w+)|(\d+) -> (\w+)/

  defstruct gate: nil, input: nil, output_wire: nil

  @doc ~S"""
   Returns the `%Gates.Instruction{}` struct for provided raw_instruction.
   There are 6 supported convertions:

      iex> Gates.Instruction.new("a AND b -> c")
      %Gates.Instruction{gate: :and, input: {"a", "b"}, output_wire: "c"}

      iex> Gates.Instruction.new("a OR b -> c")
      %Gates.Instruction{gate: :or, input: {"a", "b"}, output_wire: "c"}

      iex> Gates.Instruction.new("a LSHIFT 2 -> c")
      %Gates.Instruction{gate: :lshift, input: {"a", 2}, output_wire: "c"}

      iex> Gates.Instruction.new("a RSHIFT 2 -> c")
      %Gates.Instruction{gate: :rshift, input: {"a", 2}, output_wire: "c"}

      iex> Gates.Instruction.new("NOT b -> c")
      %Gates.Instruction{gate: :not, input: "b", output_wire: "c"}

      iex> Gates.Instruction.new("12345 -> c")
      %Gates.Instruction{gate: nil, input: 12345, output_wire: "c"}
  """
  def new(raw_instruction) do
    Regex.run(@instruction_regex, raw_instruction)
    |> to_instruction
  end

  defp to_instruction([_, wire_1, gate, wire_2, output_wire]) do
    gate_atom = gate |> String.downcase |> String.to_atom
    %Gates.Instruction{gate: gate_atom, input: {wire_1, wire_2}, output_wire: output_wire}
  end
  defp to_instruction([_, _, _, _, _, wire_1, gate, shift, output_wire]) do
    gate_atom = gate |> String.downcase |> String.to_atom
    shift = String.to_integer(shift)
    %Gates.Instruction{gate: gate_atom, input: {wire_1, shift}, output_wire: output_wire}
  end
  defp to_instruction([_, _, _, _, _, _, _, _, _, gate, wire_1, output_wire]) do
    gate_atom = gate |> String.downcase |> String.to_atom
    %Gates.Instruction{gate: gate_atom, input: wire_1, output_wire: output_wire}
  end
  defp to_instruction([_, _, _, _, _, _, _, _, _, _, _, _, signal, output_wire]) do
    signal = String.to_integer(signal)
    %Gates.Instruction{gate: nil, input: signal, output_wire: output_wire}
  end
end
