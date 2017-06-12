defmodule MatchsticksTest do
  use ExUnit.Case
  doctest Matchsticks

  setup do
    strings = "input.txt" |> File.read! |> String.split("\n")
    %{strings: strings, first: strings |> Enum.at(0)}
  end

  describe "acceptance tests" do
    @tag :acceptance
    test "two double quotes is two characters of code, but the string has no meaningful character" do
      assert {2, 0} == Matchsticks.count("\"\"")
    end

    @tag :acceptance
    test "\"abc\" is 5 characters of code, but 3 meaningful characters in the string data" do
      assert {5, 3} == Matchsticks.count("\"abc\"")
    end

    @tag :acceptance
    test "\"aaa\"aaa\" is 10 characters of code, but the string has 7 meaningful characters" do
      assert {10, 7} == Matchsticks.count("\"aaa\\\"aaa\"")
    end

    @tag :acceptance
    test "\"\x27\" is 6 characters of code, but has only one meaningful character" do
      assert {6, 1} == Matchsticks.count("\"\\x27\"")
    end
  end

  describe "tests with real input" do
    test "for the first input string return correct values", %{first: first} do
      assert {16, 7} == Matchsticks.count(first)
    end
  end

  describe "test/1" do
    test "every input has at least two character of code for two double quotes" do
      assert {2, 0} == Matchsticks.count("\"\"")
      assert {3, 1} == Matchsticks.count("\"1\"")
      assert {2, 0} == Matchsticks.count(<<"\"\"">>)
    end
  end
end
