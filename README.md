# SpandexEcto

Tools for integrating Ecto with Spandex

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `spandex_ecto` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:spandex_ecto, "~> 0.1.0"}
  ]
end
```

Configuration

```
config :spandex_ecto, SpandexEcto.EctoLogger,
  service: :ecto, # Optional
  tracer: MyApp.Tracer, # Required
  otp_app: :my_app # Required - should line up with the otp app of the tracer

config :my_app, MyApp.Repo,
  loggers: [{Ecto.LogEntry, :log, [:info]}, {SpandexEcto.EctoLogger, :trace, ["database_name"]}]

```
