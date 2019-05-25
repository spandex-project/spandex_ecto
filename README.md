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
    {:spandex_ecto, "~> 0.6.0"}
  ]
end
```

## Configuration

```elixir
config :spandex_ecto, SpandexEcto.EctoLogger,
  service: :ecto, # Optional
  tracer: MyApp.Tracer, # Required
```

### For Ecto 2

```elixir
# Be aware that this is a *compile* time configuration. As such, if you change this you
# may need to `mix compile --force` and/or `mix deps.compile --force ecto`
config :my_app, MyApp.Repo,
  loggers: [{Ecto.LogEntry, :log, [:info]}, {SpandexEcto.EctoLogger, :trace, ["database_name"]}]

```

### For Ecto 3

```elixir
# in application.ex
:telemetry.attach("spandex-query-tracer", [:my_app, :repo_name, :query], &SpandexEcto.TelemetryAdapter.handle_event/4, nil)
```

> NOTE: **If you are upgrading from Ecto 2**, make sure to **remove** the `loggers`
> entry from your configuration after adding the `:telemetry.attach`.

If your repo is not named like `MyApp.Repo`, you'll need to set `:telemetry_prefix` in your repo config:

```elixir
config :my_app, MyApp.Something.RepoName,
  telemetry_prefix: [:my_app, :repo_name]
```
