defmodule SpandexEcto.MixProject do
  use Mix.Project

  @version "0.6.0"

  def project do
    [
      app: :spandex_ecto,
      description: description(),
      docs: docs(),
      version: @version,
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        "coveralls.circle": :test,
        coveralls: :test
      ],
      deps: deps(),
      package: package()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp package do
    [
      name: :spandex_ecto,
      maintainers: ["Zachary Daniel", "Greg Mefford"],
      licenses: ["MIT License"],
      links: %{"GitHub" => "https://github.com/spandex-project/spandex_ecto"}
    ]
  end

  defp description() do
    """
    Tools for integrating Ecto with Spandex.
    """
  end

  defp docs do
    [
      main: "readme",
      extras: [
        "README.md"
      ]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_doc, ">= 0.0.0", only: :dev},
      {:excoveralls, "~> 0.10", only: :test},
      {:git_ops, "~> 0.5", only: :dev},
      {:inch_ex, github: "rrrene/inch_ex", only: [:dev, :test]},
      {:spandex, "~> 2.2"}
    ]
  end
end
