defmodule Etherscan do
  @moduledoc """
  Documentation for Etherscan.
  """

  @api_base "https://api.etherscan.io/api"
  @api_key ""
  @ether_val 1000000000000000000

  @balance_address_limit 20
  @account_transaction_params [:startblock, :endblock, :sort, :page, :offset]
  @blocks_mined_params [:blocktype, :page, :offset]

  #
  # Accounts. See - https://etherscan.io/apis#accounts
  #

  @doc """
  Get ether balance for a single `address`. `address` can be a list of
  multiple `addresses`, up to a maximum of 20 `addresses`.

  If given an `address`, returns balance in ether.

  If given a list of `addresses`, returns a list of balances.
  """
  def get_balance(address) when is_binary(address) do
    params = account_balance_params(address)
    call_api("account", "balance", params)
    |> to_eth()
  end

  def get_balance(addresses) when is_list(addresses) and length(addresses) <= @balance_address_limit do
    params = account_balance_params(addresses)
    call_api("account", "balancemulti", params)
    |> format_account_balance()
  end

  @doc """
  *BETA*

  Get a list of 'Normal' transactions by `address`. Returns up to a maximum
  of the last 10000 transactions only.

  ```
  params = %{
    page: 1, // Page number
    offset: 10, // Max records returned
    sort: "asc", // Sort returned records
    startblock: 0, // Start block number
    endblock: 99999999 // End block number
  }
  ```
  """
  # TODO: Returned 'isError' values: 0=No Error, 1=Got Error
  def get_transactions(address, params \\ %{}) do
    params = account_transaction_params(address, params)
    call_api("account", "txlist", params)
  end

  @doc """
  *BETA*

  Get a list of 'Internal' transactions by `address`. Returns up to a maximum
  of the last 10000 transactions only.

  ```
  params = %{
    page: 1, // Page number
    offset: 10, // Max records returned
    sort: "asc", // Sort returned records
    startblock: 0, // Start block number
    endblock: 99999999 // End block number
  }
  ```
  """
  # TODO: Returned 'isError' values: 0=No Error, 1=Got Error
  def get_internal_transactions(address, params \\ %{}) do
    params = account_transaction_params(address, params)
    call_api("account", "txlistinternal", params)
  end

  @doc """
  Get a list of 'Internal Transactions' by `transaction_hash`. Returns up to
  a maximum of the last 10000 transactions only.
  """
  # TODO: Returned 'isError' values: 0=Ok, 1=Rejected/Cancelled
  def get_internal_transactions_by_hash(transaction_hash) do
    params = internal_transaction_params(transaction_hash)
    call_api("account", "txlistinternal", params)
  end

  @doc """
  Get a list of blocks mined by `address`.

  ```
  params = %{
    page: 1, // Page number
    offset: 10 // Max records returned
  }
  ```
  """
  def get_blocks_mined(address, params \\ %{}) do
    params = blocks_mined_params(address, params)
    call_api("account", "getminedblocks", params)
  end

  @doc """
  Get a list of uncles mined by `address`.

  ```
  params = %{
    page: 1, // Page number
    offset: 10 // Max records returned
  }
  ```
  """
  def get_uncles_mined(address, params \\ %{}) do
    params = uncles_mined_params(address, params)
    call_api("account", "getminedblocks", params)
  end

  @doc """
  Get the ERC20 token balance of the `address` for token at `token_address`.
  """
  def get_token_balance(address, token_address) do
    params = token_balance_params(address, token_address)
    call_api("account", "tokenbalance", params)
  end

  #
  # Blocks. See - https://etherscan.io/apis#blocks
  #

  @doc """
  *BETA*

  Get block and uncle rewards by `block_number`.

  Returns a map of data:
  ```
  %{
    "blockMiner" => "0xc8ebccc5f5689fa8659d83713341e5ad19349448",
    "blockNumber" => "4",
    "blockReward" => "5156250000000000000",
    "timeStamp" => "1438270077",
    "uncleInclusionReward" => "156250000000000000",
    "uncles" => [%{
      "blockreward" => "3125000000000000000",
      "miner" => "0x5088d623ba0fcf0131e0897a91734a4d83596aa0",
      "unclePosition" => "0"
    }]
  }
  ```
  """
  def get_block_and_uncle_rewards(block_number) do
    params = block_and_uncle_reward_params(block_number)
    call_api("block", "getblockreward", params)
  end

  #
  # Contracts. See - https://etherscan.io/apis#contracts
  #

  @doc """
  Get contract ABI for contracts with verified source code, by `address`.

  See - https://etherscan.io/contractsVerified
  """
  def get_contract_abi(address) do
    params = contract_abi_params(address)
    call_api("contract", "getabi", params)
  end

  #
  # Stats. See - https://etherscan.io/apis#stats
  #

  @doc """
  Get total supply of ether.
  """
  def get_eth_supply do
    call_api("stats", "ethsupply")
    |> to_eth()
  end

  @doc """
  Get ether price.
  """
  def get_eth_price do
    call_api("stats", "ethprice")
  end

  @doc """
  Get total supply of ERC20 token, by `token_address`.
  """
  def get_token_supply(token_address) do
    params = token_supply_params(token_address)
    call_api("stats", "tokensupply", params)
  end

  #
  # Transactions. See - https://etherscan.io/apis#transactions
  #

  @doc """
  *BETA*

  Check contract execution status (if there was an error during
  contract execution) by `transaction_hash`.
  """
  # TODO: Returned 'isError' values: 0=Pass, 1=Error during Contract Execution
  def get_contract_execution_status(transaction_hash) do
    params = contract_execution_status_params(transaction_hash)
    call_api("transaction", "getstatus", params)
  end

  #
  # Account Params
  #

  defp account_balance_params(address) when is_binary(address) do
    %{
      tag: "latest",
      address: address
    }
  end

  defp account_balance_params(addresses) when is_list(addresses) do
    %{
      tag: "latest",
      address: Enum.join(addresses, ",")
    }
  end

  defp account_transaction_params(address, params) do
    params
    |> Map.take(@account_transaction_params)
    |> Map.put(:address, address)
  end

  defp internal_transaction_params(transaction_hash) do
    %{txhash: transaction_hash}
  end

  defp blocks_mined_params(address, params) do
    params
    |> Map.take(@blocks_mined_params)
    |> Map.put(:address, address)
  end

  defp uncles_mined_params(address, params) do
    params
    |> Map.take(@blocks_mined_params)
    |> Map.put(:blocktype, "uncles")
    |> Map.put(:address, address)
  end

  defp token_balance_params(address, token_address) do
    %{
      tag: "latest",
      address: address,
      contractaddress: token_address
    }
  end

  #
  # Block Params
  #

  defp block_and_uncle_reward_params(block_number) do
    %{blockno: block_number}
  end

  #
  # Contract Params
  #

  defp contract_abi_params(address) do
    %{address: address}
  end

  #
  # Token Params
  #

  defp token_supply_params(token_address) do
    %{contractaddress: token_address}
  end

  #
  # Transaction Params
  #

  defp contract_execution_status_params(transaction_hash) do
    %{txhash: transaction_hash}
  end

  #
  # Api
  #

  defp call_api(module, action, params \\ %{}) do
    build_query(module, action, params)
    |> build_path()
    |> HTTPoison.get!([], [recv_timeout: 10000])
    |> Map.get(:body)
    |> Poison.decode!
    |> Map.get("result")
  end

  defp build_path(query), do: @api_base <> "?" <> query

  defp build_query(module, action, params) do
    params
    |> Map.put(:action, action)
    |> Map.put(:module, module)
    |> Map.put(:apikey, @api_key)
    |> URI.encode_query
  end

  defp to_eth(value) when is_integer(value), do: value / @ether_val

  defp to_eth(value) when is_binary(value) do
    value
    |> String.to_integer
    |> to_eth()
  end

  defp format_account_balance(accounts) when is_list(accounts) do
    Enum.map(accounts, &format_account_balance/1)
  end

  defp format_account_balance(account) do
    balance =
      account
      |> Map.get("balance")
      |> to_eth()

    Map.put(account, "balance", balance)
  end

end
