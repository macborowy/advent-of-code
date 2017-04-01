Code.load_file("code.exs")
ExUnit.start

defmodule ModuleTest do
  use ExUnit.Case

  test "Santa starting location is {0, 0}" do
    houses_visited = Delivery.visit_all("")
    assert 1 == houses_visited |> Enum.count
    assert {0, 0} == houses_visited |> List.first
  end

  describe "move tests" do
    test "instruction ^ means visit house to north" do
      assert Delivery.visit_all("^") |> Enum.any?(&(&1 == {0, 1}))
    end

    test "instruction < means visit house to north" do
      assert Delivery.visit_all("<") |> Enum.any?(&(&1 == {-1, 0}))
    end

    test "instruction V means visit house to north" do
      assert Delivery.visit_all("v") |> Enum.any?(&(&1 == {0, -1}))
    end

    test "instruction > means visit house to east" do
      assert Delivery.visit_all(">") |> Enum.any?(&(&1 == {1, 0}))
    end
  end

  test "when Santa has one move instruction he visits two houses" do
    assert 2 == Delivery.visit_all(">") |> Enum.count
  end

  test "for ^V^V^V^V^V instruction Santa visits only two houses" do
    assert Delivery.visit_all("^v^v^v^v^v") |> Enum.all?(&(&1 == {0, 0} || &1 == {0, 1}))
  end
end
