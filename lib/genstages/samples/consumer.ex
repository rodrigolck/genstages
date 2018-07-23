defmodule Genstages.Samples.Consumer do
  use GenStage

  def start_link(initial \\ :ok) do
    GenStage.start_link(__MODULE__, initial, name: __MODULE__)
  end

  def init(_) do
    {:consumer, :ok, subscribe_to: subscribes()}
  end

  def handle_events(events, _from, :ok) do
    # Wait for a second.
    IO.puts "Start Stage Consumer"

    :timer.sleep(10000)

    # Inspect the events.
    IO.puts "Stage Consumer: #{length(events)}"

    # We are a consumer, so we would never emit items.
    {:noreply, [], :ok}
  end

  defp subscribes() do
    case scenario() do
      "P-C" -> [Genstages.Samples.Producer]
      _ -> [Genstages.Samples.ProducerConsumer]
    end
  end

  defp scenario(), do: Application.get_env(:genstages, :scenario)

end