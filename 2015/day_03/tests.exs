Code.load_file("code.exs")
ExUnit.start

defmodule ModuleTest do
  use ExUnit.Case

  test "Santa always visits house at starting location" do
    assert [{0, 0}] == Delivery.start
  end

  describe "move tests" do
    test "instruction ^ means visit house to north" do
      assert Delivery.start |> Delivery.move("^") |> Enum.any?(&(&1 == {0, 1}))
    end

    test "instruction < means visit house to north" do
      assert Delivery.start |> Delivery.move("<") |> Enum.any?(&(&1 == {-1, 0}))
    end

    test "instruction V means visit house to north" do
      assert Delivery.start |> Delivery.move("V") |> Enum.any?(&(&1 == {0, -1}))
    end

    test "instruction > means visit house to east" do
      assert Delivery.start |> Delivery.move(">") |> Enum.any?(&(&1 == {1, 0}))
    end
  end

  test "when Santa has one move instruction he visits two houses" do
    assert 2 == Delivery.start |> Delivery.move(">") |> Enum.count
  end

  test "for ^V^V^V^V^V instruction Santa visits only two houses" do
    assert Delivery.visit_all("^V^V^V^V^V") |> Enum.all?(&(&1 == {0, 0} || &1 == {0, 1}))
  end
end
