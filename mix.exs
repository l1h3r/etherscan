defmodule Etherscan.Mixfile do
  use Mix.Project

  def project do
    [
      app: :etherscan,
      version: "0.1.3",
      elixir: "~> 1.5",
      start_permanent: Mix.env == :prod,
      description: description(),
      package: package(),
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
      {:poison, "~> 3.1.0"},
      {:httpoison, "~> 0.13.0"},
      {:exvcr, "~> 0.9.0", only: :test},
      {:ex_doc, "~> 0.17.1", only: :dev},
      {:excoveralls, "~> 0.7.0", only: :test},
      {:dialyxir, "~> 0.5.0", only: :dev, runtime: false}
    ]
  end
end
