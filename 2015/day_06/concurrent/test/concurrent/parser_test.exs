defmodule Concurrent.ParserTests do
  use ExUnit.Case

  describe "get_commands_from_file" do
    test "should return commands from input file" do
      assert "input.txt"
              |> Concurrent.Parser.get_commands_from_file
              |> Enum.all?(fn cmd ->
                case cmd do
                  %Concurrent.Command{} -> true
                  _                     -> false
                end
              end)
    end
  end
end
