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
      |> Enum.reduce(Concurrent.Grid.new, &process_single_command/2)
      |> Concurrent.Grid.total_brightness

    {:reply, result, state}
  end

  #####################
  # Private functions #
  #####################

  defp process_single_command(%Concurrent.Command{y: from, height: length} = command, grid) do
    {head, to_change, tail} = Concurrent.Grid.split_rows(grid, from, length)

    result =
      to_change
      |> Enum.with_index
      |> Enum.map(&row_to_task(&1, command))
      |> Enum.map(&Task.await/1)
      |> Enum.sort(&by_row_index/2)
      |> Enum.map(&to_row/1)

    head ++ result ++ tail
  end

  defp row_to_task({row, index}, command) do
    Task.Supervisor.async(Concurrent.TasksSupervisor, Concurrent.Grid, :apply_command, [row, command, index])
  end

  defp by_row_index({_, index_1}, {_, index_2}), do: index_1 < index_2

  def to_row({row, _}), do: row
end
