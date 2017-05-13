defmodule InstructionTest do
  use ExUnit.Case
  doctest Gates.Instruction

  alias Gates.Instruction, as: Instruction

  describe "new/1" do
    test "should raise Gates.Instruction.Error when raw instruction doesn't match regex" do
      input = "a AND b AND c -> d"
      assert_raise Instruction.Error,
        "Provided value is not in a valid format. Value: #{input}.",
        fn -> Instruction.new(input) |> IO.inspect end
    end

    test "should lowercase gate and return it as atom" do
      input = "a AND b -> c"
      %{gate: gate} = Instruction.new(input)
      assert is_atom(gate) and gate == :and
    end

    test "should return output as binary" do
      input = "a AND b -> c"
      %{output: output} = Instruction.new(input)
      assert is_binary(output) and output == "c"
    end

    test "should parse all supported instructions" do
      supported_instructions = ["a AND b -> c" , "a OR b -> c", "a LSHIFT 2 -> c", "a RSHIFT 2 -> c", "NOT b -> c", "a -> c"]

      assert supported_instructions
             |> Enum.map(&Instruction.new/1)
             |> Enum.all?(&is_valid_instruction?/1)
    end

    test "when instruction is in form 'a -> c' should return gate as nil" do
      assert "a -> c" |> Instruction.new == %Instruction{gate: nil, input: {"a", nil}, output: "c"}
    end

    test "when instruction is NOT should return struct with input in correct form" do
      assert "NOT b -> c" |> Instruction.new == %Instruction{gate: :not, input: {"b", nil}, output: "c"}
    end

    test "should parse instruction in form 'int GATE int -> str'" do
      assert "1 AND 2 -> c" |> Instruction.new == %Instruction{gate: :and, input: {1, 2}, output: "c"}
    end

    test "should parse instruction in form 'NOT int -> str'" do
      assert "NOT 1 -> c" |> Instruction.new == %Instruction{gate: :not, input: {1, nil}, output: "c"}
    end

    test "should parse instruction in form 'int -> str'" do
      assert "1 -> c" |> Instruction.new == %Instruction{gate: nil, input: {1, nil}, output: "c"}
    end

    #####################
    # Private functions #
    #####################

    defp is_valid_instruction?(%{gate: nil, input: {_, _}, output: o}) when is_binary(o), do: true
    defp is_valid_instruction?(%{gate: g, input: {_, _}, output: o}) when is_atom(g) and is_binary(o), do: true
    defp is_valid_instruction?(_), do: false
  end
end
