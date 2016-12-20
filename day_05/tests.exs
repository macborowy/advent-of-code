Code.load_file("script.exs")
ExUnit.start

defmodule PasswordTest do
  use ExUnit.Case

  setup do
    %{
      seed: "abc",
      password: "18F47A30"
    }
  end

  test "every password should be 8 charaters long", %{seed: seed} do
    assert 8 == seed |> Password.make |> byte_size
  end

  test "for seed should return provided password", %{seed: seed, password: password} do
    assert password == seed |> Password.make
  end

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
