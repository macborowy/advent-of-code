defmodule Miner do
  @doc """
  Searches for the answer to succesfully mine Santa's AdventCoin.

  `secret` is a secret phrase you are looking for an answer, `prefix` is a prefix you know the right answer starts with, and `acc` is the value you are testing if it produces hash with provided prefix. If the hash test pass, value of the `acc` is the answer to mine a coin.

  You can provide custom `prefix`, if test rules change, and custom `acc` (greater than 0), if you know that answer is greater or equals to this number.
  """
  # TODO: add concurrent hash testing support
  def find_answer(secret, prefix \\ "00000", acc \\ 0) do
    hash = hash(secret <> to_string(acc))
    cond do
      String.starts_with?(hash, prefix) -> acc
      true                              -> find_answer(secret, prefix, acc + 1)
    end
  end

  def hash(msg) do
    :erlang.md5(msg)
    |> :erlang.bitstring_to_list
    |> Enum.map(&(:io_lib.format("~2.16.0b", [&1])))
    |> List.flatten
    |> to_string
  end
end

if System.argv == ["--run"] do
  "bgvyzdsv" |> Miner.find_answer |> IO.puts
  "bgvyzdsv" |> Miner.find_answer("000000") |> IO.puts
end
