defmodule Concurrent do
  use Application

  def start(_type, _args) do
    Concurrent.Supervisor.start_link
  end

  def run(input) do
     result = Concurrent.Server.run(input)
     IO.puts result
  end
end
