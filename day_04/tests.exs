Code.load_file("script.exs")
ExUnit.start

defmodule AcceptanceTest do
  use ExUnit.Case

  test "should return sum of real room sectors" do
    input = "aaaaa-bbb-z-y-x-123[abxyz]\na-b-c-d-e-f-g-h-987[abcde]\nnot-a-real-room-404[oarel]\ntotally-real-room-200[decoy]\n"

    assert input |> Script.get_sum_of_sectors == 1514
  end
end

defmodule RoomTest do
  use ExUnit.Case

  test "check rooms" do
    assert Room.is_real?("aaaaa-bbb-z-y-x-123[abxyz]")
    assert Room.is_real?("a-b-c-d-e-f-g-h-987[abcde]")
    assert Room.is_real?("not-a-real-room-404[oarel]")
    refute Room.is_real?("totally-real-room-200[decoy]")
  end

  test "get sectors" do
    assert Room.sector("aaaaa-bbb-z-y-x-123[abxyz]") == 123
    assert Room.sector("a-b-c-d-e-f-g-h-987[abcde]") == 987
    assert Room.sector("not-a-real-room-404[oarel]") == 404
    assert Room.sector("totally-real-room-200[decoy]") == 200
  end
end
