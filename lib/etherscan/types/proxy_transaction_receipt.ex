defmodule Etherscan.ProxyTransactionReceipt do
  @moduledoc """
  Etherscan module for the ProxyTransactionReceipt struct.
  """

  @attributes [
    :blockHash,
    :blockNumber,
    :contractAddress,
    :cumulativeGasUsed,
    :gasUsed,
    :logs,
    :logsBloom,
    :root,
    :status,
    :transactionHash,
    :transactionIndex
  ]

  defstruct @attributes

  @type t :: %__MODULE__{
          blockHash: String.t(),
          blockNumber: String.t(),
          contractAddress: String.t(),
          cumulativeGasUsed: String.t(),
          gasUsed: String.t(),
          logs: list(),
          logsBloom: String.t(),
          root: String.t(),
          status: integer(),
          transactionHash: String.t(),
          transactionIndex: String.t()
        }
end

defimpl Poison.Decoder, for: Etherscan.ProxyTransactionReceipt do
  alias Etherscan.Util

  @keys [
    :gasUsed,
    :blockNumber,
    :transactionIndex,
    :cumulativeGasUsed
  ]

  def decode(value, _options) do
    Enum.reduce(@keys, value, fn item, acc ->
      Map.update(acc, item, 0, &Util.safe_hex_to_number/1)
    end)
  end
end
