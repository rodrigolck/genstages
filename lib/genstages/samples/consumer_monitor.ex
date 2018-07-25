defmodule Genstages.Samples.ConsumerMonitor do
  use GenServer

  def start_link() do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def is_processing(message) do
    GenServer.call(__MODULE__, {:is_processing, message})
  end

  def register_message(message) do
    GenServer.call(__MODULE__, {:register_message, message, self()})
  end

  # SERVER

  def init(_) do
    {:ok, Map.new}
  end

  def handle_call({:is_processing, message}, _from, state) do
    {:reply, Map.values(state) |> Enum.member?(message), state}
  end

  def handle_call({:register_message, message, pid}, _from, state) do
    Process.monitor(pid)
    {:reply, true, Map.put(state, pid, message)}
  end

  def handle_info({:DOWN, _, :process, pid, :normal}, state),
    do: {:noreply, remove_pid(state, pid)}
  def handle_info({:DOWN, _, :process, pid, _}, state) do
    IO.puts "OMG! Message: #{inspect(Map.get(state, pid), charlists: :as_lists)} is with problems!"
    {:noreply, remove_pid(state, pid)}
  end

  def remove_pid(state, pid_to_remove) do
    Map.delete(state, pid_to_remove)
  end

end