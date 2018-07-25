defmodule Genstages.Samples.ConsumerSupervisor do
  @moduledoc """
  A consumer will be a consumer supervisor that will
  spawn printer tasks for each event.
  """

  use ConsumerSupervisor

  def start_link() do
    ConsumerSupervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  # Callbacks

  def init(_) do
    children = [
      worker(Genstages.Samples.Consumer, [], restart: :temporary)
    ]

    {:ok, children, strategy: :one_for_one, subscribe_to: [{subscribes(), min_demand: 1, max_demand: 10}]}
  end

  defp subscribes() do
    case scenario() do
      "RMQP-CS" -> Genstages.Samples.RabbitMQProducer
      _ -> Genstages.Samples.Producer
    end
  end

  defp scenario(), do: Application.get_env(:genstages, :scenario)
end