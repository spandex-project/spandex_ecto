defmodule SpandexEcto.MixProject do
  use Mix.Project

  @source_url "https://github.com/spandex-project/spandex_ecto"
  @version "0.7.0"

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
      maintainers: ["Greg Mefford"],
      licenses: ["MIT"],
      links: %{
        "Changelog" => "https://hexdocs.pm/spandex_ecto/changelog.html",
        "GitHub" => @source_url,
        "Sponsor" => "https://github.com/sponsors/GregMefford"
      }
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
      {:spandex, "~> 2.2 or ~> 3.0"}
    ]
  end
end
