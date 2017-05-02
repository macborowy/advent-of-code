defmodule Concurrent.CommandTest do
  use ExUnit.Case
  alias Concurrent.Command, as: Command

  setup do
    %{matching_line: "turn on 0,0 through 999,999"}
  end

  describe "str_to_command" do
    test "should return Concurrent.Command with all values", %{matching_line: line} do
      expected = %Command{action: :turn_on, x: 0, y: 0, width: 1000, height: 1000}
      assert expected == line |> Command.str_to_command
    end
  end
end
