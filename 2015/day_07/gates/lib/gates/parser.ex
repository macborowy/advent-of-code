defmodule Gates.Parser do
  def get_instructions(file_path) do
    file_path
    |> read_file
    |> to_instructions
  end

  defp read_file(file_path) do
    file_path
    |> File.read!
    |> String.trim
    |> String.split("\n")
  end

  defp to_instructions(raw_lines) do
     raw_lines |> Enum.map(&Gates.Instruction.new/1)
  end
end
