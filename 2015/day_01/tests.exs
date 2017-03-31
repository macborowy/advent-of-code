Code.load_file("code.exs")
ExUnit.start

defmodule ModuleTest do
  use ExUnit.Case

  describe "acceptance" do
    test "(()) and ()() should result 0" do
      assert 0 == "(())" |> Exercise.solve
      assert 0 == "()()" |> Exercise.solve
    end

    test "((( and (()(()( should return 3" do
      assert 3 == "(((" |> Exercise.solve
      assert 3 == "(()(()(" |> Exercise.solve
    end

    test "))((((( should return 3" do
      assert 3 == "))(((((" |> Exercise.solve
    end

    test "()) and ))( both result in floor -1" do
      assert -1 == "())" |> Exercise.solve
      assert -1 == "))(" |> Exercise.solve
    end

    test "))) and )())()) both result in floor -3" do
      assert -3 == ")))" |> Exercise.solve
      assert -3 == ")())())" |> Exercise.solve
    end
  end
end
