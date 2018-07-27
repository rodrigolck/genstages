# Genstages

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Change the scenarios in `config.exs` to:
    * "P-C" -> Producer - Consumer
    * "P-PC-C" -> Producer - ProducerConsumer - Consumer
    * "P-CS" -> Producer - ConsumerSupervisor
    * "RMQP-CS" -> RabbitMQProducer - ConsumerSupervisor
    * "B-C" -> Broadcast - Consumer
  * Execute the project: `iex -S mix`

It is also necessary to create a RabbitMQ Docker container, which can be acomplished by:

```bash
# To install docker
sudo apt-get remove docker docker-engine docker.io -y
sudo apt-get install docker-ce -y
# Add current user to docker, so that the sudo commands is no longer necessary
sudo groupadd docker
sudo usermod -aG docker $USER
# Enable docker to be always up in the initialization of the system
sudo systemctl enable docker
# Install RabbitMQ container
sudo docker run -d --name rabbitmq -p 5672:5672 -p 15672:15672 -p 25672:25672 -p 35197:35197  -e "RABBITMQ_USE_LONGNAME=true" rabbitmq:3.6.14-management
```

## Important Points

Instead of using:

```elixir
{:ok, a} = GenStage.start_link(A, 0)   # starting from zero
{:ok, b} = GenStage.start_link(B, 2)   # expand by 2
{:ok, c} = GenStage.start_link(C, :ok) # state does not matter

GenStage.sync_subscribe(b, to: a)
GenStage.sync_subscribe(c, to: b)
```

It is much wiser to create Workers into the application, so that in case it fails, it will imediately be respawned.

In case you need to populate your RabbitMq with messages, here is a quick way:

```elixir
for x <- 1..100 do
  Genstages.RabbitMQ.Client.publish(x)
end
```

You will be able to check the current message which is beign consumed by th Consumer with the following command:

```elixir
Genstages.Samples.ConsumerMonitor.is_processing(1)
```

The link to the presentation is in: https://pt.slideshare.net/RodrigoLongChenKashi/elixir-meetup-15-monitorando-genstages