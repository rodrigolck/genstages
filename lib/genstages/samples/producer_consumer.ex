defmodule A do
  use GenStage

  def init(_) do
    {:producer, 0}
  end

  def handle_demand(demand, counter) when demand > 0 do
    # If the counter is 3 and we ask for 2 items, we will
    # emit the items 3 and 4, and set the state to 5.
    events = Enum.to_list(counter..counter+demand-100)
    IO.puts "Stage A: #{length(events)}"
    {:noreply, events, counter + demand}
  end
end

defmodule B do
  use GenStage

  def init(_) do
    {:producer_consumer, :ok}
  end

  def handle_events(events, _from, :ok) do
    IO.puts "Stage B: #{length(events)}"
    {:noreply, events, :ok}
  end
end

defmodule C do
  use GenStage

  def init(_) do
    {:consumer, :ok}
  end

  def handle_events(events, _from, :ok) do
    # Wait for a second.
    IO.puts "Start Stage C"

    :timer.sleep(10000)

    # Inspect the events.
    IO.puts "Stage C: #{length(events)}"

    # We are a consumer, so we would never emit items.
    {:noreply, [], :ok}
  end
end

{:ok, a} = GenStage.start_link(A, 0)   # starting from zero
{:ok, b} = GenStage.start_link(B, 2)   # expand by 2
{:ok, c} = GenStage.start_link(C, :ok) # state does not matter

GenStage.sync_subscribe(b, to: a)
GenStage.sync_subscribe(c, to: b)
Process.sleep(:infinity)