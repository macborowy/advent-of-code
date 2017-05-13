defmodule Gates.FinderTest do
  use ExUnit.Case

  alias Gates.Finder, as: Finder
  alias Gates.Instruction, as: Instruction

  setup do
    input = """
    123 -> x
    456 -> y
    x -> z
    NOT 2 -> x
    NOT x -> h
    2 LSHIFT 3 -> d
    x LSHIFT 2 -> f
    y RSHIFT 2 -> g
    2 AND y -> v
    2 AND 3 -> t
    x AND y -> d
    q AND y -> b
    2 AND x -> y
    y OR x -> e
    """

    instructions = input |> String.split("\n", trim: true) |> Enum.map(&Gates.Instruction.new/1)

    %{instructions: instructions}
  end


  test "when instructions list is empty should return :no_instructions" do
    assert :no_instructions == Finder.find([], "a", [])
  end

  test "when there is no matching instruction return empty list", %{instructions: instructions} do
    assert [] == Finder.find(instructions, "a", [])
  end

  test "when function first argument is :signals should return all instruction that are signal passing or signal mutation", %{instructions: instructions} do
    expected = [
      %Instruction{gate: nil,     input: {123, nil}, output: "x"},
      %Instruction{gate: nil,     input: {456, nil}, output: "y"},
      %Instruction{gate: :not,    input: {2, nil},   output: "x"},
      %Instruction{gate: :lshift, input: {2, 3},     output: "d"},
      %Instruction{gate: :and,    input: {2, 3},     output: "t"}
    ]

    assert expected == Finder.find(instructions, :signals)
  end

  test "when known_wires is empty should return all possible to solve instructions without depending on already known wires", %{instructions: instructions} do
    expected = [
      %Instruction{gate: nil,     input: {"x", nil}, output: "z"},
      %Instruction{gate: :not,    input: {"x", nil}, output: "h"},
      %Instruction{gate: :lshift, input: {"x", 2},   output: "f"},
      %Instruction{gate: :and,    input: {2, "x"},   output: "y"}
    ]

    assert expected == Finder.find(instructions, "x", [])
  end

  test "when known_wires has wires that are not pairing with searching wire should return all instructions that aren't depend on other wire", %{instructions: instructions} do
    known_wires = [{"a", 3}, {"b", 1}]
    expected = [
      %Instruction{gate: :rshift, input: {"y", 2},   output: "g"},
      %Instruction{gate: :and,    input: {2, "y"},   output: "v"},
    ]

    assert expected == Finder.find(instructions, "y", known_wires)
  end

  test "when known_wires has wires that are pair with searching wire should return all instructions", %{instructions: instructions} do
    known_wires = [{"q", 2}]
    expected = [
      %Instruction{gate: :rshift, input: {"y", 2},   output: "g"},
      %Instruction{gate: :and,    input: {2, "y"},   output: "v"},
      %Instruction{gate: :and,    input: {"q", "y"}, output: "b"}
    ]

    assert expected == Finder.find(instructions, "y", known_wires)
  end
end
