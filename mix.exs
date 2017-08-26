defmodule Etherscan.Mixfile do
  use Mix.Project

  def project do
    [
      app: :etherscan,
      version: "0.1.0",
      elixir: "~> 1.5",
      start_permanent: Mix.env == :prod,
      description: description(),
      package: package(),
      deps: deps(),
      name: "Etherscan"
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp description do
    """
    An unofficial API wrapper for etherscan.io - WIP
    """
  end

  defp package do
    [
      name: "etherscan",
      files: ["lib", "mix.exs", "README*", "LICENSE*"],
      maintainers: ["l1h3r"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/L1h3r/etherscan"}
    ]
  end

  defp deps do
    [
      {:poison, "~> 3.1.0"},
      {:httpoison, "~> 0.13.0"},
      {:ex_doc, ">= 0.16.3", only: :dev}
    ]
  end
end
