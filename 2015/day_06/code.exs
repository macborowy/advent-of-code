defmodule Command do
  @command_regex ~r/(turn on|turn off|toggle) (\d+),(\d+) through (\d+),(\d+)/
  @atoms [:turn_on, :turn_off, :toggle]

  defstruct [action: :turn_on, start_at: {0, 0}, finish_at: {0, 0}]

  def new, do: %Command{}
  def new([action, x1, y1, x2, y2]) do
    %Command{
      action:   action |> String.replace(" ", "_") |> String.to_existing_atom,
      start_at:  {to_int(x1), to_int(y1)},
      finish_at: {to_int(x2), to_int(y2)}
    }
  end

  def parse(command) do
    case Regex.scan(@command_regex, command) do
      [[_ | results]] -> Command.new(results)
      _               -> {:error, "invalid command: #{command}"}
    end
  end

  defp to_int(string), do: String.to_integer(string)
end

defmodule Decoration do
  def new, do: for x <- 0..999, y <- 0..999, do: {:turn_off, x, y}

  def change(decoration_grid, command) do
    %Command{action: action, start_at: {start_x, start_y}, finish_at: {finish_x, finish_y}} = Command.parse(command)

    for light = {_, x, y} <- decoration_grid,
        do: if x in start_x..finish_x && y in start_y..finish_y,
            do: do_change(light, action),
            else: light
  end

  defp do_change({_,         x, y}, :turn_on),  do: {:turn_on,  x, y}
  defp do_change({_,         x, y}, :turn_off), do: {:turn_off, x, y}
  defp do_change({:turn_on,  x, y}, :toggle),   do: {:turn_off, x, y}
  defp do_change({:turn_off, x, y}, :toggle),   do: {:turn_on,  x, y}
end

if System.argv == ["--run"] do
  "input.txt"
  |> File.read!
  |> String.trim
  |> String.split("\n", trim: true)
  # |> Enum.take(5)
  |> Enum.reduce(Decoration.new, fn command, decoration -> Decoration.change(decoration, command) end)
  |> Enum.count(&(:turn_on == &1 |> elem(0)))
  |> IO.puts
end
