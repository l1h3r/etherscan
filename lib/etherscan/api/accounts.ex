defmodule Etherscan.API.Accounts do
  @moduledoc """
  Module to wrap Etherscan account endpoints.

  [Etherscan API Documentation](https://etherscan.io/apis#accounts)
  """

  use Etherscan.API
  use Etherscan.Constants
  alias Etherscan.{MinedBlock, MinedUncle, Transaction, InternalTransaction}

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

  ## Example

      iex> Etherscan.get_balance("#{@test_address1}")
      {:ok, #{@test_address1_balance}}
  """
  @spec get_balance(address :: String.t()) :: {:ok, non_neg_integer()} | {:error, atom()}
  def get_balance(address) when is_address(address) do
    "account"
    |> get("balance", %{address: address, tag: "latest"})
    |> parse()
    |> format_balance()
    |> wrap(:ok)
  end
  def get_balance(_), do: @error_invalid_address

  @doc """
  Get ether balance for a list of multiple `addresses`, up to a maximum of 20.

  ## Example

      iex> addresses = [
        "#{@test_address1}",
        "#{@test_address2}",
      ]
      iex> Etherscan.get_balances(addresses)
      {:ok, [#{@test_address1_balance}, #{@test_address2_balance}]}
  """
  @spec get_balances(addresses :: list(String.t())) :: {:ok, map()} | {:error, atom()}
  def get_balances([head | _] = addresses) when
    is_list(addresses) and
    is_address(head) and
    length(addresses) <= 20
  do
    "account"
    |> get("balancemulti", %{address: Enum.join(addresses, ","), tag: "latest"})
    |> parse()
    |> Enum.map(fn account ->
      Map.update(account, "balance", 0, &format_balance/1)
    end)
    |> wrap(:ok)
  end
  def get_balances(_), do: @error_invalid_addresses

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
      iex> Etherscan.get_transactions("#{@test_address1}", params)
      {:ok, [%Etherscan.Transaction{}]}
  """
  @spec get_transactions(address :: String.t(), params :: map()) :: {:ok, list(Transaction.t())} | {:error, atom()}
  def get_transactions(address, params \\ %{})
  def get_transactions(address, params) when is_address(address) do
    params =
      params
      |> merge_params(@account_transaction_default_params)
      |> Map.put(:address, address)

    "account"
    |> get("txlist", params)
    |> parse(as: %{"result" => [%Transaction{}]})
    |> wrap(:ok)
  end
  def get_transactions(_, _), do: @error_invalid_address

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
      iex> Etherscan.get_internal_transactions("#{@test_address1}", params)
      {:ok, [%Etherscan.InternalTransaction{}]}
  """
  @spec get_internal_transactions(address :: String.t(), params :: map()) :: {:ok, list(InternalTransaction.t())} | {:error, atom()}
  def get_internal_transactions(address, params \\ %{})
  def get_internal_transactions(address, params) when is_address(address) do
    params =
      params
      |> merge_params(@account_transaction_default_params)
      |> Map.put(:address, address)

    "account"
    |> get("txlistinternal", params)
    |> parse(as: %{"result" => [%InternalTransaction{}]})
    |> wrap(:ok)
  end
  def get_internal_transactions(_, _), do: @error_invalid_address

  @doc """
  Get a list of 'Internal Transactions' by `transaction_hash`.

  Returns up to a maximum of the last 10,000 transactions only.

  ## Example

      iex> Etherscan.get_internal_transactions_by_hash("#{@test_transaction_hash}")
      {:ok, [%Etherscan.InternalTransaction{}]}
  """
  @spec get_internal_transactions_by_hash(transaction_hash :: String.t()) :: {:ok, list(InternalTransaction.t())} | {:error, atom()}
  def get_internal_transactions_by_hash(transaction_hash) when is_address(transaction_hash) do
    "account"
    |> get("txlistinternal", %{txhash: transaction_hash})
    |> parse(as: %{"result" => [%InternalTransaction{hash: transaction_hash}]})
    |> wrap(:ok)
  end
  def get_internal_transactions_by_hash(_), do: @error_invalid_transaction_hash

  @doc """
  Get a list of blocks mined by `address`.

  ## Example

      iex> params = %{
        page: 1, # Page number
        offset: 10, # Max records returned
      }
      iex> Etherscan.get_blocks_mined("#{@test_miner_address}", params)
      {:ok, [%Etherscan.MinedBlock{}]}
  """
  @spec get_blocks_mined(address :: String.t(), params :: map()) :: {:ok, list(MinedBlock.t())} | {:error, atom()}
  def get_blocks_mined(address, params \\ %{})
  def get_blocks_mined(address, params) when is_address(address) do
    params =
      params
      |> merge_params(@blocks_mined_default_params)
      |> Map.put(:blocktype, "blocks")
      |> Map.put(:address, address)

    "account"
    |> get("getminedblocks", params)
    |> parse(as: %{"result" => [%MinedBlock{}]})
    |> wrap(:ok)
  end
  def get_blocks_mined(_, _), do: @error_invalid_address

  @doc """
  Get a list of uncles mined by `address`.

  ## Example

      iex> params = %{
        page: 1, # Page number
        offset: 10, # Max records returned
      }
      iex> Etherscan.get_uncles_mined("#{@test_miner_address}", params)
      {:ok, [%Etherscan.MinedUncle{}]}
  """
  @spec get_uncles_mined(address :: String.t(), params :: map()) :: {:ok, list(MinedUncle.t())} | {:error, atom()}
  def get_uncles_mined(address, params \\ %{})
  def get_uncles_mined(address, params) when is_address(address) do
    params =
      params
      |> merge_params(@blocks_mined_default_params)
      |> Map.put(:blocktype, "uncles")
      |> Map.put(:address, address)

    "account"
    |> get("getminedblocks", params)
    |> parse(as: %{"result" => [%MinedUncle{}]})
    |> wrap(:ok)
  end
  def get_uncles_mined(_, _), do: @error_invalid_address

  @doc """
  Get the ERC20 token balance of the `address` for token at `token_address`.

  [More Info](https://etherscan.io/apis#tokens)

  ## Example

      iex> address = "#{@test_token_owner_address}"
      iex> token_address = "#{@test_token_address}"
      iex> Etherscan.get_token_balance(address, token_address)
      {:ok, #{@test_token_address_balance}}
  """
  @spec get_token_balance(address :: String.t(), token_address :: String.t()) :: {:ok, non_neg_integer()} | {:error, atom()}
  def get_token_balance(address, token_address) when is_address(address) and is_address(token_address) do
    "account"
    |> get("tokenbalance", %{address: address, contractaddress: token_address, tag: "latest"})
    |> parse()
    |> String.to_integer()
    |> wrap(:ok)
  end
  def get_token_balance(address, token_address) when not is_address(address) and is_address(token_address), do: @error_invalid_address
  def get_token_balance(address, token_address) when not is_address(token_address) and is_address(address), do: @error_invalid_token_address
  def get_token_balance(_, _), do: @error_invalid_address_and_token_address
end
