Code.load_file("code.exs")
ExUnit.start
ExUnit.configure trace: true

defmodule DecorationTest do
  use ExUnit.Case

  describe "new/0" do
    test "should return milion coordinates" do
      assert 1_000_000 == Decoration.new |> Enum.count
    end
  end
end

defmodule CommandTest do
  use ExUnit.Case

  describe "new" do
    test "should return Command struct with default values" do
      assert %Command{} == Command.new
      assert %Command{command: :"turn_on", start_at: {0, 0}, finish_at: {0, 0}} == Command.new
    end

    test "should return Command struct with correct values" do
      command_parameters = ["turn off", "1", "10", "100", "1000"]
      assert %Command{command: :turn_off, start_at: {1, 10}, finish_at: {100, 1000}} == command_parameters |> Command.new
    end
  end

  describe "parse" do
    test "command turn on 0,0 through 999,999 should return turn on command and {0,0} and {999,999}" do
      assert %Command{command: :turn_on, start_at: {0, 0}, finish_at: {999, 999}} == "turn on 0,0 through 999,999" |> Command.parse
    end

    test "should catch invalid command and return {:error, reason}" do
      assert {:error, "invalid command: tarn on 0,0 through 999,999"} == "tarn on 0,0 through 999,999" |> Command.parse
      assert {:error, "invalid command: turn on 0, through 999,999"} == "turn on 0, through 999,999" |> Command.parse
    end
  end
end
