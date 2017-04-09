defmodule Server do
  use GenServer

  alias Grid

  # Client API
  def start_link do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def process(pid, path_to_file) do
    GenServer.call(pid, {:process, path_to_file})
  end

  # Server API
  def init(_) do
    {:ok, %{grid: Grid.new}}
  end

  def handle_call({:process, path}, _, state) do
    result = start_processing(path, state)
    {:reply, result, Map.put(state, :grid, result)}
  end

  defp start_processing(content, state) do
    content
    |> File.read
    |> parse_input
    |> do_process(state)
  end

  defp parse_input({:ok, content}), do: content |> String.trim |> String.split("\n", trim: true)

  defp do_process([], state), do: state
  defp do_process([command | tail], state) do
    do_process(tail, state)
  end
end
