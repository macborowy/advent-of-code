Code.load_file("code.exs")
ExUnit.start

defmodule ModuleTest do
  use ExUnit.Case

  describe "acceptance" do
    test "(()) and ()() should result 0" do
      assert 0 == "(())" |> Exercise.delivery_floor
      assert 0 == "()()" |> Exercise.delivery_floor
    end

    test "((( and (()(()( should return 3" do
      assert 3 == "(((" |> Exercise.delivery_floor
      assert 3 == "(()(()(" |> Exercise.delivery_floor
    end

    test "))((((( should return 3" do
      assert 3 == "))(((((" |> Exercise.delivery_floor
    end

    test "()) and ))( both result in floor -1" do
      assert -1 == "())" |> Exercise.delivery_floor
      assert -1 == "))(" |> Exercise.delivery_floor
    end

    test "))) and )())()) both result in floor -3" do
      assert -3 == ")))" |> Exercise.delivery_floor
      assert -3 == ")())())" |> Exercise.delivery_floor
    end
  end

  describe "basement acceptance tests" do
    test ") causes enter to basement at first move" do
      assert 1 == Exercise.basement_at(")")
    end

    test "()()) causes enter basement at 5th move" do
      assert 5 == Exercise.basement_at("()())")
    end

    test "()(()))((( causes enter basement at 7th move" do
      assert 7 == Exercise.basement_at("()(()))(((")
    end
  end
end
