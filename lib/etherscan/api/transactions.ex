defmodule Etherscan.API.Transactions do
  @moduledoc """
  Module to wrap Etherscan transaction endpoints.

  [Etherscan API Documentation](https://etherscan.io/apis#transactions)
  """

  alias Etherscan.{Factory, Utils}

  @doc """
  Check contract execution status by `transaction_hash`.

  ## Examples

      iex> transaction_hash = "#{Factory.transaction_hash()}"
      iex> response = Etherscan.API.Transactions.get_contract_execution_status(transaction_hash)
      {:ok, %{"errDescription" => "", "isError" => "0"}} = response

      iex> transaction_hash = "#{Factory.invalid_transaction_hash()}"
      iex> response = Etherscan.API.Transactions.get_contract_execution_status(transaction_hash)
      {:ok, %{"errDescription" => "Bad jump destination", "isError" => "1"}} = response
  """
  @spec get_contract_execution_status(transaction_hash :: String.t()) :: {:ok, map()} | {:error, atom()}
  def get_contract_execution_status(transaction_hash) when is_binary(transaction_hash) do
    params = %{
      txhash: transaction_hash,
    }

    "transaction"
    |> Utils.api("getstatus", params)
    |> Utils.parse()
    |> Utils.format()
  end
  def get_contract_execution_status(_), do: {:error, :invalid_transaction_hash}
end
