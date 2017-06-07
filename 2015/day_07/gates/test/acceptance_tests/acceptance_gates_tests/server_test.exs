defmodule Acceptance.Gates.ServerTests do
  use ExUnit.Case
  alias Gates.Server.State

  @input_file "input.txt"

  setup do
    {:ok, _} = Gates.Server.start_link
    :ok
  end

  describe "init function tests" do
    test "after process initialization all State values are nil" do
      assert %State{instructions: nil, known_wires: nil, client: nil} == :sys.get_state(Gates.Server)
    end
  end

  describe "handle_call(:process, _, _) tests" do
    test "after processing for given input file, state has empty instruction list and many known_wires" do
      [_|_] = Gates.Server.process(@input_file)
      state = :sys.get_state(Gates.Server)

      assert state.instructions == []
      assert state.known_wires |> Enum.count |> Kernel.>(0)
    end

    test "the result of processing is a list" do
      result = Gates.Server.process(@input_file)
      assert result |> is_list
    end
  end
end
