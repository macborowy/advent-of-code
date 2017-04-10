defmodule WorkerTest do
  use ExUnit.Case

  alias Worker

  setup do
    %{
      row: List.duplicate(:turn_off, 1000),
      row_index: 0
    }
  end

  defp get_first_and_last_of_state(row, state) do
    row_with_indexes = row |> Enum.with_index |> Enum.filter(fn {v, _} -> v == state end)
    first = row_with_indexes |> Enum.at(0) |> elem(1)
    last  = row_with_indexes |> List.last  |> elem(1)

    {first, last}
  end

  describe "update" do
    test "change state of elements in range from start to finish (inclusive)", %{row: row, row_index: idx} do
      updated_row = Worker.update(row, idx, 100, 599, :turn_on)

      assert {100, 599} == get_first_and_last_of_state(updated_row, :turn_on)
    end

    test "for :turn_on action change state of row elements to specified", %{row: row, row_index: idx} do
      updated_row = Worker.update(row, idx, 100, 599, :turn_on)
      assert 500 == updated_row |> Enum.count(&(&1 == :turn_on))
    end

    test "for :turn_off action change state of row elements to specified", %{row: row, row_index: idx} do
      updated_row = Worker.update(row, idx, 100, 599, :turn_off)
      assert 1000 == updated_row |> Enum.count(&(&1 == :turn_off))
    end

    test "for :toggle action change state of element to opposite", %{row: row, row_index: idx} do
      updated_row = Worker.update(row, idx, 200, 299, :toggle)

      assert 100 == updated_row |> Enum.count(&(&1 == :turn_on))
      assert {200, 299} == get_first_and_last_of_state(updated_row, :turn_on)
    end
  end
end
