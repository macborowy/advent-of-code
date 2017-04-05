Code.load_file("code.exs")
ExUnit.start
ExUnit.configure trace: true

defmodule DecorationTest do
  use ExUnit.Case

  setup do
    %{decoration_grid: Decoration.new}
  end

  describe "new/0" do
    test "should return milion coordinates" do
      assert 1_000_000 == Decoration.new |> Enum.count
    end

    test "every light should be turned off" do
      assert Decoration.new |> Enum.all?(fn x -> :turn_off == x |> elem(0) end)
    end
  end

  describe "change" do
    test "turn on 0,0 through 999,999 should turn on every light", %{decoration_grid: decoration_gird} do
      command = "turn on 0,0 through 999,999"
      assert 1_000_000 == decoration_gird
                          |> Decoration.change(command)
                          |> Enum.count(fn x -> :turn_on == x |> elem(0) end)
    end

    test "toggle 0,0 through 999,0 should toggle first column of lights", %{decoration_grid: decoration_gird} do
      command = "toggle 0,0 through 999,0"
      assert 1_000 == decoration_gird
                      |> Decoration.change(command)
                      |> Enum.count(&(:turn_on == &1 |> elem(0)))
    end

    test "should be possible to chain commands" do
      first_command = "turn on 0,0 through 99,99"
      second_command = "turn off 0,0 through 9,9"
      third_command = "toggle 0,0 through 999,999"

      final_decoration = Decoration.new
                         |> Decoration.change(first_command)
                         |> IO.inspect
                         |> Decoration.change(second_command)
                         |> IO.inspect
                         |> Decoration.change(third_command)
                         |> IO.inspect

      assert 1_000_000 - (10_000 - 100) == final_decoration
                                           |> Enum.count(&(:turn_on == &1 |> elem(0)))
    end
  end
end

defmodule CommandTest do
  use ExUnit.Case

  describe "new" do
    test "should return Command struct with default values" do
      assert %Command{} == Command.new
      assert %Command{action: :turn_on, start_at: {0, 0}, finish_at: {0, 0}} == Command.new
    end

    test "should return Command struct with correct values" do
      command_parameters = ["turn off", "1", "10", "100", "1000"]
      assert %Command{action: :turn_off, start_at: {1, 10}, finish_at: {100, 1000}} == command_parameters |> Command.new
    end
  end

  describe "parse" do
    test "command turn on 0,0 through 999,999 should return turn on command and {0,0} and {999,999}" do
      assert %Command{action: :turn_on, start_at: {0, 0}, finish_at: {999, 999}} == "turn on 0,0 through 999,999" |> Command.parse
    end

    test "should catch invalid command and return {:error, reason}" do
      assert {:error, "invalid command: tarn on 0,0 through 999,999"} == "tarn on 0,0 through 999,999" |> Command.parse
      assert {:error, "invalid command: turn on 0, through 999,999"} == "turn on 0, through 999,999" |> Command.parse
    end

    test "should parse toogle command" do
      assert %Command{action: :toggle, start_at: {0, 0}, finish_at: {999, 0}} == "toggle 0,0 through 999,0" |> Command.parse
    end
  end
end
