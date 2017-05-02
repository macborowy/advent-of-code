defmodule Concurrent.Command do
  @command_regex ~r/(turn on|turn off|toggle) (\d+),(\d+) through (\d+),(\d+)/

  defstruct [action: nil, x: nil, y: nil, width: nil, height: nil]

  def str_to_command(str) do
    [[_ | results]] = Regex.scan(@command_regex, str)

    results |> to_command
  end

  defp to_command([action, from_x, from_y, end_x, end_y]) do
    # TODO: possible problems with to_atom
    %Concurrent.Command{
      action: action |> String.replace(" ", "_") |> String.to_atom,
      x: to_int(from_x),
      y: to_int(from_y),
      width:  to_int(end_x) - to_int(from_x) + 1,
      height: to_int(end_y) - to_int(from_y) + 1
    }
  end

  def to_int(str), do: str |> String.to_integer
end
