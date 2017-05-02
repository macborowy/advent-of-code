defmodule Concurrent.Server do
  use GenServer

  ##############
  # Client API #
  ##############

  def start_link do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def run(path) do
    GenServer.call(__MODULE__, {:run, path})
  end

  #############
  # Callbacks #
  #############

  def init([]) do
    {:ok, Concurrent.Grid.new()}
  end

  def handle_call({:run, path}, _from, state) do

     {:reply, :ok, state}
  end
end
