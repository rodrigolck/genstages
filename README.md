# Genstages

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](http://www.phoenixframework.org/docs/deployment).

## Important Points

  Instead of using

```elixir
{:ok, a} = GenStage.start_link(A, 0)   # starting from zero
{:ok, b} = GenStage.start_link(B, 2)   # expand by 2
{:ok, c} = GenStage.start_link(C, :ok) # state does not matter

GenStage.sync_subscribe(b, to: a)
GenStage.sync_subscribe(c, to: b)
```

  It is much wiser to create Workers into the application, so that in case one fails, it will imediately be recreated.


```elixir
for x <- 1..100 do
  Genstages.RabbitMQ.Client.publish(x)
end
```

