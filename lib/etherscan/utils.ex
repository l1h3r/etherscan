defmodule Etherscan.Utils do
  @moduledoc """
  A module of utility functions for Etherscan.
  """

  @networks [:default, :ropsten, :kovan, :rinkeby]

  @network_urls [
    default: "https://api.etherscan.io/api",
    ropsten: "https://ropsten.etherscan.io/api",
    kovan:   "https://kovan.etherscan.io/api",
    rinkeby: "https://rinkeby.etherscan.io/api",
  ]

  @spec api(module :: String.t(), action :: String.t(), params :: map()) :: String.t()
  def api(module, action, params \\ %{}) do
    module
    |> build_query(action, params)
    |> build_path()
    |> HTTPoison.get!([], [timeout: 20_000, recv_timeout: 20_000])
    |> Map.get(:body)
  end

  @spec parse(response :: any(), opts :: Keyword.t()) :: any()
  def parse(response, opts \\ []) do
    response
    |> Poison.decode!(opts)
    |> extract_response()
  end

  @spec format(response :: any()) :: {:ok, any()}
  def format(response) do
    {:ok, response}
  end

  @spec network_url :: String.t()
  def network_url do
    Keyword.get(@network_urls, get_network())
  end

  @spec extract_response(response :: map()) :: any()
  defp extract_response(%{"error" => error}), do: error
  defp extract_response(%{"result" => result}), do: result
  defp extract_response(response), do: response

  @spec build_path(query :: String.t()) :: String.t()
  defp build_path(query), do: network_url() <> "?" <> query

  @spec build_query(module :: String.t(), action :: String.t(), params :: map()) :: String.t()
  defp build_query(module, action, params) do
    params
    |> Map.put(:action, action)
    |> Map.put(:module, module)
    |> Map.put(:apikey, api_key())
    |> URI.encode_query()
  end

  @spec api_key :: String.t()
  defp api_key do
    Application.get_env(:etherscan, :api_key, "")
  end

  @spec get_network :: atom()
  defp get_network do
    case Application.get_env(:etherscan, :network) do
      network when network in @networks ->
        network
      _ ->
        :default
    end
  end
end
