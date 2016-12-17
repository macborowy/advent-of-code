defmodule Headquater do
  def distance(input), do: input |> MyModule.calculate
  def outcome(_), do: %{}
end

defmodule MyModule do
  def calculate(input), do: input |> walk |> Coordinates.distance

  def walk(""), do: Coordinates.new
  def walk(input) do
    input
    |> String.split(", ")
    |> Enum.reduce({:north, Coordinates.new}, &do_walk/2)
    |> elem(1)
  end

  def do_walk(elem, {current_direction, coords}) do
    new_direction = current_direction |> Direction.turn(elem)
    steps = elem |> parse

    {new_direction, Coordinates.update(coords, new_direction, steps)}
  end

  def parse(<<_::8>> <> steps), do: steps |> Integer.parse |> elem(0)
end

defmodule Direction do
  def turn(:north, "R" <> _), do: :east
  def turn(:east, "R" <> _), do: :south
  def turn(:south, "R" <> _), do: :west
  def turn(:west, "R" <> _), do: :north
  def turn(:north, "L" <> _), do: :west
  def turn(:west, "L" <> _), do: :south
  def turn(:south, "L" <> _), do: :east
  def turn(:east, "L" <> _), do: :north
end

defmodule Coordinates do
  defstruct [north: 0, south: 0, east: 0, west: 0]

  def new, do: %Coordinates{}
  def distance(%{north: n, south: s, east: e, west: w}), do: abs(e-w) + abs(n-s)
  def update(%Coordinates{} = coords, direction, steps) do
    Map.update(coords, direction, steps, &(&1 + steps))
  end
end
