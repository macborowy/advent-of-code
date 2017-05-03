defmodule Concurrent.Server do
  use GenServer

  ##############
  # Client API #
  ##############

  def start_link do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def run(path) do
    GenServer.call(__MODULE__, {:run, path}, :infinity)
  end

  #############
  # Callbacks #
  #############

  def init([]) do
    {:ok, Concurrent.Grid.new()}
  end

  def handle_call({:run, path}, _from, state) do

    process_all_commands = fn path ->
      path
      |> Concurrent.Parser.get_commands
      |> Enum.reduce(Concurrent.Grid.new, &process_command_with_timer/2)
      |> count_turned_on(0)
    end

    {time, value} = :timer.tc(fn -> process_all_commands.(path) end)
    IO.puts "Time to process all commands: #{time / 1_000_000}"

    {:reply, value, state}
  end

  #####################
  # Private functions #
  #####################

  defp process_command_with_timer(command, grid) do
    IO.puts "Start processing command: #{inspect command}"

    {time, value} = :timer.tc(fn -> process_command(command, grid) end)

    IO.puts "Time taken to process command: #{time / 1_000_000}"
    value
  end

  defp process_command(%Concurrent.Command{action: action, x: x, y: y, width: width, height: height}, grid) do
    {head, to_change, tail} = Concurrent.Grid.split_rows(grid, y, height)

    result =
      to_change
      |> Enum.with_index
      |> Enum.map(fn {row, index} ->
        Task.Supervisor.async(Concurrent.TasksSupervisor, Concurrent.Worker, :process, [row, action, x, width, index])
      end)
      |> Enum.map(&Task.await(&1, :infinity))
      |> Enum.sort(fn ({_, idx_1}, {_, idx_2}) -> idx_1 < idx_2 end)
      |> Enum.map(fn {row, _} -> row end)

    head ++ result ++ tail
  end

  defp count_turned_on([], acc), do: acc
  defp count_turned_on([row | rest], acc) do
    count = row |> Enum.count(fn elem -> elem == :turn_on end)
    count_turned_on(rest, acc + count)
  end
end
