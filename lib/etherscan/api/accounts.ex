defmodule Etherscan.API.Accounts do
  @moduledoc """
  Module to wrap Etherscan account endpoints.
  See: https://etherscan.io/apis#accounts
  """

  alias Etherscan.Utils

  @account_transaction_default_params %{
    startblock: 0,
    endblock: nil,
    sort: "asc",
    page: 1,
    offset: 20
  }

  @blocks_mined_default_params %{
    page: 1,
    offset: 20
  }

  def get_balance(address) when is_binary(address) do
    params = %{
      tag: "latest",
      address: address
    }

    "account"
    |> Utils.api("balance", params)
    |> Utils.parse()
    |> String.to_integer()
    |> Utils.format()
  end
  def get_balance(_), do: {:error, :invalid_address}

  def get_balances([head | _] = addresses) when
    is_list(addresses) and
    is_binary(head) and
    length(addresses) <= 20
  do
    params = %{
      tag: "latest",
      address: Enum.join(addresses, ",")
    }

    "account"
    |> Utils.api("balancemulti", params)
    |> Utils.parse()
    |> Enum.map(fn account ->
      Map.update(account, "balance", 0, &String.to_integer/1)
    end)
    |> Utils.format()
  end
  def get_balances(_), do: {:error, :invalid_addresses}

  def get_transactions(address, params \\ %{})
  def get_transactions(address, params) when is_binary(address) do
    params =
      @account_transaction_default_params
      |> Map.merge(params)
      |> Map.take(@account_transaction_default_params |> Map.keys())
      |> Map.put(:address, address)

    "account"
    |> Utils.api("txlist", params)
    |> Utils.parse(as: %{"result" => [%Etherscan.Block{}]})
    |> Utils.format()
  end
  def get_transactions(_, _), do: {:error, :invalid_address}

  def get_internal_transactions(address, params \\ %{})
  def get_internal_transactions(address, params) when is_binary(address) do
    params =
      @account_transaction_default_params
      |> Map.merge(params)
      |> Map.take(@account_transaction_default_params |> Map.keys())
      |> Map.put(:address, address)

    "account"
    |> Utils.api("txlistinternal", params)
    |> Utils.parse(as: %{"result" => [%Etherscan.Block{}]})
    |> Utils.format()
  end
  def get_internal_transactions(_, _), do: {:error, :invalid_address}

  def get_internal_transactions_by_hash(transaction_hash) when is_binary(transaction_hash) do
    params = %{
      txhash: transaction_hash
    }

    "account"
    |> Utils.api("txlistinternal", params)
    |> Utils.parse(as: %{"result" => [%Etherscan.Block{}]})
    |> Utils.format()
  end
  def get_internal_transactions_by_hash(_), do: {:error, :invalid_transaction_hash}

  def get_blocks_mined(address, params \\ %{})
  def get_blocks_mined(address, params) when is_binary(address) do
    params =
      @blocks_mined_default_params
      |> Map.merge(params)
      |> Map.take(@blocks_mined_default_params |> Map.keys())
      |> Map.put(:blocktype, "blocks")
      |> Map.put(:address, address)

    "account"
    |> Utils.api("getminedblocks", params)
    |> Utils.parse(as: %{"result" => [%Etherscan.MinedBlock{}]})
    |> Utils.format()
  end
  def get_blocks_mined(_, _), do: {:error, :invalid_address}

  def get_uncles_mined(address, params \\ %{})
  def get_uncles_mined(address, params) when is_binary(address) do
    params =
      @blocks_mined_default_params
      |> Map.merge(params)
      |> Map.take(@blocks_mined_default_params |> Map.keys())
      |> Map.put(:blocktype, "uncles")
      |> Map.put(:address, address)

    "account"
    |> Utils.api("getminedblocks", params)
    |> Utils.parse(as: %{"result" => [%Etherscan.MinedUncle{}]})
    |> Utils.format()
  end
  def get_uncles_mined(_, _), do: {:error, :invalid_address}

  def get_token_balance(address, token_address) when is_binary(address) and is_binary(token_address) do
    params = %{
      tag: "latest",
      address: address,
      contractaddress: token_address
    }

    "account"
    |> Utils.api("tokenbalance", params)
    |> Utils.parse()
    |> String.to_integer()
    |> Utils.format()
  end
  def get_token_balance(address, token_address) when not is_binary(address) and is_binary(token_address), do: {:error, :invalid_address}
  def get_token_balance(address, token_address) when not is_binary(token_address) and is_binary(address), do: {:error, :invalid_token_address}
  def get_token_balance(_, _), do: {:error, :invalid_address_and_token_address}
end
