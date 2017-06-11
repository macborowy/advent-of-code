defmodule Acceptance.Gates.ServerTests do
  use ExUnit.Case
  alias Gates.Server.State

  setup do
    input_file = "input.txt"
    {:ok, pid} = Gates.Server.start_link(input_file)

    %{server_pid: pid}
  end

  describe "init function tests" do
    test "after init process should has list of instructions to solve", %{server_pid: pid} do
      %State{instructions: instructions} = :sys.get_state(pid)
      assert instructions |> is_list
    end

    test "after process initialization known_wires, recently_solved and client values are nil", %{server_pid: pid} do
      state = :sys.get_state(pid)
      assert state.known_wires == nil
      assert state.recently_solved == nil
      assert state.client == nil
    end
  end

  describe "handle_call(:process, _, _) tests" do
    test "after processing for given input file, state has empty instruction list and many known_wires", %{server_pid: pid} do
      [_|_] = Gates.Server.process(pid)
      state = :sys.get_state(pid)

      assert state.instructions == []
      assert state.known_wires |> Enum.count |> Kernel.>(0)
    end

    test "the result of processing is a list", %{server_pid: pid} do
      result = Gates.Server.process(pid)
      assert result |> is_list
    end
  end
end
