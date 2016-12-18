Code.load_file("script.exs")
ExUnit.start

defmodule AcceptanceTest do
  use ExUnit.Case

  setup do
    %{instruction: "ULL\nRRDDD\nLURDL\nUUUUD\n"}
  end

  test "PART 1: for rectangle keypad password is 1985", %{instruction: instruction} do
    assert instruction |> Keypad.to_code == "1985"
  end

  test "PART 2: for diamond keypad password is 5DB3", %{instruction: instruction} do
    assert instruction |> Keypad.to_code == "5DB3"
  end

end

defmodule KeypadTest do
  use ExUnit.Case

  setup do
    %{instructions: "URDL\nUUUU\nDDDD\nLLLL"}
  end

  describe "to_code" do
    test "instruction UUUU should return button 2" do
      assert Keypad.to_code("UUUU") == "2"
    end

    test "set up instruction should return 5287", %{instructions: instructions} do
      assert instructions |> Keypad.to_code == "5287"
    end
  end
end
defmodule InstructionTest do
  use ExUnit.Case

  setup do
    %{instructions: "URDL\nUUUU\nDDDD\nLLLL"}
  end

  describe "to_sequence" do
    test "should convert string containing instructions to password sequence", %{instructions: instructions} do
      assert instructions |> Instruction.to_sequence(5) == "5287"
    end
  end
end

defmodule MoveTest do
  use ExUnit.Case

  describe "move" do
    test "one button up from button 5 is button 2" do
      assert Move.move("U", 5) == 2
    end

    test "it is impossible to move one button up starting at any button in first row so should return same button" do
      assert Move.move("U", 1) == 1
      assert Move.move("U", 2) == 2
      assert Move.move("U", 3) == 3
    end

    test "all impossible moves should return same button" do
      assert Move.move("U", 1) == 1
      assert Move.move("U", 2) == 2
      assert Move.move("U", 3) == 3
      assert Move.move("R", 3) == 3
      assert Move.move("R", 6) == 6
      assert Move.move("R", 9) == 9
      assert Move.move("D", 9) == 9
      assert Move.move("D", 8) == 8
      assert Move.move("D", 7) == 7
      assert Move.move("L", 7) == 7
      assert Move.move("L", 4) == 4
      assert Move.move("L", 1) == 1
    end
  end
end
