Code.load_file("code.exs")
ExUnit.start

defmodule ModuleTest do
  use ExUnit.Case

  test "the truth" do
    assert 1 == 1
  end
end
