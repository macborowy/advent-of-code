defmodule Gates.FinderTest do
  use ExUnit.Case

  alias Gates.Finder, as: Finder

  setup do
    input = """
    123 -> x
    456 -> y
    x AND y -> d
    y OR x -> e
    x LSHIFT 2 -> f
    y RSHIFT 2 -> g
    NOT x -> h
    NOT y -> i
    """

    instructions = input |> String.split("\n", trim: true) |> Enum.map(&Gates.Instruction.new/1)

    %{instructions: instructions}
  end

  test "when instructions list is empty should return :no_instructions" do
    assert :no_instructions == [] |> Finder.find("a")
  end

  test "when there is no matching instruction return empty list", %{instructions: instructions} do
    assert [] == instructions |> Finder.find("a")
  end

  test "when there is matching instruction should return all matches", %{instructions: instructions} do
    result = instructions |> Finder.find("y")

    assert 2 == result |> length
    assert result |> Enum.all?(fn %{input: input} -> input == {"y", 2} or input == "y" end)
  end

  test "for wires pair should return all matches, but not reversed", %{instructions: instructions} do
    result = instructions |> Finder.find({"x", "y"})

    assert 1 == result |> length
    assert result |> Enum.any?(fn %{input: input} -> input == {"x", "y"} end)
  end
end
