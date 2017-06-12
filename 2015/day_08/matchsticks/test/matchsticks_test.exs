defmodule MatchsticksTest do
  use ExUnit.Case
  doctest Matchsticks

  setup do
    strings = "input.txt" |> File.read! |> String.split("\n")
    %{strings: strings, first: strings |> Enum.at(0)}
  end

  describe "decode acceptance tests" do
    @tag :acceptance
    test "two double quotes is two characters of code, but the string has no meaningful character" do
      assert {2, 0} == Matchsticks.decode("\"\"")
    end

    @tag :acceptance
    test "\"abc\" is 5 characters of code, but 3 meaningful characters in the string data" do
      assert {5, 3} == Matchsticks.decode("\"abc\"")
    end

    @tag :acceptance
    test "\"aaa\"aaa\" is 10 characters of code, but the string has 7 meaningful characters" do
      assert {10, 7} == Matchsticks.decode("\"aaa\\\"aaa\"")
    end

    @tag :acceptance
    test "\"\x27\" is 6 characters of code, but has only one meaningful character" do
      assert {6, 1} == Matchsticks.decode("\"\\x27\"")
    end
  end

  describe "encode acceptance tests" do
    @tag :acceptance
    test "two double quotes encodes to 6 code characters and 2 original characters" do
      assert {6, 2} == Matchsticks.encode("\"\"")
    end

    @tag :acceptance
    test "\"abc\" encodes to 9 code charaters and 5 original characters" do
      assert {9, 5} == Matchsticks.encode("\"abc\"")
    end

    @tag :acceptance
    test "\"aaa\\\"aaa\" encodes to 16 code characters and 10 original characters" do
       assert {16, 10} == Matchsticks.encode("\"aaa\\\"aaa\"")
    end

    @tag :acceptance
    test "\"\\x27\" encodes to 11 code characters and 6 original characters" do
       assert {11, 6} == Matchsticks.encode("\"\\x27\"")
    end
  end

  describe "tests with real input" do
    test "for the first input string return correct values", %{first: first} do
      assert {16, 7} == Matchsticks.decode(first)
    end

    test "encodes first input line correctly", %{first: first} do
      # "\xa8br\x8bjr\"" encodes to: \"\\xa8br\\x8bjr\\\"\"
      assert {24, 16} == Matchsticks.encode(first)
    end

    test "encodes string with double backslashes correctly", %{strings: strings} do
      string = strings |> Enum.at(3) # "daz\\zyyxddpwk" => \"daz\\\\zyyxddpwk\"
      assert {22, 16} == Matchsticks.encode(string)
    end
  end

  describe "test/1" do
    test "every input has at least two character of code for two double quotes" do
      assert {2, 0} == Matchsticks.decode("\"\"")
      assert {3, 1} == Matchsticks.decode("\"1\"")
      assert {2, 0} == Matchsticks.decode(<<"\"\"">>)
    end
  end
end
