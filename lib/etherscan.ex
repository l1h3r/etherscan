defmodule Etherscan do
  @moduledoc """
  Documentation for Etherscan.
  """

  alias Etherscan.API

  defdelegate get_balance(address), to: API.Accounts
  defdelegate get_balances(addresses), to: API.Accounts
  defdelegate get_transactions(address), to: API.Accounts
  defdelegate get_transactions(address, params), to: API.Accounts
  defdelegate get_internal_transactions(address), to: API.Accounts
  defdelegate get_internal_transactions(address, params), to: API.Accounts
  defdelegate get_internal_transactions_by_hash(transaction_hash), to: API.Accounts
  defdelegate get_blocks_mined(address), to: API.Accounts
  defdelegate get_blocks_mined(address, params), to: API.Accounts
  defdelegate get_uncles_mined(address), to: API.Accounts
  defdelegate get_uncles_mined(address, params), to: API.Accounts
  defdelegate get_token_balance(address, token_address), to: API.Accounts

  defdelegate get_block_and_uncle_rewards(block_number), to: API.Blocks

  defdelegate get_contract_abi(address), to: API.Contracts

  defdelegate get_logs(params), to: API.Logs

  defdelegate eth_block_number, to: API.Proxy
  defdelegate eth_get_block_by_number(tag), to: API.Proxy
  defdelegate eth_get_uncle_by_block_number_and_index(tag, index), to: API.Proxy
  defdelegate eth_get_block_transaction_count_by_number(tag), to: API.Proxy
  defdelegate eth_get_transaction_by_hash(transaction_hash), to: API.Proxy
  defdelegate eth_get_transaction_by_block_number_and_index(tag, index), to: API.Proxy
  defdelegate eth_get_transaction_count(address), to: API.Proxy
  defdelegate eth_send_raw_transaction(hex), to: API.Proxy
  defdelegate eth_get_transaction_receipt(transaction_hash), to: API.Proxy
  defdelegate eth_call(to, data), to: API.Proxy
  defdelegate eth_get_code(address, tag), to: API.Proxy
  defdelegate eth_get_storage_at(address, position), to: API.Proxy
  defdelegate eth_gas_price, to: API.Proxy
  defdelegate eth_estimate_gas(params), to: API.Proxy

  defdelegate get_token_supply(token_address), to: API.Stats
  defdelegate get_eth_supply, to: API.Stats
  defdelegate get_eth_price, to: API.Stats

  defdelegate get_contract_execution_status(transaction_hash), to: API.Transactions
  defdelegate get_transaction_receipt_status(transaction_hash), to: API.Transactions
end
