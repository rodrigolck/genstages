defmodule Genstages.RabbitMQ.Supervisor do
  use Supervisor

  def start_link() do
    Supervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_) do
    children = [
      worker(Genstages.RabbitMQ.Connection, []),
      worker(Genstages.RabbitMQ.Client, [])
    ]
    supervise(children, strategy: :rest_for_one)
  end
end