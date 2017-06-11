defmodule Gates.Server do
  @moduledoc """
  Process orhestrating whole computation.
  """

  use GenServer

  defmodule State do
    @moduledoc false
    defstruct instructions: nil, known_wires: nil, recently_solved: nil, client: nil
  end

  ##############
  # Client API #
  ##############

  @doc """
  Starts the Server process. The `file_path` is the path to input file.
  """
  def start_link(file_path, predefined_values \\ []),
    do: GenServer.start_link(__MODULE__, [file_path, predefined_values])

  @doc """
  Processes instructions in the state.
  """
  def process(pid), do: GenServer.call(pid, :process)

  #############
  # Callbacks #
  #############

  def init([file_path, []]) do
    instructions = file_path |> Gates.Parser.get_instructions
    {:ok, %State{instructions: instructions, known_wires: []}}
  end

  def init([file_path, predefined_values]) do
    instructions =
      file_path
      |> Gates.Parser.get_instructions
      |> reject_signal_instructions_for(predefined_values)

    {:ok, %State{instructions: instructions, known_wires: predefined_values}}
  end

  def handle_call(:process, from, state) do
    send(self(), :find_signals)
    {:noreply, %State{state | client: from}}
  end

  def handle_info(:find_signals, %{instructions: instructions} = state) do
    {signals, reduced_instructions} = get_signals(instructions)

    new_state = %State{
      state |
      instructions: reduced_instructions,
      recently_solved: signals ++ state.known_wires
    }

    send(self(), :find_wires)
    {:noreply, new_state}
  end

  def handle_info(:find_wires, %{instructions: [], recently_solved: [], known_wires: known_wires, client: client} = state) do
    GenServer.reply(client, known_wires)
    {:noreply, state}
  end

  def handle_info(:find_wires, %{instructions: instructions, known_wires: known_wires, recently_solved: recently_solved} = state) do
    {recently_solved, reduced_instructions, new_known_wires} = get_wires(instructions, recently_solved, known_wires)

    new_state = %State{
      state |
      instructions: reduced_instructions,
      recently_solved: recently_solved,
      known_wires: new_known_wires
    }

    send(self(), :find_wires)
    {:noreply, new_state}
  end

  #####################
  # Private Functions #
  #####################

  defp reject_signal_instructions_for(instructions, to_reject) do
    wires_to_reject = to_reject |> Enum.map(fn {wire, _} -> wire end)

    instructions
    |> Enum.reject(fn %{output: wire} ->  wire in wires_to_reject end)
  end

  defp get_signals(instructions) do
    signal_instructions = Gates.Finder.find(instructions, :signals)
    signals = signal_instructions |> Enum.map(&Gates.Processor.process(&1, []))

    {signals, instructions -- signal_instructions}
  end

  # recently_solved contain list of wires resolved in previous do_process execution.
  # The idea was to prevent do_process/3 from checking for instructions to solve always growing list of known_wires each time
  defp get_wires([], recently_solved, known_wires) do
    {[], [], recently_solved ++ known_wires}
  end
  defp get_wires(instructions, recently_solved, known_wires) do
    new_known_wires = recently_solved ++ known_wires

    instructions_to_solve =
      recently_solved
      |> Enum.map(fn {wire, _} -> wire end)
      |> Enum.map(&Gates.Finder.find(instructions, &1, new_known_wires))
      |> List.flatten
      |> Enum.uniq

    new_recently_solved =
      instructions_to_solve
      |> Enum.map(&Gates.Processor.process(&1, new_known_wires))

    reduced_instructions = instructions -- instructions_to_solve

    {new_recently_solved, reduced_instructions, new_known_wires}
  end
end
