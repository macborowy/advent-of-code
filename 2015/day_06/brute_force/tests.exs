Code.load_file("code.exs")
ExUnit.start
ExUnit.configure trace: true

defmodule CommandTest do
  use ExUnit.Case

  describe "new" do
    test "should return Command struct with default values" do
      assert %Command{} == Command.new
      assert %Command{action: :turn_off, start_at: {0, 0}, finish_at: {0, 0}} == Command.new
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

defmodule ControllerTest do
  use ExUnit.Case

  setup do
    %{
      turn_on:  "turn on 0,0 through 9,9",
      turn_off: "turn off 0,0 through 9,9",
      toggle:   "toggle 0,0 through 9,9",
      turned_on: Controller.start |> Controller.set_up("turn on 0,0 through 14,14")
    }
  end

  test "every element of the list should be in coordinate form ({x, y})", %{turn_on: command} do
    result = Controller.start |> Controller.set_up(command)
    assert result |> Enum.all?(&is_tuple/1)
  end

  test "every command should return list of turned on lights", %{turn_on: command} do
    result = Controller.start |> Controller.set_up(command)
    assert result |> is_list
  end

  describe "start" do
    test "should return empty list of currently turned on lights" do
      assert [] == Controller.start
    end
  end

  describe "turn on" do
    test "when list of turned on lights is empty should add all lights to it", %{turn_on: command} do
      result = Controller.start |> Controller.set_up(command)

      assert 100 == result |> length
      assert result |> Enum.all?(fn {x, y} -> x in 0..9 && y in 0..9 end)
    end

    test "when list of turned on lights contains same lights as to be turned on should concat those lists and return only unique elements", %{turn_on: command} do
      currently_turned_on = [{0, 0}, {0, 1}, {0, 2}, {0, 3}, {0, 4}]
      result = currently_turned_on |> Controller.set_up(command)

      assert 100 == result |> length
    end
  end

  describe "turn off" do
    test "when turned on list is empty should return same list", %{turn_off: command} do
      assert [] == Controller.start |> Controller.set_up(command)
    end

    test "when turned on list contains element other than those to turn off result list should remain untouched", %{turn_off: command} do
      currently_turned_on = [{0, 10}, {1, 10}]
      result = currently_turned_on |> Controller.set_up(command)

      assert currently_turned_on == result
    end

    test "when turned on list contains element to be turned off should substract list", %{turn_off: command} do
      currently_turned_on = [{0, 0}, {1, 0}, {2, 0}, {3, 0}, {4, 0}]
      result = currently_turned_on |> Controller.set_up(command)

      assert 0 == result |> length
    end
  end

  describe "toggle" do
    test "when turned on list is empty should add all lights to list", %{toggle: command} do
      result = Controller.start |> Controller.set_up(command)

      assert 100 == result |> length
    end

    test "any previously turned on light affected by toggle should be still turned on", %{toggle: command} do
       currently_turned_on = [{0, 0}, {1, 0}, {2, 0}, {3, 0}, {4, 0}]
       result = currently_turned_on |> Controller.set_up(command)

       assert 95 == result |> length
       assert result |> Enum.any?(&(not &1 in currently_turned_on))
    end

    test "should turn on any off lights", %{toggle: command} do
      result = Controller.start |> Controller.set_up(command)

      assert 100 == result |> length
    end

    test "should change state of both, turned on and turned off lights, if affect more elements than in turned on list" do
      currently_turned_on = [{1, 0}, {2, 0}, {3, 0}, {4, 0}]
      command = "toggle 0,0 through 5,0"
      result = currently_turned_on |> Controller.set_up(command)

      assert 2 == result |> length
      assert result |> Enum.all?(&(&1 in [{0, 0}, {5, 0}]))
    end
  end

  describe "play" do
    test "should do list of command" do
      commands = [
        "turn on 0,0 through 9,0",
        "turn off 3,0 through 6,0",
        "toggle 0,0 through 9,0"
      ]
      expected = [{3, 0}, {4, 0}, {5, 0}, {6, 0}]

      result = Controller.start |> Controller.play(commands)
      assert result |> Enum.all?(&(&1 in expected))
    end
  end
end
