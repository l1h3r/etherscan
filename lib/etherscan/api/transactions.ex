defmodule Etherscan.API.Transactions do
  @moduledoc """
  Module to wrap Etherscan transaction endpoints.

  [Etherscan API Documentation](https://etherscan.io/apis#transactions)
  """

  use Etherscan.API
  use Etherscan.Constants
  alias Etherscan.ContractStatus

  @doc """
  Check contract execution status by `transaction_hash`.

  ## Examples

      iex> transaction_hash = "#{@test_transaction_hash}"
      iex> response = Etherscan.API.Transactions.get_contract_execution_status(transaction_hash)
      {:ok, %ContractStatus{errDescription: "", isError: "0"}} = response

      iex> transaction_hash = "#{@test_invalid_transaction_hash}"
      iex> response = Etherscan.API.Transactions.get_contract_execution_status(transaction_hash)
      {:ok, %ContractStatus{errDescription: "Bad jump destination", isError: "1"}} = response
  """
  @spec get_contract_execution_status(transaction_hash :: String.t()) ::
          {:ok, ContractStatus.t()} | {:error, atom()}
  def get_contract_execution_status(transaction_hash) when is_address(transaction_hash) do
    "transaction"
    |> get("getstatus", %{txhash: transaction_hash})
    |> parse(as: %{"result" => %ContractStatus{}})
    |> wrap(:ok)
  end

  def get_contract_execution_status(_), do: @error_invalid_transaction_hash

  @doc """
  Check transaction receipt status by `transaction_hash`.

  Pre-Byzantium fork transactions return null/empty value.
  """
  @spec get_transaction_receipt_status(transaction_hash :: String.t()) ::
          {:ok, any()} | {:error, atom()}
  def get_transaction_receipt_status(transaction_hash) when is_address(transaction_hash) do
    "transaction"
    |> get("gettxreceiptstatus", %{txhash: transaction_hash})
    |> parse()
    |> wrap(:ok)
  end

  def get_transaction_receipt_status(_), do: @error_invalid_transaction_hash
end
