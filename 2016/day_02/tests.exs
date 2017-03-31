Code.load_file("script.exs")
ExUnit.start

defmodule AcceptanceTest do
  use ExUnit.Case

  setup do
    %{instruction: "ULL\nRRDDD\nLURDL\nUUUUD\n"}
  end

  test "PART 1: for rectangle keypad password is 1985", %{instruction: instruction} do
    assert instruction |> Instruction.to_sequence(:rectangle) == "1985"
  end

  test "PART 2: for diamond keypad password is 5DB3", %{instruction: instruction} do
    assert instruction |> Instruction.to_sequence(:diamond) == "5DB3"
  end

end

defmodule InstructionTest do
  use ExUnit.Case

  setup do
    %{instructions: "URDL\nUUUU\nDDDD\nLLLL"}
  end

  describe "to_sequence" do
    test "should convert string containing instructions to password sequence", %{instructions: instructions} do
      assert instructions |> Instruction.to_sequence(:rectangle) == "5287"
    end

    test "instruction UUUU should return button 2" do
        assert Instruction.to_sequence("UUUU", :rectangle) == "2"
    end
  end
end

defmodule KeypadTest do
  use ExUnit.Case

  describe "move" do
    test "one button up from button 5 is button 2" do
      assert Keypad.move("U", "5", :rectangle) == "2"
    end

    test "it is impossible to move one button up starting at any button in first row so should return same button" do
      assert Keypad.move("U", "1", :rectangle) == "1"
      assert Keypad.move("U", "2", :rectangle) == "2"
      assert Keypad.move("U", "3", :rectangle) == "3"
    end

    test "all impossible moves should return same button" do
      assert Keypad.move("U", "1", :rectangle) == "1"
      assert Keypad.move("U", "2", :rectangle) == "2"
      assert Keypad.move("U", "3", :rectangle) == "3"
      assert Keypad.move("R", "3", :rectangle) == "3"
      assert Keypad.move("R", "6", :rectangle) == "6"
      assert Keypad.move("R", "9", :rectangle) == "9"
      assert Keypad.move("D", "9", :rectangle) == "9"
      assert Keypad.move("D", "8", :rectangle) == "8"
      assert Keypad.move("D", "7", :rectangle) == "7"
      assert Keypad.move("L", "7", :rectangle) == "7"
      assert Keypad.move("L", "4", :rectangle) == "4"
      assert Keypad.move("L", "1", :rectangle) == "1"
    end
  end

  describe "diamond shape moves" do
    test "every available move to left should return previous character" do
      assert Keypad.move("L", "3", :diamond) == "2"
      assert Keypad.move("L", "4", :diamond) == "3"
      assert Keypad.move("L", "6", :diamond) == "5"
      assert Keypad.move("L", "7", :diamond) == "6"
      assert Keypad.move("L", "8", :diamond) == "7"
      assert Keypad.move("L", "9", :diamond) == "8"
      assert Keypad.move("L", "B", :diamond) == "A"
      assert Keypad.move("L", "C", :diamond) == "B"
    end
    test "every available move to right should return next character" do
      assert Keypad.move("R", "2", :diamond) == "3"
      assert Keypad.move("R", "3", :diamond) == "4"
      assert Keypad.move("R", "5", :diamond) == "6"
      assert Keypad.move("R", "6", :diamond) == "7"
      assert Keypad.move("R", "7", :diamond) == "8"
      assert Keypad.move("R", "8", :diamond) == "9"
      assert Keypad.move("R", "A", :diamond) == "B"
      assert Keypad.move("R", "B", :diamond) == "C"
    end
    test "moving down from button 1 should return button 3" do
      assert Keypad.move("D", "1", :diamond) == "3"
    end
    test "moving down from 2,3 or 4 should return 6,7 and 8 consequently" do
      assert Keypad.move("D", "2", :diamond) == "6"
      assert Keypad.move("D", "3", :diamond) == "7"
      assert Keypad.move("D", "4", :diamond) == "8"
    end
    test "moving down from 6,7 or 8 should return A,B and C consequently" do
      assert Keypad.move("D", "6", :diamond) == "A"
      assert Keypad.move("D", "7", :diamond) == "B"
      assert Keypad.move("D", "8", :diamond) == "C"
    end
    test "moving down from button B should return button D" do
      assert Keypad.move("D", "B", :diamond) == "D"
    end
  end
end
