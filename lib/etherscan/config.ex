defmodule Etherscan.Config do
  @moduledoc """
  Config helpers for Etherscan
  """
  @app :etherscan

  # List of all available Ethereum test networks, and the special key `default`
  @testnets [
    :default,
    :kovan,
    :rinkeby,
    :ropsten
  ]

  @uri %URI{
    host: "api.etherscan.io",
    path: "/api",
    scheme: "https"
  }

  # Default options passed to HTTPoison
  @request_opts [
    timeout: 20_000,
    recv_timeout: 20_000
  ]

  @spec api_key :: binary
  def api_key do
    Application.get_env(@app, :api_key, "")
  end

  @spec api_url(query :: term) :: binary
  def api_url(query \\ []) do
    "#{endpoint()}?#{URI.encode_query(query)}"
  end

  @spec request_opts :: keyword
  def request_opts do
    Keyword.merge(@request_opts, env_request_ops())
  end

  @spec endpoint :: binary
  def endpoint do
    @app
    |> Application.get_env(:network)
    |> testnet_or_default()
    |> enhance_uri()
    |> URI.to_string()
  end

  @spec env_request_ops :: keyword
  defp env_request_ops do
    Application.get_env(@app, :request, [])
  end

  defp testnet_or_default(testnet) when testnet in @testnets, do: testnet
  defp testnet_or_default(_), do: :default

  defp enhance_uri(:default), do: @uri
  defp enhance_uri(testnet), do: %URI{@uri | host: "api-#{testnet}.etherscan.io"}
end
