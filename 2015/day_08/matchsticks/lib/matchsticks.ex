defmodule Matchsticks do
  @moduledoc false

  def count_for(input, :decode), do: input |> read_file |> Enum.reduce({0, 0}, &decode/2)
  def count_for(input, :encode), do: input |> read_file |> Enum.reduce({0, 0}, &encode/2)

  def decode(input, result \\ {0, 0})
  def decode(<<>>, result), do: result
  def decode(<<"\"",            rest::binary>>, {code, char}), do: decode(rest, {code + 1, char})
  def decode(<<"\\\"",          rest::binary>>, {code, char}), do: decode(rest, {code + 2, char + 1})
  def decode(<<"\\\\",          rest::binary>>, {code, char}), do: decode(rest, {code + 2, char + 1})
  def decode(<<"\\x", _hex::16, rest::binary>>, {code, char}), do: decode(rest, {code + 4, char + 1})
  def decode(<<_c::8,           rest::binary>>, {code, char}), do: decode(rest, {code + 1, char + 1})

  def encode(input, result \\ {0, 0})
  def encode(<<>>, {code, char}), do: {code + 2, char}
  def encode(<<"\"",  rest::binary>>, {code, char}), do: encode(rest, {code + 2, char + 1})
  def encode(<<"\\",  rest::binary>>, {code, char}), do: encode(rest, {code + 2, char + 1})
  def encode(<<_c::8, rest::binary>>, {code, char}), do: encode(rest, {code + 1, char + 1})

  defp read_file(file_path), do: file_path |> File.read! |> String.trim |> String.split("\n")
end
