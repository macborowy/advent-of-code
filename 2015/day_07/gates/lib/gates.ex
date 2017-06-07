defmodule Gates do
  @moduledoc """
  Documentation for Gates.
  """

  def run do
    Gates.Server.start_link

    "input.txt"
    |> Gates.Server.process
    |> Enum.find(fn {wire, _} -> wire == "a" end)
  end
end
