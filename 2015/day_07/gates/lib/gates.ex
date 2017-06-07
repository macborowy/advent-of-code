defmodule Gates do
  @moduledoc """
  Documentation for Gates.
  """

  def run do
    {:ok, pid} = Gates.Server.start_link

    Gates.Server.process(pid, "input.txt")
    |> Enum.find(fn {wire, _} -> wire == "a" end)
  end
end
