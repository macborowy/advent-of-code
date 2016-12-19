Code.load_file("script.exs")
ExUnit.start

defmodule AcceptanceTest do
  use ExUnit.Case

  test "check rooms" do
    assert Room.is_real?("aaaaa-bbb-z-y-x-123[abxyz]")
    assert Room.is_real?("a-b-c-d-e-f-g-h-987[abcde]")
    refute Room.is_real?("not-a-real-room-404[oarel]")
    refute Room.is_real?("totally-real-room-200[decoy]")
  end
end
