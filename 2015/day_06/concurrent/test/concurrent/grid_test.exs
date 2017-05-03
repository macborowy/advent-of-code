defmodule Concurrent.GridTest do
  use ExUnit.Case
  alias Concurrent.Grid, as: Grid

  setup do
    grid = [[1, 2, 3, 4, 5], [1, 2, 3, 4, 5], [1, 2, 3, 4, 5], [1, 2, 3, 4, 5], [1, 2, 3, 4, 5]]
    %{default: 0, grid: grid}
  end

  describe "new/0" do
    test "should return list containing 1000 lists", %{default: default} do
      assert 1_000 == default |> Grid.new |> length
    end

    test "each inner list should has 1000 elements", %{default: default} do
      assert 1_000 = default |> Grid.new |> List.first |> length
    end

    test "each element should be equal to provided default value", %{default: default} do
      assert default |> Grid.new |> List.first |> Enum.all?(&(&1 == default))
    end
  end

  describe "split_rows/3" do
    test "should return 3 elements tuple", %{grid: grid} do
       result = grid |> Grid.split_rows(1, 3)

       assert result |> is_tuple
       assert 3 == result |> tuple_size
    end

    test "each tuple element is a list", %{grid: grid} do
      result = grid |> Grid.split_rows(1, 3)

      assert result |> Tuple.to_list |> Enum.all?(&is_list/1)
    end

    test "should return tuple with first list empty when start is 0", %{grid: grid} do
      result = grid |> Grid.split_rows(0, 1)

      assert [] == result |> elem(0)
    end

    test "should return tuple with last list empty when split from beggining to end", %{grid: grid} do
      result = grid |> Grid.split_rows(0, 10)

      assert [] == result |> elem(2)
    end
  end
end
