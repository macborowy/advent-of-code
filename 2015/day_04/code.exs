defmodule Miner do
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
