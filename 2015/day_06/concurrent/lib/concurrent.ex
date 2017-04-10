defmodule Concurrent do
  @moduledoc false

  alias Server

  def run do
    {:ok, _} = Server.start_link
    result = Server.process("./misc/input.txt") |> IO.inspect
  end
end
