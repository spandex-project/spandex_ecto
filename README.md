# SpandexEcto

[![CircleCI](https://circleci.com/gh/spandex-project/spandex_ecto.svg?style=svg)](https://circleci.com/gh/spandex-project/spandex_ecto)
[![Inline docs](http://inch-ci.org/github/spandex-project/spandex_ecto.svg)](http://inch-ci.org/github/spandex-project/spandex_ecto)
[![Coverage Status](https://coveralls.io/repos/github/spandex-project/spandex_ecto/badge.svg)](https://coveralls.io/github/spandex-project/spandex_ecto)
[![Hex pm](http://img.shields.io/hexpm/v/spandex_ecto.svg?style=flat)](https://hex.pm/packages/spandex_ecto)
[![Ebert](https://ebertapp.io/github/spandex-project/spandex_ecto.svg)](https://ebertapp.io/github/spandex-project/spandex_ecto)

Tools for integrating Ecto with Spandex

## Installation

Add `spandex_ecto` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:spandex_ecto, "~> 0.2.1"}
  ]
end
```

Configuration

```elixir
config :spandex_ecto, SpandexEcto.EctoLogger,
  service: :ecto, # Optional
  tracer: MyApp.Tracer, # Required
  otp_app: :my_app # Required - should line up with the otp app of the tracer

# Be aware that this is a *compile* time configuration. As such, if you change this you
# may need to `mix compile --force` and/or `mix deps.compile --force ecto`
config :my_app, MyApp.Repo,
  loggers: [{Ecto.LogEntry, :log, [:info]}, {SpandexEcto.EctoLogger, :trace, ["database_name"]}]

```
