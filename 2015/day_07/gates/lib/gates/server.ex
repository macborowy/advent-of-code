defmodule Gates.Server do
  use GenServer

  defmodule State do
    defstruct instructions: nil, known_wires: nil, recently_solved: nil, client: nil
  end

  ##############
  # Client API #
  ##############

  def start_link(file_path), do: GenServer.start_link(__MODULE__, file_path)

  def process(pid), do: GenServer.call(pid, :process)

  #############
  # Callbacks #
  #############

  def init(file_path) do
    instructions = file_path |> Gates.Parser.get_instructions
    {:ok, %State{instructions: instructions}}
  end

  def handle_call(:process, from, state) do
    send(self(), :find_signals)
    {:noreply, %State{state | client: from}}
  end

  def handle_info(:find_signals, %{instructions: instructions} = state) do
    signal_instructions = Gates.Finder.find(instructions, :signals)
    signals = signal_instructions |> Enum.map(&Gates.Processor.process(&1, []))

    new_state = %State{
      state |
      instructions: instructions |> remove_solved(signal_instructions),
      recently_solved: signals,
      known_wires: []
    }

    send(self(), :find_wires)
    {:noreply, new_state}
  end

  def handle_info(:find_wires, %{instructions: [], known_wires: known_wires, recently_solved: recently_solved, client: client} = state) do
    reply = recently_solved ++ known_wires

    GenServer.reply(client, reply)
    {:noreply, %State{state | recently_solved: [], known_wires: reply}}
  end

  def handle_info(:find_wires, %{instructions: instructions, known_wires: known_wires, recently_solved: recently_solved} = state) do
    {recently_solved, new_instructions, new_known_wires} = do_process(instructions, recently_solved, known_wires)

    new_state = %State{
      state |
      instructions: new_instructions,
      recently_solved: recently_solved,
      known_wires: new_known_wires
    }

    send(self(), :find_wires)
    {:noreply, new_state}
  end

  #####################
  # Private Functions #
  #####################

  defp remove_solved(instructions, solved) do
    instructions -- solved
  end

  # recently_solved contain list of wires resolved in previous do_process execution
  # the idea was to prevent do_process/3 from checking always growing list of known_wires each time
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

    {new_wires, instructions, known_wires}
  end
end
