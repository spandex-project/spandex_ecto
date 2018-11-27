# SpandexEcto

[![CircleCI](https://circleci.com/gh/spandex-project/spandex_ecto.svg?style=svg)](https://circleci.com/gh/spandex-project/spandex_ecto)
[![Inline docs](http://inch-ci.org/github/spandex-project/spandex_ecto.svg)](http://inch-ci.org/github/spandex-project/spandex_ecto)
[![Coverage Status](https://coveralls.io/repos/github/spandex-project/spandex_ecto/badge.svg)](https://coveralls.io/github/spandex-project/spandex_ecto)
[![Hex pm](http://img.shields.io/hexpm/v/spandex_ecto.svg?style=flat)](https://hex.pm/packages/spandex_ecto)
[![Ebert](https://ebertapp.io/github/spandex-project/spandex_ecto.svg)](https://ebertapp.io/github/spandex-project/spandex_ecto)

Tools for integrating Ecto with Spandex

## Limitations

Due to some recent changes in Ecto, we can no longer effectively trace the
execution of parallel preloads. All other queries work fine, but until we figure
something out that leverages either telemetry or until the task feature listed
[here](https://github.com/elixir-ecto/ecto/issues/2843) is added to the
language, we won't be able to support tracing parallel preloads.

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

config :my_app, MyApp.Repo,
  loggers: [{Ecto.LogEntry, :log, [:info]}, {SpandexEcto.EctoLogger, :trace, ["database_name"]}]

```
