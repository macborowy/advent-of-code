Code.load_file("script.exs")
ExUnit.start

defmodule AcceptanceTest do
  use ExUnit.Case

  test "should read file and get distance" do
    result =
      File.read!("./input.txt")
      |> String.trim
      |> Headquater.distance

    assert result > 0
  end

  test "R2, L3 is 5 blocks away" do
    assert Headquater.distance("R2, L3") == 5
  end

  test "R2, R2, R2 is 2 blocks to south away" do
#    assert Headquater.outcome("R2, R2, R2") == %{north: 0, south: 2, west: 2, east: 2}
    assert Headquater.distance("R2, R2, R2") == 2
  end

  test "R5, L5, R5, R3 is 12 blocks away" do
    direction = "R5, L5, R5, R3"
#    assert Headquater.outcome(direction) == %{north: 5, east: 10, south: 3}
    assert Headquater.distance(direction) == 12
  end
end

defmodule RenameThisModuleWhenFigureOutRightNameTest do
  use ExUnit.Case

  test "for empty instruction string should return 0" do
    assert MyModule.calculate("") == 0
  end
end

defmodule WalkTest do
  use ExUnit.Case

  test "for empty list should return empty list" do
    assert MyModule.walk("") == %Coordinates{} 
  end

  test "after each turn should change map" do
    assert MyModule.walk("R3") == %Coordinates{east: 3}
    assert MyModule.walk("L5, R1, R2, R1, R5") == %Coordinates{north: 1, south: 1, west: 10, east: 2}
  end
end

defmodule ParseTest do
  use ExUnit.Case

  test "for each instruction should return number of steps" do
    assert MyModule.parse("R3") == 3
    assert MyModule.parse("L1") == 1
    assert MyModule.parse("L100") == 100
  end

end

defmodule DistanceTest do
  use ExUnit.Case

  test "for each map should return valid distance" do
    # TODO: znowu test, który mówi co ma się stać, a nie dlaczego

    assert %Coordinates{south: 0, north: 0, west: 0, east: 2} |> Coordinates.distance == 2
    assert %Coordinates{south: 0, north: 0, west: 5, east: 2} |> Coordinates.distance == 3
    assert %Coordinates{south: 0, north: 2, west: 5, east: 2} |> Coordinates.distance == 5
    assert %Coordinates{south: 1, north: 2, west: 5, east: 2} |> Coordinates.distance == 4
  end
end

defmodule DirectionTest do
  use ExUnit.Case

  test "should correctly set new direction after each turn right" do
    assert Direction.turn(:north, "R1") == :east
    assert Direction.turn(:west, "R1") == :north
    assert Direction.turn(:south, "R1") == :west
    assert Direction.turn(:east, "R1") == :south
  end

  test "should correctly set new direction after each turn left" do
    assert Direction.turn(:north, "L1") == :west
    assert Direction.turn(:west, "L1") == :south
    assert Direction.turn(:south, "L1") == :east
    assert Direction.turn(:east, "L1") == :north
  end
end

defmodule CoordinatesTest do
  use ExUnit.Case

  test "new should return Coordinates struct" do
    assert Coordinates.new == %Coordinates{}
  end

  test "distnace is sum of absoulte differences of struct contrary directions" do
    coords = %Coordinates{north: 2, south: 3, west: 4, east: 5}
    assert coords |> Coordinates.distance == 2
  end

  test "update should add steps to provided direction" do
    assert Coordinates.update(Coordinates.new, :north, 3) == %Coordinates{north: 3}
  end

  test "update should only work with Coordinates" do
    assert_raise FunctionClauseError, fn -> Coordinates.update(%{}, :north, 3) end
  end
end



















