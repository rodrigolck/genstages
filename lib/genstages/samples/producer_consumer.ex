defmodule Genstages.Samples.ProducerConsumer do
  use GenStage

  def start_link(initial \\ :ok) do
    GenStage.start_link(__MODULE__, initial, name: __MODULE__)
  end

  def init(_) do
    {:producer_consumer, :ok, subscribe_to: [{Genstages.Samples.Producer, max_demand: 10, min_demand: 1}]}
  end

  def handle_events(events, _from, :ok) do
    IO.puts "Stage ProducerConsumer: #{length(events)}"
    {:noreply, events, :ok}
  end
end
