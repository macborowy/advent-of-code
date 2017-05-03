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
    result =
      path
      |> Concurrent.Parser.get_commands_from_file
      |> Enum.reduce(Concurrent.Grid.new, &process_command/2)
      |> total_brightness

    {:reply, result, state}
  end

  #####################
  # Private functions #
  #####################

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

  defp total_brightness(grid), do: grid |> Enum.reduce(0, &(&2 + Enum.sum(&1)))
end
