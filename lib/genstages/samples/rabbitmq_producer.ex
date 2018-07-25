defmodule Genstages.Samples.RabbitMQProducer do
  use GenStage
  alias Genstages.RabbitMQ.Client

  def start_link() do
    GenStage.start_link(__MODULE__, 0, name: __MODULE__)
  end

  def init(counter) do
    {:producer, counter}
  end

  def handle_cast(:check_for_messages, 0) do
    {:noreply, [], 0}
  end

  def handle_cast(:check_for_messages, state) do
    message = Client.get()
    state = get_new_state(state, message)
    GenStage.cast(__MODULE__, :check_for_messages)
    {:noreply, [message], state}
  end

  def handle_demand(demand, state) do
    GenStage.cast(__MODULE__, :check_for_messages)
    {:noreply, [], demand+state}
  end

  defp get_new_state(state, nil), do: state
  defp get_new_state(state, _msg), do: state-1
end
