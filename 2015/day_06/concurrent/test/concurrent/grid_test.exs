defmodule Concurrent.GridTest do
  use ExUnit.Case

  describe "new" do
    test "should return list containing 1000 lists" do
      assert 1_000 == Concurrent.Grid.new |> length
    end

    test "each inner list should has 1000 elements" do
      assert 1_000 = Concurrent.Grid.new |> List.first |> length
    end

    test "each element of inner list should be :turn_off atom" do
      assert Concurrent.Grid.new |> List.first |> Enum.all?(fn elem -> elem == :turn_off end)
    end
  end
end
