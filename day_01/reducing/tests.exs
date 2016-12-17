Code.load_file("reducing.exs")
ExUnit.start

defmodule ModuleTest do
  use ExUnit.Case

  describe "walk" do
    test "first visited coordinate is always {0,0}" do
      assert Exercise.walk("") == [{0,0}]
    end

    test "should return list of cartesian coordinates" do
      result = Exercise.walk("R3")
      H.assert_in [{0,0}, {1,0}, {2, 0}, {3, 0}], result
    end

    test "for two instructions R2, R3 should return list with start and all visited coordinates" do
      result = Exercise.walk("R2, R3")
      H.assert_in [{0, 0}, {1, 0}, {2, 0}, {2, -1}, {2, -2}, {2, -3}], result
    end
  end

  describe "move" do
    test "from {0,0} 2 steps to north should return list with next 2 coordinates" do
      # because we have from coordinate already on results list
      result = Exercise.move({0,0}, :north, 2)
      H.assert_in [{0,1}, {0,2}], result
    end

    test "from {0,0} 2 steps to west should return list with next 2 valid coordinates" do
      result = Exercise.move({0,0}, :west, 2)
      H.assert_in [{-1, 0}, {-2, 0}], result
    end

    test "from {0,0} 2 steps to south should return list with next 2 valid coordinates" do
      result = Exercise.move({0,0}, :south, 2)
      H.assert_in [{0, -1}, {0, -2}], result
    end

    test "from {0,0} 2 steps to east should return list with next 2 valid coordinates" do
      result = Exercise.move({0,0}, :east, 2)
      H.assert_in [{1,0}, {2, 0}], result
    end
  end

  describe "distance" do
    test "is sum of absoulte values of both coordinates" do
      assert {6,5} |> Exercise.distance == 11
    end
  end

  describe "first_crossroad" do
    test "for given coordinates start coordinate is HQ entrance" do
      coordinates = [{0, 0}, {1, 0}, {1, 1}, {0, 1}, {0, 0}]
      assert Exercise.first_crossroad(coordinates) == {0, 0}
    end

    test "when answer is not nil should return answer" do
      coordinates = [{0, 0}, {1, 0}, {1, 1}, {0, 1}, {0, 0}]
      assert Exercise.first_crossroad(coordinates, {0, 0}) == {0, 0}
    end

    test "for R8, R4, R4, R8 should return 4 steps to east" do
      assert "R8, R4, R4, R8" |> Exercise.walk |> Exercise.first_crossroad == {4, 0}
    end
  end
end

defmodule H do
  import ExUnit.Assertions, only: [assert: 2]
  def assert_in(expected, enum) do
    assert expected |> Enum.all?(&(&1 in enum)),
      "At least one expected value is not in provided enum!\nExpected: #{inspect(expected)}\nEnum: #{inspect(enum)}"
  end
end
