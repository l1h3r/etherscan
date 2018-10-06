defmodule Etherscan.Mixfile do
  use Mix.Project

  def project do
    [
      app: :etherscan,
      version: "2.0.2",
      elixir: "~> 1.5",
      start_permanent: Mix.env() == :prod,
      description: description(),
      package: package(),
      aliases: aliases(),
      deps: deps(),
      name: "Etherscan",
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [coveralls: :test, "coveralls.detail": :test, "coveralls.html": :test]
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp description do
    """
    Etherscan.io API wrapper for Elixir. Provides access to ethereum blockchain data.
    """
  end

  defp package do
    [
      name: "etherscan",
      files: ["lib", "mix.exs", "README*", "LICENSE*"],
      maintainers: ["l1h3r"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/l1h3r/etherscan"}
    ]
  end

  defp deps do
    [
      # Core Dependecies
      {:jason, "~> 1.1"},
      {:httpoison, "~> 1.3"},
      # Test Dependecies
      {:exvcr, "~> 0.10.3", only: :test},
      {:excoveralls, "~> 0.10.1", only: :test},
      # Dev Dependecies
      {:ex_doc, "~> 0.19.1", only: :dev},
      {:dialyxir, "~> 1.0.0-rc.3", only: :dev, runtime: false},
      {:credo, "~> 0.10.2", only: :dev, runtime: false}
    ]
  end

  defp aliases do
    [
      watch: ["test --stale --listen-on-stdin"],
      lint: ["dialyzer", "credo"]
    ]
  end
end
