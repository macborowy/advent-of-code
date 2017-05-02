defmodule Concurrent.Supervisor do
  use Supervisor

  def start_link do
     Supervisor.start_link(__MODULE__, [])
  end

  def init([]) do
    children = [
      supervisor(Task.Supervisor, [[name: Concurrent.TasksSupervisor]]),
      worker(Concurrent.Server, [])
    ]
    options = [strategy: :one_for_one]

    supervise(children, options)
  end
end
