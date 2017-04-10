defmodule ProcessorTest do
  use ExUnit.Case

  alias GridProcessor

  setup do
    {:ok, pid} = GridProcessor.start_link
    %{pid: pid}
  end

  test "initally has no state" do
    assert nil == :sys.get_state(GridProcessor)
  end

  test "Processor can be instantianted only once", %{pid: pid} do
    assert {:error, {:already_started, pid}} == GridProcessor.start_link
  end
end
