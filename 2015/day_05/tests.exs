Code.load_file("code.exs")
ExUnit.start
ExUnit.configure trace: true

defmodule ModuleTest do
  use ExUnit.Case

  test "when word is not binary, it is not nice" do
    assert {:err, "Parameter is not binary."} == 1 |> Word.nice?
  end

  describe "vowels" do
    test "word aei is nice because it has at least 3 vowels" do
      assert "aei" |> Word.nice?
    end

    test "word with less than three vowels is not nice" do
      assert :err == "aef" |> Word.nice? |> elem(0)
      assert :err == "abc" |> Word.nice? |> elem(0)
      assert :err == "bcd" |> Word.nice? |> elem(0)
    end

    test "when word hasn't enough vowels should return appropriate message" do
      {:err, reason} = "consonants" |> Word.nice?
      assert reason == "hasn't enough vowels (minimum 3 different)"
    end
  end
end
