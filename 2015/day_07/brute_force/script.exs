defmodule Instruction do
  @instruction_regex ~r/(\w+) ?(NOT|AND|OR|LSHIFT|RSHIFT)? ?(\w+)? -> (\w+)/

  defstruct gate: nil, input: nil, output_wire: nil

  def new(raw_instruction) do
    Regex.run(@instruction_regex, raw_instruction)
    |> to_instruction
  end

  defp to_instruction([_, "NOT", "", input_wire, output_wire]) do
    input = to_input_tuple(input_wire, nil)

    %Instruction{gate: :not, input: input, output_wire: output_wire}
  end
  defp to_instruction([_, input_wire, "", "", output_wire]) do
    input = to_input_tuple(input_wire, nil)

    %Instruction{gate: nil, input: input, output_wire: output_wire}
  end
  defp to_instruction([_, wire_1, gate, wire_2, output_wire]) do
    gate_atom = gate |> String.downcase |> String.to_atom
    input = to_input_tuple(wire_1, wire_2)

    %Instruction{gate: gate_atom, input: input, output_wire: output_wire}
  end

  defp to_input_tuple(wire_1, nil) do
    wire_1_valid_value = case Integer.parse(wire_1) do
      {integer_value, _} -> integer_value
      _ -> wire_1
    end

    {wire_1_valid_value, nil}
  end
  defp to_input_tuple(wire_1, wire_2) do
    wire_1_valid_value = case Integer.parse(wire_1) do
      {integer_value, _} -> integer_value
      _ -> wire_1
    end

    wire_2_valid_value = case Integer.parse(wire_2) do
      {integer_value, _} -> integer_value
      _ -> wire_2
    end

    {wire_1_valid_value, wire_2_valid_value}
  end
end

defmodule Script do
  import Bitwise

  def run(instructions) do
    solve(instructions, []) |> Enum.find(fn {wire, _} -> wire == "a" end) |> IO.inspect
  end

  def solve(instructions, known_wires, iter \\ 1)
  # def solve(_, known_wires, 100), do: known_wires
  def solve([], known_wires, _iter), do: known_wires
  def solve(instructions, [], iter) do
    debug_info(instructions, [], iter)

    instructions |> Enum.take(10) |> IO.inspect

    instructions_to_solve = instructions |> select_signals

    new_known_wires = instructions_to_solve |> calculate([]) |> merge_known_wires([])
    reduced_instructions = instructions -- instructions_to_solve

    solve(reduced_instructions, new_known_wires, iter + 1)
  end
  def solve(instructions, known_wires, iter) do
    debug_info(instructions, known_wires, iter)

    instructions_to_solve = known_wires |> create_all_inputs_to_check |> select_instructions(instructions)

    new_known_wires = instructions_to_solve |> calculate(known_wires) |> merge_known_wires(known_wires)
    reduced_instructions = instructions -- instructions_to_solve

    if 0 == instructions_to_solve |> length do
      known_wires
    else
      solve(reduced_instructions, new_known_wires, iter + 1)
    end
  end

  ##############################################
  # Selecting doable instructions (aka. steps) #
  ##############################################

  def select_signals(instructions) do
    instructions
    |> Enum.filter(fn %{input: input} ->
      case input do
        {int_1, int_2} when is_integer(int_1) and is_integer(int_2) -> true
        {int, nil}     when is_integer(int)                        -> true
        _ -> false
      end
    end)
  end

  def select_instructions(known_wires, instructions, acc \\ [])
  def select_instructions([], _, acc), do: acc
  def select_instructions([{{wire_1, _}, {wire_2, _}} | rest], instructions, acc) do
    to_solve =
      instructions
      |> Enum.filter(fn %{input: input} ->
        case input do
          {^wire_1, ^wire_2} -> true
          _ -> false
        end
      end)

    select_instructions(rest, instructions, acc ++ to_solve)
  end
  def select_instructions([{wire, _} | rest], instructions, acc) do
    to_solve =
      instructions
      |> Enum.filter(fn %{input: input} ->
        case input do
          {int, ^wire} when is_integer(int) -> true
          {^wire, int} when is_integer(int) -> true
          {^wire, nil} -> true
          _ -> false
        end
      end)

    select_instructions(rest, instructions, acc ++ to_solve)
  end

  ########################
  # Calculating new wire #
  ########################

  def calculate(instructions, known_wires) do
    instructions
    |> Enum.map(fn instruction ->
      debug_print_instr(instruction)
      calculate_single_instruction(instruction, known_wires)
    end)
  end

  def calculate_single_instruction(%{gate: gate, input: {wire_1, wire_2}, output_wire: output}, known_wires)
  when gate == :and or gate == :or or gate == :lshift or gate == :rshift do
    value_1 = get_value(wire_1, known_wires)
    value_2 = get_value(wire_2, known_wires)

    result = case gate do
      :and    -> Bitwise.band(value_1, value_2)
      :or     -> Bitwise.bor(value_1, value_2)
      :lshift -> Bitwise.bsl(value_1, value_2)
      :rshift -> Bitwise.bsr(value_1, value_2)
    end

    {output, result}
  end

  def calculate_single_instruction(%{gate: :not, input: {wire, nil}, output_wire: output}, known_wires) do
    value = get_value(wire, known_wires)
    result = Bitwise.bnot(value)
    {output, result}
  end

  def calculate_single_instruction(%{gate: nil, input: {wire, nil}, output_wire: output}, known_wires) do
    value = get_value(wire, known_wires)
    {output, value}
  end

  def get_value(wire, _) when is_integer(wire), do: wire
  def get_value(wire, known_wires) do
    {_known_wire, value} = find_wire(wire, known_wires)
    value
  end

  def find_wire(wire, known_wires) do
    known_wires |> Enum.find(fn {w, _} -> w == wire end)
  end

  ######################
  # Wire related stuff #
  ######################

  def to_wire(%Instruction{input: signal, output_wire: wire}) when is_integer(signal), do: {wire, signal}

  def merge_known_wires(new, existing), do: new ++ existing

  def create_all_inputs_to_check(known_values) do
    pairs = for x <- known_values, y <- known_values, do: {x, y}

    known_values ++ pairs
  end

  ##############
  # Debug info #
  ##############

  def debug_info(instructions, known_wires, iter) do
    IO.puts "(#{iter}) Instructions left: #{length(instructions)}; Known wires: #{length(known_wires)}"
    just_known_wires = known_wires |> Enum.map(fn {wire, _} -> wire end) |> Enum.join(", ")
    IO.puts "--> Known_values: #{just_known_wires}"
  end

  def debug_print_instr(%Instruction{} = instruction) do
    IO.puts "----> Current solving instruction: #{inspect(instruction)}"
  end
end

if System.argv == ["--run"] do
  "input.txt"
  |> File.read!
  |> String.split("\n", trim: true)
  |> Enum.reject(&(&1==nil))
  |> Enum.map(&Instruction.new/1)
  |> Script.run
end
