defmodule Gates.ProcessorTest do
  use ExUnit.Case

  alias Gates.Instruction, as: Instruction
  alias Gates.Processor,   as: Processor

  setup do
    known_wires = [{"a", 2}, {"b", 3}]
    %{known_wires: known_wires}
  end

  test "should take %Instruction and return output wire with computed value", %{known_wires: known_wires} do
    instruction = %Instruction{gate: :and, input: {"a", "b"}, output: "c"}

    assert {"c", 2} == Processor.process(instruction, known_wires)
  end

  test "should compute output even when input contains signal value", %{known_wires: known_wires} do
    instruction = %Instruction{gate: :and, input: {2, "b"}, output: "c"}
    assert {"c", 2} == Processor.process(instruction, known_wires)
  end

  describe "different gates" do
    test "should compute :and gate", %{known_wires: known_wires} do
      instruction = %Instruction{gate: :and, input: {"a", "b"}, output: "c"}
      assert {"c", 2} == Processor.process(instruction, known_wires)
    end

    test "should compute :or gate", %{known_wires: known_wires} do
      instruction = %Instruction{gate: :or, input: {"a", "b"}, output: "c"}
      assert {"c", 3} == Processor.process(instruction, known_wires)
    end

    test "should compute :lshift gate", %{known_wires: known_wires} do
      instruction = %Instruction{gate: :lshift, input: {"a", 2}, output: "c"}
      assert {"c", 8} == Processor.process(instruction, known_wires)
    end

    test "should compute :rshift gate", %{known_wires: known_wires} do
      instruction = %Instruction{gate: :rshift, input: {"a", 2}, output: "c"}
      assert {"c", 0} == Processor.process(instruction, known_wires)
    end

    test "should compute :not gate", %{known_wires: known_wires} do
      instruction = %Instruction{gate: :not, input: {"a", nil}, output: "c"}
      assert {"c", -3} == Processor.process(instruction, known_wires)
    end

    test "should compute signal passing instruction", %{known_wires: known_wires} do
      instruction = %Instruction{gate: nil, input: {"a", nil}, output: "c"}
      assert {"c", 2} == Processor.process(instruction, known_wires)
    end
  end
end
