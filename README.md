# SpandexEcto

[![CircleCI](https://circleci.com/gh/spandex-project/spandex_ecto.svg?style=svg)](https://circleci.com/gh/spandex-project/spandex_ecto)
[![Hex pm](http://img.shields.io/hexpm/v/spandex_ecto.svg?style=flat)](https://hex.pm/packages/spandex_ecto)

Tools for integrating Ecto with Spandex.

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
    {:spandex_ecto, "~> 0.6.2"}
  ]
end
```

## Configuration

Configure `SpandexEcto` globally in your application config:

```elixir
# config/config.exs

config :spandex_ecto, SpandexEcto.EctoLogger,
  service: :ecto, # Optional
  tracer: MyApp.Tracer, # Required
```

Then attach it to your repository's telemetry events:

```elixir
# lib/my_app/application.ex

:ok = :telemetry.attach(
  "spandex-query-tracer",
  # this should match your repo's telemetry prefix
  [:my_app, :repo, :query],
  &SpandexEcto.TelemetryAdapter.handle_event/4,
  nil
)
```

You can override the global configuration by passing overrides to `:telemetry.attach/4` (useful for projects with multiple Ecto repos):

```elixir
# lib/my_app/application.ex

:ok = :telemetry.attach(
  "spandex-query-tracer-other-repo",
  [:my_app, :other_repo, :query],
  &SpandexEcto.TelemetryAdapter.handle_event/4,
  # this config will override the global config
  service: :other_db,
  tracer: MyApp.OtherRepoTracer
)
```

> NOTE: **If you are upgrading from Ecto 2**, make sure to **remove** the `loggers`
> entry from your configuration after adding `:telemetry.attach/4`.

### Options

The following configuration options are supported:

| Option     | Description                                              | Default |
| ---------- | -------------------------------------------------------- | ------- |
| `tracer`   | Tracer instance to use for reporting traces (_required_) |         |
| `service`  | Service name for Ecto traces                             | `ecto`  |
| `truncate` | Maximum length of a query (excess will be truncated)     | 5000    |

### Ecto 2

To integrate `SpandexEcto` with pre-`:telemetry` versions of Ecto you need to add `SpandexEcto.EctoLogger` as a logger to your repository.

Be aware that this is a _compile_ time configuration. As such, if you change this you may need to `mix compile --force` and/or `mix deps.compile --force ecto`.

```elixir
# config/config.exs

config :my_app, MyApp.Repo,
  loggers: [
    {Ecto.LogEntry, :log, [:info]},
    {SpandexEcto.EctoLogger, :trace, ["database_name"]}
  ]
```

## Customizing Span Resources

By default, SpandexEcto uses the query as name for the span's resource. In
order get a better feeling for the context of your spans, you can label your
span's resources using the option [`:telemetry_options`](https://hexdocs.pm/ecto/Ecto.Repo.html#module-shared-options)
of almost all of `Ecto.Repo`'s repository functions.

### Examples

```elixir
Repo.all(query, telemetry_options: [spandex_resource: "users-with-addresses"])
Repo.get!(User, id, telemetry_options: [spandex_resource: "get-user"])
```
