defmodule Grid do
  @moduledoc false

  @doc """
  Return a rectangle grid of default values (:turn_off). The size of grid is 1000x1000.
  """
  def new, do: 1..1000 |> Enum.map(fn _ -> create_row() end)

  defp create_row, do: 1..1000 |> Enum.map(fn _ -> :turn_off end)
end
