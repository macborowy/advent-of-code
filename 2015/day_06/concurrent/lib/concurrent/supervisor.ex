defmodule Concurrent.Supervisor do
  use Supervisor

  def start_link do
     Supervisor.start_link(__MODULE__, [])
  end

  def init([]) do
    children = [
      worker(Concurrent.Server, []),
      worker(Concurrent.WorkerServer, [])
    ]
    options = [strategy: :one_for_one]

    supervise(children, options)
  end
end
