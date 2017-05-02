defmodule Concurrent.WorkerTest do
  use ExUnit.Case

  describe "process/4" do
    test "should change every element from specified range to state" do
      list_1 = [:turn_off,:turn_off,:turn_off,:turn_off,:turn_off,:turn_off,:turn_off,:turn_off,:turn_off,:turn_off]
      list_2 = [:turn_off,:turn_off,:turn_off,:turn_off,:turn_on,:turn_on,:turn_on,:turn_on,:turn_on,:turn_off]

      assert {[:turn_off, :turn_off, :turn_off, :turn_off, :turn_on, :turn_on, :turn_on, :turn_on, :turn_on, :turn_off], 1} ==
                Concurrent.Worker.process(list_1, :turn_on, 4, 5, 1)

      assert {[:turn_off, :turn_off, :turn_off, :turn_off, :turn_off, :turn_on, :turn_on, :turn_on, :turn_on, :turn_off], 1} ==
                Concurrent.Worker.process(list_2, :turn_off, 2, 3, 1)

      assert {[:turn_on, :turn_on, :turn_on, :turn_on, :turn_off, :turn_off, :turn_off, :turn_off, :turn_off, :turn_on], 1} ==
                Concurrent.Worker.process(list_2, :toggle, 0, 10, 1)
    end
  end
end
