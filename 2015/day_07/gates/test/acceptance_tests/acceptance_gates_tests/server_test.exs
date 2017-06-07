defmodule Acceptance.Gates.ServerTests do
  use ExUnit.Case
  alias Gates.Server.State

  @input_file "input.txt"

  setup do
    {:ok, pid} = Gates.Server.start_link
    %{server_pid: pid}
  end

  describe "init function tests" do
    test "after process initialization all State values are nil", %{server_pid: pid} do
      assert %State{instructions: nil, known_wires: nil, client: nil} == :sys.get_state(pid)
    end
  end

  describe "handle_call(:process, _, _) tests" do
    test "after processing for given input file, state has empty instruction list and many known_wires", %{server_pid: pid} do
      [_|_] = Gates.Server.process(pid, @input_file)
      state = :sys.get_state(pid)

      assert state.instructions == []
      assert state.known_wires |> Enum.count |> Kernel.>(0)
    end

    test "the result of processing is a list", %{server_pid: pid} do
      result = Gates.Server.process(pid, @input_file)
      assert result |> is_list
    end
  end
end
