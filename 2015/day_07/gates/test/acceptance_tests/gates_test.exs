defmodule Acceptance.GatesTest do
  use ExUnit.Case

  test "for execrise input should return value of wire a equals to 956" do
    assert {"a", 956} == Gates.run
  end
end
