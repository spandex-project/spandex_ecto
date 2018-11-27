# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

config :git_ops,
  mix_project: SpandexEcto.MixProject,
  changelog_file: "CHANGELOG.md",
  repository_url: "https://github.com/spandex-project/spandex_ecto",
  types: [],
  # Instructs the tool to manage your mix version in your `mix.exs` file
  # See below for more information
  manage_mix_version?: true,
  # Instructs the tool to manage the version in your README.md
  # Pass in `true` to use `"README.md"` or a string to customize
  manage_readme_version: "README.md",
  version_prefix: "v"

# This configuration is loaded before any dependency and is restricted
# to this project. If another project depends on this project, this
# file won't be loaded nor affect the parent project. For this reason,
# if you want to provide default values for your application for
# 3rd-party users, it should be done in your "mix.exs" file.

# You can configure your application as:
#
#     config :spandex_ecto, key: :value
#
# and access this configuration in your application as:
#
#     Application.get_env(:spandex_ecto, :key)
#
# You can also configure a 3rd-party app:
#
#     config :logger, level: :info
#

# It is also possible to import configuration files, relative to this
# directory. For example, you can emulate configuration per environment
# by uncommenting the line below and defining dev.exs, test.exs and such.
# Configuration from the imported file will override the ones defined
# here (which is why it is important to import them last).
#
#     import_config "#{Mix.env()}.exs"
