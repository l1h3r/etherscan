defmodule Etherscan.API.Transactions do
  @moduledoc """
  Module to wrap Etherscan transaction endpoints.
  See: https://etherscan.io/apis#transactions
  """

  alias Etherscan.Utils

  def get_contract_execution_status(transaction_hash) when is_binary(transaction_hash) do
    params = %{
      txhash: transaction_hash
    }

    "transaction"
    |> Utils.api("getstatus", params)
    |> Utils.parse()
    |> Utils.format()
  end
  def get_contract_execution_status(_), do: {:error, :invalid_transaction_hash}
end
