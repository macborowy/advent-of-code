defmodule Gates.Instruction do
  @moduledoc """
  Provides function for converting single instruction (as string) to `%Gates.Instruction{}` struct - see `Gates.Instruction.new/1`.
  """

  @instruction_regex ~r/^([a-z0-9]+)? ?(NOT|AND|OR|LSHIFT|RSHIFT)? ?([a-z0-9]+)? -> ([a-z0-9]+)$/

  defstruct gate: nil, input: nil, output: nil

  defmodule Error do
    defexception [:reason]

    def exception(reason),
      do: %__MODULE__{reason: reason}

    def message(%__MODULE__{reason: reason}),
      do: Gates.Instruction.format_error(reason)
  end

  @doc ~S"""
    Creates a new `%Gates.Instruction{}` struct from provided `raw_instruction` binary.

  ## Examples

  #TODO: add more documentation & examples

    iex> Gates.Instruction.new("a AND b -> c")
    %Gates.Instruction{gate: :and, input: {"a", "b"}, output: "c"}
  """
  def new(raw_instruction) do
    case Regex.run(@instruction_regex, raw_instruction) do
      caputres when is_list(caputres) -> to_instruction(caputres)
      nil -> raise Error, {:invalid_format, raw_instruction}
    end
  end

  def format_error({:invalid_format, value}) do
    "Provided value is not in a valid format. Value: #{value}."
  end

  #####################
  # Private Functions #
  #####################

  defp to_instruction([_, input, "", "", output]) do
    %__MODULE__{gate: nil, input: {try_convert(input), nil}, output: output}
  end

  defp to_instruction([_, "", "NOT", wire, output]) do
    %__MODULE__{gate: :not, input: {try_convert(wire), nil}, output: output}
  end

  defp to_instruction([_, wire_1, gate, wire_2, output]) do
    gate = gate |> String.downcase |> String.to_atom
    %__MODULE__{gate: gate, input: {try_convert(wire_1), try_convert(wire_2)}, output: output}
  end

  defp try_convert(wire) do
    case Integer.parse(wire) do
      {integer, _} -> integer
      _            -> wire
    end
  end
end
