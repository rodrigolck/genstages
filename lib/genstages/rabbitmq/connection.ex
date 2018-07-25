defmodule Genstages.RabbitMQ.Connection do
  use GenServer
  
  def start_link() do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_) do
    {:ok, connect()}
  end

  def open_channel() do
    GenServer.call(__MODULE__, :open_channel)
  end

  defp connect do
    case AMQP.Connection.open(Application.get_env(:amqp, :url)) do
      {:ok, conn} ->
        Process.monitor(conn.pid) # Get notifications when the connection goes down
        {:ok, chan} = AMQP.Channel.open(conn)
        AMQP.Queue.declare chan, "genstages_queue"
        AMQP.Exchange.declare chan, "genstages_exchange"
        AMQP.Queue.bind chan, "genstages_queue", "genstages_exchange"
        conn
      {:error, _} ->
        :timer.sleep(2_000)
        connect()
    end
  end

  def handle_call(:open_channel, _from, conn) do
    {:reply, AMQP.Channel.open(conn), conn}
  end

  # Implement a callback to handle DOWN notifications from the system
  # This callback should try to reconnect to the server
  def handle_info({:DOWN, _, :process, _pid, _reason}, _) do
    {:noreply, connect()}
  end
end