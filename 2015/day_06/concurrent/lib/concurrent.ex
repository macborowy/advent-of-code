defmodule Concurrent do
  @moduledoc false

  alias Server

  def run do
    {:ok, pid} = Server.start_link
    result = Server.process(pid, "./misc/input.txt") |> IO.inspect
  end
end
