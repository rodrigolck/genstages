defmodule Genstages.RabbitMQ.Client do
  use GenServer

  def start_link() do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_) do
    {:ok, _channel} = Genstages.RabbitMQ.Connection.open_channel()
  end

  def get() do
    GenServer.call(__MODULE__, {:get})
  end

  def publish(event) do
    GenServer.cast(__MODULE__, {:publish, event})
  end

  def publish_retry(event) do
    GenServer.cast(__MODULE__, {:publish_retry, event})
  end

  def handle_cast({:publish, event}, channel) do
    AMQP.Basic.publish(channel, "genstages_exchange", "", Poison.encode!(event))
    {:noreply, channel}
  end

  def handle_cast({:publish_retry, event}, channel) do
    AMQP.Basic.publish(channel, "genstages_retry_exchange", "", Poison.encode!(event))
    {:noreply, channel}
  end

  def handle_call({:get}, _from, channel) do
    case AMQP.Basic.get(channel, "genstages_queue", no_ack: true) do
      {:ok, payload, _meta} -> {:reply, Poison.decode!(payload), channel}
      {:empty, _} -> {:reply, nil, channel}
    end
  end
end