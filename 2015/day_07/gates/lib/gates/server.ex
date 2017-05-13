defmodule Gates.Server do
  use GenServer

  defmodule State do
    defstruct [instructions: nil, known_wires: nil, current_state: nil]
  end

  ##############
  # Client API #
  ##############

  def start_link do
    GenServer.start_link(__MODULE__, [], [name: __MODULE__])
  end

  def process(file_path) do
    GenServer.call(__MODULE__, {:process, file_path}, :infinity)
  end

  #############
  # Callbacks #
  #############

  def init([]) do
    {:ok, %State{instructions: [], known_wires: [], current_state: :idle}}
  end

  def handle_call({:process, file_path}, _from, state) do
    instructions = file_path |> read_instructions

    signals = Gates.Finder.find(instructions, :signals)

    new_wires = signals |> Enum.map(&Gates.Processor.process(&1, []))
    instructions_without_signals = instructions |> remove_solved(signals)

    result = do_process(instructions_without_signals, new_wires)

    {:reply, result, state}
  end

  #####################
  # Private Functions #
  #####################

  defp read_instructions(file_path) do
    file_path
    |> File.read!
    |> String.trim
    |> String.split("\n")
    |> Enum.map(&Gates.Instruction.new/1)
  end

  defp remove_solved(instructions, solved) do
    instructions -- solved
  end

  # recently_solved contain list of wires resolved in previous do_process execution
  # the idea was to prevent do_process/3 from checking always growing list of known_wires each time
  defp do_process(instructions, recently_solved, known_wires \\ [])
  defp do_process([], recenlty_solved, known_wires), do: known_wires ++ recenlty_solved
  defp do_process(instructions, recently_solved, known_wires) do
    known_wires = recently_solved ++ known_wires

    instructions_to_solve =
      recently_solved
      |> Enum.map(fn {wire, _} -> wire end)
      |> Enum.map(&Gates.Finder.find(instructions, &1, known_wires))
      |> List.flatten
      |> Enum.uniq

    new_wires =
      instructions_to_solve
      |> Enum.map(&Gates.Processor.process(&1, known_wires))

    instructions = instructions |> remove_solved(instructions_to_solve)

    do_process(instructions, new_wires, known_wires)
  end
end
