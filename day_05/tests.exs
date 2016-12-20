Code.load_file("script.exs")
ExUnit.start
ExUnit.configure exclude: :long_running, trace: true

defmodule PasswordTest do
  use ExUnit.Case

  setup do
    %{
      seed: "abc",
      password: "18F47A30"
    }
  end

  @tag :long_running
  test "every password should be 8 charaters long", %{seed: seed} do
    assert 8 == seed |> Password.make |> byte_size
  end

  @tag :long_running
  test "for seed should return provided password", %{seed: seed, password: password} do
    assert password == seed |> Password.make
  end

  @tag :long_running
  test "for given seed first character of password is 1", %{seed: seed} do
    assert "1" == seed |> Password.make(1)
  end
end

defmodule MD5Test do
  use ExUnit.Case

  setup do
    %{
      text: "abc3231929",
      hash: "00000155F8105DFF7F56EE10FA9B9ABD"
    }
  end

  test "should convert erlang bitstring (of 8 byte digits) to string of 32 hexadecimal digits", %{text: text} do
    assert 32 == text |> MD5.hash |> String.length
  end

  test "text should return provided hash", %{text: text, hash: hash} do
    assert hash == text |> MD5.hash
  end
end

defmodule AdvancedPasswordTest do
  use ExUnit.Case

  setup do
    %{
      exercise_text: "abc",
      hash_exercise_text: "0000000EA49FD3FC1B2F10E02D98EE96"
    }
  end

  test "password has option to specify length", %{exercise_text: text} do
    assert 1 == text |> AdvancedPassword.make(8605820, 1) |> String.length
  end

  test "password of length 1 should contain E on index 0", %{exercise_text: text} do
    assert "0" == text |> AdvancedPassword.make(8605820, 1)
  end

  @tag :long_running
  test "for excercise description seed should return valid password", %{exercise_text: text} do
    assert "05ACE8E3" == "abc" |> AdvancedPassword.make
  end
end

defmodule KeylockTest do
  use ExUnit.Case

  setup do
    %{
      tuple: {nil, nil, nil},
      tuple_with_value: {nil, "1", nil}
    }
  end

  describe "new" do
    test "every keylock is a tuple" do
      assert Keylock.new(8) |> is_tuple
    end

    test "keylock should be of requested length" do
      assert 3 == Keylock.new(3) |> tuple_size
    end

    test "created keylock should contain only nils" do
      assert {nil, nil, nil} == Keylock.new(3)
    end
  end

  describe "update" do
    test "should put value at position", %{tuple: tuple} do
      assert {nil, "1", nil} == tuple |> Keylock.update(1, "1")
    end

    test "if position has value should not update", %{tuple_with_value: tuple_with_value} do
      assert tuple_with_value == tuple_with_value |> Keylock.update(1, "100")
    end

    test "it is impossible to update not existing keylock position and should return same keylock tuple" do
      assert {nil, nil} == {nil, nil} |> Keylock.update(3, 1)
    end
  end

  describe "is_valid?" do
    test "keylock is valid when every space has value other than nil", %{tuple_with_value: invalid_tuple} do
      assert {"1", "2", "3"} |> Keylock.is_valid?
      refute invalid_tuple |> Keylock.is_valid?
    end
  end
end
