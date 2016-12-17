Code.load_file("script.exs")
ExUnit.start

defmodule AcceptanceTest do
  use ExUnit.Case

  test "should convert given instructions to 1985" do
    instructions = """
    ULL
    RRDDD
    LURDL
    UUUUD
    """

    assert instructions |> Keypad.to_code == 1985
  end
end
