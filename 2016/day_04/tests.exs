Code.load_file("script.exs")
ExUnit.start

defmodule ExerciseAnswerTest do
  use ExUnit.Case

  test "part 1 answer" do
    assert 278221 == "input.txt" |> File.read! |> Exercise.sum_of_sectors
  end

  test "part 2 answer" do
    assert 267 == "input.txt"
    |> File.read!
    |> Exercise.real_room_names
    |> Enum.find(fn {room, _} -> room == "northpole object storage" end)
    |> elem(1)
  end
end

defmodule RoomTest do
  use ExUnit.Case

  describe "sector" do
    test "should return sum of real room sectors" do
      input = "aaaaa-bbb-z-y-x-123[abxyz]\na-b-c-d-e-f-g-h-987[abcde]\nnot-a-real-room-404[oarel]\ntotally-real-room-200[decoy]\n"

      assert input |> Exercise.sum_of_sectors == 1514
    end

    test "get sectors" do
      assert Room.sector("aaaaa-bbb-z-y-x-123[abxyz]") == 123
      assert Room.sector("a-b-c-d-e-f-g-h-987[abcde]") == 987
      assert Room.sector("not-a-real-room-404[oarel]") == 404
      assert Room.sector("totally-real-room-200[decoy]") == 200
    end
  end

  describe "real_name" do
    test "should decipher room name" do
      encrypted_name = "qzmt-zixmtkozy-ivhz-343"
      expected ="very encrypted name"

      assert expected == encrypted_name |> Room.real_name
    end
  end
end

defmodule CipherTest do
  use ExUnit.Case

  describe "is_valid?" do
    test "should check if cipher has checksum same as provided one" do
      assert Cipher.is_valid?("aaaaa-bbb-z-y-x-123[abxyz]")
      assert Cipher.is_valid?("a-b-c-d-e-f-g-h-987[abcde]")
      assert Cipher.is_valid?("not-a-real-room-404[oarel]")
      refute Cipher.is_valid?("totally-real-room-200[decoy]")
    end
  end
end

defmodule ShiftTest do
  use ExUnit.Case

  describe "shift" do
    test "shifting a 27 letters forward returns b" do
      assert Shift.forward("a", 27) == "b"
    end

    test "shifting z 1 letter forward returns a" do
      assert Shift.forward("z", 1) == "a"
    end

    test "shifting a 343 letters forward returns f" do
      assert Shift.forward("a", 343) == "f"
    end

    test "shifting space always return space" do
      assert Shift.forward(" ", 1100) == " "
    end
  end
end
