defmodule Etherscan.API.Stats do
  @moduledoc """
  Module to wrap Etherscan stats endpoints.
  See: https://etherscan.io/apis#stats
  """

  alias Etherscan.Utils

  def get_eth_supply do
    "stats"
    |> Utils.api("ethsupply")
    |> Utils.parse()
    |> String.to_integer()
    |> Utils.format()
  end

  def get_eth_price do
    "stats"
    |> Utils.api("ethprice")
    |> Utils.parse()
    |> Utils.format()
  end

  def get_token_supply(token_address) when is_binary(token_address) do
    params = %{
      contractaddress: token_address
    }

    "stats"
    |> Utils.api("tokensupply", params)
    |> Utils.parse()
    |> String.to_integer()
    |> Utils.format()
  end
  def get_token_supply(_), do: {:error, :invalid_token_address}
end
