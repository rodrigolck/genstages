defmodule Genstages.Samples.Consumer do
  use GenStage

  def start_link(event) do
    Task.start_link(__MODULE__, :handle_events, [[event], :from, :ok])
  end

  def start_link() do
    GenStage.start_link(__MODULE__, :ok)
  end

  def init(_) do
    {:consumer, :ok, subscribe_to: subscribes()}
  end

  def handle_events(events, _from, :ok) do
    # Genstages.Samples.ConsumerMonitor.register_message(events)
    # Wait for a second.
    IO.puts "Start Stage Consumer"

    :timer.sleep(5000)

    # if Enum.member?(events, 21), do: 1 = 1 + 1

    # Inspect the events.
    IO.puts "Stage Consumer Length: #{length(events)}"
    IO.puts "Stage Consumer Value: #{inspect(events, charlists: :as_lists)}"

    # We are a consumer, so we would never emit items.
    {:noreply, [], :ok}
  end

  defp subscribes() do
    case scenario() do
      "P-C" -> [{Genstages.Samples.Producer, max_demand: 10, min_demand: 1 }]
      "B-C" -> [{Genstages.Samples.Broadcaster, selector: fn key -> String.starts_with?(key, "iex-") end}]
      _ -> [Genstages.Samples.ProducerConsumer]
    end
  end

  defp scenario(), do: Application.get_env(:genstages, :scenario)

end
