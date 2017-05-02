defmodule Concurrent.Grid do
  def new do
    1..1_000
    |> Enum.map(fn _ ->
      1..1000
      |> Enum.map(fn _ -> :turn_off end)
    end)
  end
end
