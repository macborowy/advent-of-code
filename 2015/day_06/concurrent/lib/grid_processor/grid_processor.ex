defmodule GridProcessor do
  use GenServer

  # Client API
  def start_link, do: GenServer.start_link(__MODULE__, [], name: __MODULE__)

  def process(grid, command) do
    GenServer.handle_call(__MODULE__, {:process, grid, command})
  end

  # Server API
  def init(_), do: {:ok, nil}

  def handle_call({:process, command, grid}, _, state) do
    # %Command{action: action, start_at: start, finish_at: finish} = Command.parse(command)
    #
    # required_workers = required_workers(start, finish)
  end

  # defp required_workers({_, start_y}, {_, finish_y}), do: finish_y - start_y + 1

  defp spawn_workers(number_of_workers, rows_to_update, start, finish, state) do
    # numer of workers: wezme z required_workers/2
    # rows to update: grid |> Enum.drop(pierwsze Y row do start_y) |> Enum.take(finish_y - start_y)
    # start: start_x
    # finish: finish_x
    # action = :turn_on lub :turn_off lub :toggle
    #
    # i to jakoś trzeba zchainować albo opakowywać w kolejne metody
  end
end
