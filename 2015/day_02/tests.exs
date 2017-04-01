Code.load_file("code.exs")
ExUnit.start

defmodule ModuleTest do
  use ExUnit.Case

  describe "acceptance tests" do
    test "present with dimensions 2x3x4 requires 58 square feet of wrapping paper" do
      assert 58 == Present.required_paper("2x3x4")
    end

    test "present with dimensions 1x1x10 requires 43 square feet of wrapping paper" do
      assert 43 == Present.required_paper("1x1x10") 
    end
  end
end
