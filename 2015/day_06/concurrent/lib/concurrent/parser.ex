defmodule Concurrent.Parser do
  def get_commands(path), do: path |> parse |> to_commands

  defp parse(path) do
    path
    |> File.read!
    |> String.trim
    |> String.split("\n")
    |> Enum.map(&String.trim/1)
  end

  defp to_commands(lines) do
    lines |> Enum.map(&Concurrent.Command.str_to_command/1)
  end
end
