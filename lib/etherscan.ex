defmodule Etherscan do
  @moduledoc """
  Documentation for Etherscan.
  """

  @doc """
  Get ether balance for a single `address`. Balance is returned in wei.
  """
  @spec get_balance(address :: String.t) :: {:ok, non_neg_integer} | {:error, atom}
  defdelegate get_balance(address), to: Etherscan.API.Accounts

  @doc """
  Get ether balance for a list of multiple `addresses`, up to a
  maximum of 20. Balances are returned in wei.
  """
  @spec get_balances(addresses :: list(String.t)) :: {:ok, map} | {:error, atom}
  defdelegate get_balances(addresses), to: Etherscan.API.Accounts

  @doc """
  Get a list of 'Normal' transactions by `address`. Returns up to a maximum
  of the last 10,000 transactions only.

  ```
  params = %{
    page: 1, # Page number
    offset: 10, # Max records returned
    sort: "asc", # Sort returned records
    startblock: 0, # Start block number
    endblock: 99999999 # End block number
  }
  ```
  """
  @spec get_transactions(address :: String.t, params :: map) :: {:ok, list(Etherscan.Block.t)} | {:error, atom}
  defdelegate get_transactions(address), to: Etherscan.API.Accounts
  defdelegate get_transactions(address, params), to: Etherscan.API.Accounts

  @doc """
  Get a list of 'Internal' transactions by `address`. Returns up to a maximum
  of the last 10,000 transactions only.

  ```
  params = %{
    page: 1, # Page number
    offset: 10, # Max records returned
    sort: "asc", # Sort returned records
    startblock: 0, # Start block number
    endblock: 99999999 # End block number
  }
  ```
  """
  @spec get_internal_transactions(address :: String.t, params :: map) :: {:ok, list(Etherscan.Block.t)} | {:error, atom}
  defdelegate get_internal_transactions(address), to: Etherscan.API.Accounts
  defdelegate get_internal_transactions(address, params), to: Etherscan.API.Accounts

  @doc """
  Get a list of 'Internal Transactions' by `transaction_hash`. Returns up to
  a maximum of the last 10,000 transactions only.
  """
  @spec get_internal_transactions_by_hash(transaction_hash :: String.t) :: {:ok, list(Etherscan.Block.t)} | {:error, atom}
  defdelegate get_internal_transactions_by_hash(transaction_hash), to: Etherscan.API.Accounts

  @doc """
  Get a list of blocks mined by `address`.

  ```
  params = %{
    page: 1, # Page number
    offset: 10 # Max records returned
  }
  ```
  """
  @spec get_blocks_mined(address :: String.t, params :: map) :: {:ok, list(Etherscan.Block.t)} | {:error, atom}
  defdelegate get_blocks_mined(address), to: Etherscan.API.Accounts
  defdelegate get_blocks_mined(address, params), to: Etherscan.API.Accounts

  @doc """
  Get a list of uncles mined by `address`.

  ```
  params = %{
    page: 1, # Page number
    offset: 10 # Max records returned
  }
  ```
  """
  @spec get_uncles_mined(address :: String.t, params :: map) :: {:ok, list(Etherscan.Block.t)} | {:error, atom}
  defdelegate get_uncles_mined(address), to: Etherscan.API.Accounts
  defdelegate get_uncles_mined(address, params), to: Etherscan.API.Accounts

  @doc """
  Get block and uncle rewards by `block_number`.
  """
  @spec get_block_and_uncle_rewards(block_number :: non_neg_integer) :: {:ok, Etherscan.BlockReward.t} :: {:error, atom}
  defdelegate get_block_and_uncle_rewards(block_number), to: Etherscan.API.Blocks

  @doc """
  Get contract ABI for contracts with verified source code, by `address`.

  ## See: https://etherscan.io/contractsVerified
  """
  @spec get_contract_abi(address :: String.t) :: {:ok, list} | {:error, atom}
  defdelegate get_contract_abi(address), to: Etherscan.API.Contracts

  @doc """
  Get the ERC20 token balance of the `address` for token at `token_address`.

  ## See: https://etherscan.io/apis#tokens
  """
  @spec get_token_balance(address :: String.t, token_address :: String.t) :: {:ok, non_neg_integer} | {:error, atom}
  defdelegate get_token_balance(address, token_address), to: Etherscan.API.Accounts

  @doc """
  Get total supply of ERC20 token, by `token_address`.

  ## See: https://etherscan.io/apis#tokens
  """
  @spec get_token_supply(token_address :: String.t) :: {:ok, non_neg_integer} | {:error, atom}
  defdelegate get_token_supply(token_address), to: Etherscan.API.Stats

  @doc """
  Get total supply of ether. Total supply is returned in wei.
  """
  @spec get_eth_supply :: {:ok, non_neg_integer}
  defdelegate get_eth_supply, to: Etherscan.API.Stats

  @doc """
  Get ether price.
  """
  @spec get_eth_price :: {:ok, map}
  defdelegate get_eth_price, to: Etherscan.API.Stats

  @doc """
  Check contract execution status (if there was an error during
  contract execution) by `transaction_hash`.
  """
  @spec get_contract_execution_status(transaction_hash :: String.t) :: {:ok, map} | {:error, atom}
  defdelegate get_contract_execution_status(transaction_hash), to: Etherscan.API.Transactions
end
