Code.load_file("code.exs")
ExUnit.start
ExUnit.configure trace: true

defmodule ModuleTest do
  use ExUnit.Case

  test "the truth" do
    assert 1 == 1
  end
end
