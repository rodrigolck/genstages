defmodule Genstages.Samples.Producer do
  use GenStage

  def start_link(initial \\ 0) do
    GenStage.start_link(__MODULE__, initial, name: __MODULE__)
  end

  def init(counter) do
    {:producer, counter}
  end

  def handle_demand(demand, counter) when demand > 0 do
    # If the counter is 3 and we ask for 2 items, we will
    # emit the items 3 and 4, and set the state to 5.
    events = Enum.to_list(counter..counter+demand-1)
    IO.puts "Stage Producer Length: #{demand}"
    IO.puts "Stage Producer Values: #{inspect(events, charlists: :as_lists)}"
    {:noreply, events, counter + demand}
  end
end
