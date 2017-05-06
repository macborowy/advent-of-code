defmodule InstructionTest do
  use ExUnit.Case
  doctest Gates.Instruction

  describe "new/1" do
    test "should return gate as atom" do
      input = "af AND ah -> ai"
      %{gate: gate} = Gates.Instruction.new(input)
      assert is_atom(gate)
    end
  end
end
