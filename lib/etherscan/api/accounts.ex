defmodule Etherscan.API.Accounts do
  @moduledoc """
  Module to wrap Etherscan account endpoints.

  [Etherscan API Documentation](https://etherscan.io/apis#accounts)
  """

  alias Etherscan.{Block, Factory, MinedBlock, MinedUncle, Utils}

  @account_transaction_default_params %{
    startblock: 0,
    endblock: nil,
    sort: "asc",
    page: 1,
    offset: 20,
  }

  @blocks_mined_default_params %{
    page: 1,
    offset: 20,
  }

  @doc """
  Get ether balance for a single `address`.

  Balance is returned in wei.

  ## Example

      iex> Etherscan.API.Accounts.get_balance("#{Factory.address1()}")
      {:ok, #{Factory.address1_balance()}}
  """
  @spec get_balance(address :: String.t()) :: {:ok, non_neg_integer()} | {:error, atom()}
  def get_balance(address) when is_binary(address) do
    params = %{
      tag: "latest",
      address: address,
    }

    "account"
    |> Utils.api("balance", params)
    |> Utils.parse()
    |> String.to_integer()
    |> Utils.format()
  end
  def get_balance(_), do: {:error, :invalid_address}

  @doc """
  Get ether balance for a list of multiple `addresses`, up to a maximum of 20.

  Balances are returned in wei.

  ## Example

      iex> addresses = [
        "#{Factory.address1()}",
        "#{Factory.address2()}",
      ]
      iex> Etherscan.API.Accounts.get_balances(addresses)
      {:ok, [#{Factory.address1_balance()}, #{Factory.address2_balance()}]}
  """
  @spec get_balances(addresses :: list(String.t())) :: {:ok, map()} | {:error, atom()}
  def get_balances([head | _] = addresses) when
    is_list(addresses) and
    is_binary(head) and
    length(addresses) <= 20
  do
    params = %{
      tag: "latest",
      address: Enum.join(addresses, ","),
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

  @doc """
  Get a list of 'Normal' transactions by `address`.

  Returns up to a maximum of the last 10,000 transactions only.

  ## Example

      iex> params = %{
        page: 1, # Page number
        offset: 10, # Max records returned
        sort: "asc", # Sort returned records
        startblock: 0, # Start block number
        endblock: 99999999, # End block number
      }
      iex> Etherscan.API.Accounts.get_transactions("#{Factory.address1()}", params)
      {:ok, [%Etherscan.Block{}]}
  """
  @spec get_transactions(address :: String.t(), params :: map()) :: {:ok, list(Block.t())} | {:error, atom()}
  def get_transactions(address, params \\ %{})
  def get_transactions(address, params) when is_binary(address) do
    params =
      @account_transaction_default_params
      |> Map.merge(params)
      |> Map.take(@account_transaction_default_params |> Map.keys())
      |> Map.put(:address, address)

    "account"
    |> Utils.api("txlist", params)
    |> Utils.parse(as: %{"result" => [%Block{}]})
    |> Utils.format()
  end
  def get_transactions(_, _), do: {:error, :invalid_address}

  @doc """
  Get a list of 'Internal' transactions by `address`.

  Returns up to a maximum of the last 10,000 transactions only.

  ## Example

      iex> params = %{
        page: 1, # Page number
        offset: 10, # Max records returned
        sort: "asc", # Sort returned records
        startblock: 0, # Start block number
        endblock: 99999999, # End block number
      }
      iex> Etherscan.API.Accounts.get_internal_transactions("#{Factory.address1()}", params)
      {:ok, [%Etherscan.Block{}]}
  """
  @spec get_internal_transactions(address :: String.t(), params :: map()) :: {:ok, list(Block.t())} | {:error, atom()}
  def get_internal_transactions(address, params \\ %{})
  def get_internal_transactions(address, params) when is_binary(address) do
    params =
      @account_transaction_default_params
      |> Map.merge(params)
      |> Map.take(@account_transaction_default_params |> Map.keys())
      |> Map.put(:address, address)

    "account"
    |> Utils.api("txlistinternal", params)
    |> Utils.parse(as: %{"result" => [%Block{}]})
    |> Utils.format()
  end
  def get_internal_transactions(_, _), do: {:error, :invalid_address}

  @doc """
  Get a list of 'Internal Transactions' by `transaction_hash`.

  Returns up to a maximum of the last 10,000 transactions only.

  ## Example

      iex> Etherscan.API.Accounts.get_internal_transactions_by_hash("#{Factory.transaction_hash()}")
      {:ok, [%Etherscan.Block{}]}
  """
  @spec get_internal_transactions_by_hash(transaction_hash :: String.t()) :: {:ok, list(Block.t())} | {:error, atom()}
  def get_internal_transactions_by_hash(transaction_hash) when is_binary(transaction_hash) do
    params = %{
      txhash: transaction_hash,
    }

    "account"
    |> Utils.api("txlistinternal", params)
    |> Utils.parse(as: %{"result" => [%Block{}]})
    |> Utils.format()
  end
  def get_internal_transactions_by_hash(_), do: {:error, :invalid_transaction_hash}

  @doc """
  Get a list of blocks mined by `address`.

  ## Example

      iex> params = %{
        page: 1, # Page number
        offset: 10, # Max records returned
      }
      iex> Etherscan.API.Accounts.get_blocks_mined("#{Factory.miner_address()}", params)
      {:ok, [%Etherscan.MinedBlock{}]}
  """
  @spec get_blocks_mined(address :: String.t(), params :: map()) :: {:ok, list(Block.t())} | {:error, atom()}
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
    |> Utils.parse(as: %{"result" => [%MinedBlock{}]})
    |> Utils.format()
  end
  def get_blocks_mined(_, _), do: {:error, :invalid_address}

  @doc """
  Get a list of uncles mined by `address`.

  ## Example

      iex> params = %{
        page: 1, # Page number
        offset: 10, # Max records returned
      }
      iex> Etherscan.API.Accounts.get_uncles_mined("#{Factory.miner_address()}", params)
      {:ok, [%Etherscan.MinedUncle{}]}
  """
  @spec get_uncles_mined(address :: String.t(), params :: map()) :: {:ok, list(Block.t())} | {:error, atom()}
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
    |> Utils.parse(as: %{"result" => [%MinedUncle{}]})
    |> Utils.format()
  end
  def get_uncles_mined(_, _), do: {:error, :invalid_address}

  @doc """
  Get the ERC20 token balance of the `address` for token at `token_address`.

  [More Info](https://etherscan.io/apis#tokens)

  ## Example

      iex> address = "#{Factory.token_owner_address()}"
      iex> token_address = "#{Factory.token_address()}"
      iex> Etherscan.API.Accounts.get_token_balance(address, token_address)
      {:ok, #{Factory.token_address_balance()}}
  """
  @spec get_token_balance(address :: String.t(), token_address :: String.t()) :: {:ok, non_neg_integer()} | {:error, atom()}
  def get_token_balance(address, token_address) when is_binary(address) and is_binary(token_address) do
    params = %{
      tag: "latest",
      address: address,
      contractaddress: token_address,
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
