Code.load_file("script.exs")
ExUnit.start

defmodule AcceptanceTest do
  use ExUnit.Case

  test "should convert given instructions to 1985" do
    assert "ULL\nRRDDD\nLURDL\nUUUUD\n" |> Keypad.to_code == 1985
  end
end

defmodule KeypadTest do
  use ExUnit.Case

  setup do
    %{instructions: "URDL\nUUUU\nDDDD\nLLLL"}
  end

  describe "to_code" do
    test "instruction UUUU should return button 2" do
      assert Keypad.to_code("UUUU") == 2
    end

    test "set up instruction should return 5287", %{instructions: instructions} do
      assert instructions |> Keypad.to_code == 5287
    end
  end

  # describe "parse" do
  #   test "should split lines by new line", %{instructions: instructions} do
  #     assert instructions |> Keypad.parse |> length == 4
  #   end

  #   test "each element should be list of moves to do", %{instructions: instructions} do
  #     assert instructions |> Keypad.parse |> hd == ["U", "R", "D", "L"]
  #   end
  # end

  # describe "move" do
  #   test "one button up from button 5 is button 2" do
  #     assert Keypad.move("U", 5) == 2
  #   end

  #   test "it is impossible to move one button up starting at any button in first row so should return same button" do
  #     assert Keypad.move("U", 1) == 1
  #     assert Keypad.move("U", 2) == 2
  #     assert Keypad.move("U", 3) == 3
  #   end

  #   test "all impossible moves should return same button" do
  #     assert Keypad.move("U", 1) == 1
  #     assert Keypad.move("U", 2) == 2
  #     assert Keypad.move("U", 3) == 3
  #     assert Keypad.move("R", 3) == 3
  #     assert Keypad.move("R", 6) == 6
  #     assert Keypad.move("R", 9) == 9
  #     assert Keypad.move("D", 9) == 9
  #     assert Keypad.move("D", 8) == 8
  #     assert Keypad.move("D", 7) == 7
  #     assert Keypad.move("L", 7) == 7
  #     assert Keypad.move("L", 4) == 4
  #     assert Keypad.move("L", 1) == 1
  #   end
  # end

  # describe "find_button" do
  #   test "starting at button 5 and having instruction UUUU should return button 2" do
  #     assert Keypad.find_button(["U", "U", "U", "U"], 5) == 2
  #   end
  # end
end
