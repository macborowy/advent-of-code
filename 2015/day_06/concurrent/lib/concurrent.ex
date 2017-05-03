defmodule Concurrent do
  use Application

  def start(_type, _args) do
    Concurrent.Supervisor.start_link
  end

  def run(input) do
    {time, value} = :timer.tc(fn -> Concurrent.Server.run(input) end)
    IO.puts "The result is: #{value}. Time to complete: #{Float.round(time / 1_000_000, 2)} second(s)."
  end
end
