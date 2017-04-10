defmodule ServerTest do
  use ExUnit.Case, async: false


  alias Server
  alias Grid

  setup do
    {:ok, pid} = Server.start_link
    %{pid: pid, path_to_file: "./misc/input.txt"}
  end

  describe "start_link" do
    test "create server with default grid", %{pid: pid} do
      %{grid: grid} = :sys.get_state(pid)
      assert grid == Grid.new
    end
  end

  describe "process" do
    test "return grid after applying all commands", %{pid: pid, path_to_file: path} do
      # result = Server.process(pid, path)
      #
      # assert 1000 == result |> length
      # assert 1000 == result |> Enum.at(0) |> length
      # assert result |> Enum.all?(&(&1 |> is_list))
      # assert result |> Enum.at(0) |> Enum.all?(&(&1 |> is_atom))
      flunk "Expected error occured: uncomment this test when worker implementation be ready"
    end
  end
end
