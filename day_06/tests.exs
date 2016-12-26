Code.load_file("script.exs")
ExUnit.start
ExUnit.configure exclude: :long_running, trace: true

defmodule ExerciseTest do
  use ExUnit.Case

  setup do
    %{input: "exercise_input.txt" |> File.read!}
  end

  test "for exercise input should return \"easter\"", %{input: input} do
    assert input |> Signal.decode(:most_common) == "easter"
  end

  test "for exercise should be able to select least common letters and return result", %{input: input} do
    assert input |> Signal.decode(:least_common) == "advent"
  end
end
