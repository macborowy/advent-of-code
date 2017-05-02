defmodule Concurrent do
  use Application

  def start(_type, _args) do
    Concurrent.Supervisor.start_link
  end
end
