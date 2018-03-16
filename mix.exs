defmodule Etherscan.Mixfile do
  use Mix.Project

  def project do
    [
      app: :etherscan,
      version: "0.1.5",
      elixir: "~> 1.5",
      start_permanent: Mix.env == :prod,
      description: description(),
      package: package(),
      aliases: aliases(),
      deps: deps(),
      name: "Etherscan",
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: ["coveralls": :test, "coveralls.detail": :test, "coveralls.html": :test]
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
      {:poison, "~> 3.1"},
      {:httpoison, "~> 1.0"},
      {:exvcr, "~> 0.9", only: :test},
      {:ex_doc, "~> 0.18", only: :dev},
      {:excoveralls, "~> 0.7", only: :test},
      {:dialyxir, "~> 0.5", only: :dev, runtime: false},
      {:credo, "~> 0.8", only: [:dev, :test], runtime: false},
    ]
  end

  defp aliases do
    [
      "watch": ["test --stale --listen-on-stdin"],
      "lint": ["dialyzer", "credo"],
    ]
  end
end
