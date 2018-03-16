defmodule Etherscan.Transaction do
  @moduledoc """
  Etherscan module for the Transaction struct.
  """

  @attributes [
    :blockNumber,
    :timeStamp,
    :hash,
    :nonce,
    :blockHash,
    :transactionIndex,
    :from,
    :to,
    :value,
    :gas,
    :gasPrice,
    :isError,
    :txreceipt_status,
    :input,
    :contractAddress,
    :cumulativeGasUsed,
    :gasUsed,
    :confirmations,
  ]

  defstruct @attributes

  @type t :: %__MODULE__{
    blockNumber: String.t(),
    timeStamp: String.t(),
    hash: String.t(),
    nonce: String.t(),
    blockHash: String.t(),
    transactionIndex: String.t(),
    from: String.t(),
    to: String.t(),
    value: String.t(),
    gas: String.t(),
    gasPrice: String.t(),
    isError: String.t(),
    txreceipt_status: String.t(),
    input: String.t(),
    contractAddress: String.t(),
    cumulativeGasUsed: String.t(),
    gasUsed: String.t(),
    confirmations: String.t(),
  }
end
