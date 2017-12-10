defmodule Etherscan.API.Stats do
  @moduledoc """
  Module to wrap Etherscan stats endpoints.

  [Etherscan API Documentation](https://etherscan.io/apis#stats)
  """

  alias Etherscan.{Factory, Utils}

  @doc """
  Get total supply of ether.

  Total supply is returned in wei.

  ## Example

      iex> Etherscan.API.Stats.get_eth_supply()
      {:ok, #{Factory.eth_supply()}}
  """
  @spec get_eth_supply :: {:ok, non_neg_integer()}
  def get_eth_supply do
    "stats"
    |> Utils.api("ethsupply")
    |> Utils.parse()
    |> String.to_integer()
    |> Utils.format()
  end

  @doc """
  Get ether price.

  ## Example

      iex> Etherscan.API.Stats.get_eth_price()
      {:ok, %{"ethbtc" => #{Factory.eth_btc_price()}, "ethusd" => #{Factory.eth_usd_price()}}}
  """
  @spec get_eth_price :: {:ok, map()}
  def get_eth_price do
    "stats"
    |> Utils.api("ethprice")
    |> Utils.parse()
    |> Utils.format()
  end

  @doc """
  Get total supply of ERC20 token, by `token_address`.

  [More Info](https://etherscan.io/apis#tokens)

  ## Example

      iex> Etherscan.API.Stats.get_token_supply("#{Factory.token_address()}")
      {:ok, #{Factory.token_supply()}}
  """
  @spec get_token_supply(token_address :: String.t()) :: {:ok, non_neg_integer()} | {:error, atom()}
  def get_token_supply(token_address) when is_binary(token_address) do
    params = %{
      contractaddress: token_address,
    }

    "stats"
    |> Utils.api("tokensupply", params)
    |> Utils.parse()
    |> String.to_integer()
    |> Utils.format()
  end
  def get_token_supply(_), do: {:error, :invalid_token_address}
end
