defmodule Gates.ServerTest do
  use ExUnit.Case

  test "setting custom wire value should add it to known_wires" do
    {:ok, pid} = Gates.Server.start_link("input.txt", [{"b", 12345}])

    wire_b = get_wire(pid, "b")
    assert 12345 == wire_b |> elem(1)
  end

  test "for existing signal instruction setting predefined wire should remove it from instructions to solve" do
    full_instructions_count = "input.txt" |> Gates.Parser.get_instructions |> Enum.count

    {:ok, pid} = Gates.Server.start_link("input.txt", [{"b", 12345}])

    assert nil == :sys.get_state(pid) |> Map.get(:instructions) |> Enum.find(fn %{output: wire} -> wire == "b" end)
    assert full_instructions_count - 1 == :sys.get_state(pid) |> Map.get(:instructions) |> Enum.count
  end

  defp get_wire(pid, wire) do
    :sys.get_state(pid)
    |> Map.get(:known_wires)
    |> Enum.find(fn {w, _} -> w == wire end)
  end
end
