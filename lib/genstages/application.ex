defmodule Genstages.Application do
  use Application

  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec
    # Define workers and child supervisors to be supervised
    children = [
      # Start the endpoint when the application starts
      supervisor(GenstagesWeb.Endpoint, []),
      worker(Genstages.Samples.ConsumerMonitor, [])
      # Start your own worker by calling: Genstages.Worker.start_link(arg1, arg2, arg3)
      # worker(Genstages.Worker, [arg1, arg2, arg3]),
    ] ++ scenario_workers(Application.get_env(:genstages, :scenario))

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Genstages.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    GenstagesWeb.Endpoint.config_change(changed, removed)
    :ok
  end

  def scenario_workers("P-C") do
    import Supervisor.Spec
    [
      worker(Genstages.Samples.Producer, []),
      worker(Genstages.Samples.Consumer, [])
    ]
  end

  def scenario_workers("P-PC-C") do
    import Supervisor.Spec
    [
      worker(Genstages.Samples.Producer, []),
      worker(Genstages.Samples.ProducerConsumer, []),
      worker(Genstages.Samples.Consumer, [])
    ]
  end

  def scenario_workers("P-CS") do
    import Supervisor.Spec
    [
      worker(Genstages.Samples.Producer, []),
      worker(Genstages.Samples.ConsumerSupervisor, [])
    ]
  end

  def scenario_workers("B-C") do
    import Supervisor.Spec
    [
      worker(Genstages.Samples.Broadcaster, []),
      worker(Genstages.Samples.Consumer, [], id: 1),
      worker(Genstages.Samples.Consumer, [], id: 2),
      worker(Genstages.Samples.Consumer, [], id: 3),
      worker(Genstages.Samples.Consumer, [], id: 4),
      worker(Genstages.Samples.Consumer, [], id: 5)
    ]
  end

  def scenario_workers("RMQP-CS") do
    import Supervisor.Spec
    [
      supervisor(Genstages.RabbitMQ.Supervisor, []),
      worker(Genstages.Samples.RabbitMQProducer, []),
      worker(Genstages.Samples.ConsumerSupervisor, [])
    ]
  end

  def scenario_workers(_) do
    []
  end

end
