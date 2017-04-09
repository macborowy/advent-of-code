defmodule Command do
  @command_regex ~r/(turn on|turn off|toggle) (\d+),(\d+) through (\d+),(\d+)/
  @atoms [:turn_on, :turn_off, :toggle]

  defstruct [action: :turn_off, start_at: {0, 0}, finish_at: {0, 0}]

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

defmodule Controller do
  def start, do: []

  def play(turned_on, commands) do
    commands
    |> Enum.reduce(turned_on, &stopwatch_set_up/2)
  end

  defp stopwatch_set_up(command, acc) do
    {microseconds, value} = :timer.tc(&set_up/2, [acc, command])
    time = microseconds / 1_000_000

    IO.puts "Time took to finish '#{command}' command was #{time} seconds."

    value
  end

  def set_up(turned_on, command) do
    %{action: action, start_at: start, finish_at: finish} = Command.parse(command)

    to_lights(start, finish)
    |> do_command(action, turned_on)
  end

  defp to_lights({start_x, start_y}, {finish_x, finish_y}) do
    for y <- start_y..finish_y, x <- start_x..finish_x, do: {x, y}
  end

  defp do_command(lights, :turn_on, current), do: lights ++ current |> Enum.uniq
  defp do_command(lights, :turn_off, current), do: current -- lights
  defp do_command(lights, :toggle, current), do: Enum.reduce(lights, current, &toggle_reduce/2)

  defp toggle_reduce(light, turned_on) do
    case light in turned_on do
      true -> List.delete(turned_on, light)
      _    -> [light | turned_on]
    end
  end
end

if System.argv == ["--run"] do
  commands = "../input.txt" |> File.read! |> String.trim |> String.split("\n", trim: true)

  Controller.start
  |> Controller.play(commands)
  |> length
  |> IO.inspect
end
