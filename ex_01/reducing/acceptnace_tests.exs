Code.load_file("reducing.exs")
ExUnit.start

defmodule AcceptanceTest do
  use ExUnit.Case

  test "the truth" do
    assert 1 == 1
  end

  test "PART 1: R2, L3 should result in {2, 3}, which is 5 blocks away" do
    result = "R2, L3" |> Exercise.walk |> List.last
    assert result == {2,3}
    assert result |> Exercise.distance == 5
  end

  test "PART 1: R2, R2, R2 should result in {0, -2}, which is 2 blocks away" do
    result = "R2, R2, R2" |> Exercise.walk |> List.last
    assert result == {0, -2}
    assert result |> Exercise.distance == 2
  end

  test "PART 1: R5, L5, R5, L3 is 12 block away" do
    assert "R5, L5, R5, R3" |> Exercise.walk |> List.last |> Exercise.distance == 12
  end

  test "ANSWER 1: should load the file and calculate distance equal to 271" do
    result =
      File.read!("../input.txt")
      |> String.trim
      |> Exercise.walk
      |> List.last
      |> Exercise.distance

    assert result == 271
  end

  test "PART 2: should return distance to first location visited twice" do
    result =
      "R8, R4, R4, R8"
      |> String.trim
      |> Exercise.walk
      |> Exercise.first_crossroad
      |> Exercise.distance

    assert result == 4
  end

  test "ANSWER 2: what is the first coordinate visited twice?" do
    answer =
      File.read!("../input.txt")
      |> String.trim
      |> Exercise.walk
      |> Exercise.first_crossroad
      |> Exercise.distance

    IO.puts "The answer for second part is: #{answer}."
    assert 1 == 1
  end
end
