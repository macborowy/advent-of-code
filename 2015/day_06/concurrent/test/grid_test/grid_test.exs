defmodule GridTest do
  use ExUnit.Case

  alias Grid

  describe "new" do
    test "grid has 1000 rows" do
      assert 1_000 = Grid.new |> length
    end

    test "every row has 1000 elements" do
      assert Grid.new |> Enum.all?(&(1_000 == &1 |> length))
    end

    test "every element of fresh grid is :turn_off atom" do
      assert Grid.new |> Enum.at(0) |> Enum.all?(&(:turn_off == &1))
    end

    test "grid is a rectangle" do
       [row | _] = grid = Grid.new

       assert 1_000 == row  |> length
       assert 1_000 == grid |> length
    end
  end
end
