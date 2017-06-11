defmodule Gates do
  @moduledoc """
  Documentation for Gates.
  """

  def run do
    {:ok, pid} = Gates.Server.start_link("input.txt")

    Gates.Server.process(pid)
    |> Enum.find(fn {wire, _} -> wire == "a" end)
  end

  def run_with_predefined do
    {:ok, pid} = Gates.Server.start_link("input.txt", [{"b", 956}])

    Gates.Server.process(pid)
    |> Enum.find(fn {wire, _} -> wire == "a" end)
  end
end
