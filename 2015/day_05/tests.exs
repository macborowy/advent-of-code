Code.load_file("code.exs")
ExUnit.start
ExUnit.configure trace: true

defmodule ModuleTest do
  use ExUnit.Case

  describe "error messages" do
    test "when word is not binary" do
      assert {:err, "parameter is not binary."} == 1 |> Word.nice?
    end

    test "when word hasn't enough vowels" do
      {:err, reason} = "book" |> Word.nice?
      assert reason == "has not enough vowels"
    end

    test "when word hasn't double letters" do
      {:err, reason} = "diskjockey" |> Word.nice?
      assert reason == "has no double letters"
    end
  end

  describe "acceptance tests:" do
    test "ugknbfddgicrmopn is a nice word" do
      assert "ugknbfddgicrmopn" |> Word.nice?
    end

    test "aaa is a nice word" do
      assert "aaa" |> Word.nice?
    end

    test "this words are not nice (naughty)" do
      assert {:err, "has no double letters"} == "jchzalrnumimnmhp" |> Word.nice?
      assert {:err, "contains disallowed string"} == "haegwjzuvuyypxyu" |> Word.nice?
      assert {:err, "has not enough vowels"} == "dvszwmarrgswjxmb" |> Word.nice?
    end
  end

  describe "vowels:" do
    test "word aaeiou is nice because it has at least 3 vowels" do
      assert "aaeiou" |> Word.nice?
    end

    test "word with less than three vowels is not nice" do
      assert :err == "aefxx" |> Word.nice? |> elem(0)
      assert :err == "abcxx" |> Word.nice? |> elem(0)
      assert :err == "bcdxx" |> Word.nice? |> elem(0)
    end
  end

  describe "twice in a row:" do
    test "aaeiou is nice, because it contains aa string" do
      assert "aaeiou" |> Word.nice?
    end

    test "word aaaeiou is nice, because it contains aa string (two times; (aa)aeiou and a(aa)eiou)" do
      assert "aaaeiou" |> Word.nice?
    end

    test "word aei is not nice, because it doesn't contains any two letters in a row" do
      assert :err == "aei" |> Word.nice? |> elem(0)
    end
  end
end
