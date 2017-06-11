defmodule Matchsticks do
  @moduledoc false

  def count_for(input) do
    input
    |> File.read!
    |> String.split("\n")
    |> Enum.reduce({0, 0}, &count/2)
  end

  def count(input, result \\ {0, 0})
  def count(<<>>, result), do: result
  def count(<<"\"", rest::binary>>, {code, char}), do: count(rest, {code + 1, char})
  def count(<<"\\\\", rest::binary>>, {code, char}), do: count(rest, {code + 2, char + 1})
  def count(<<"\\\"", rest::binary>>, {code, char}), do: count(rest, {code + 2, char + 1})
  def count(<<"\\x", hex::16, rest::binary>>, {code, char}), do: count(rest, {code + 4, char + 1})
  def count(<<c::8, rest::binary>>, {code, char}), do: count(rest, {code + 1, char + 1})
end
