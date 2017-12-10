defmodule Etherscan.Block do
  @moduledoc """
  Etherscan module for the Block struct.
  """

  @attributes [
    :blockHash,
    :blockNumber,
    :confirmations,
    :contractAddress,
    :cumulativeGasUsed,
    :from,
    :gas,
    :gasPrice,
    :gasUsed,
    :hash,
    :input,
    :isError,
    :nonce,
    :timeStamp,
    :to,
    :transactionIndex,
    :value,
  ]

  defstruct @attributes

  @type t :: %Etherscan.Block{
    blockHash: String.t(),
    blockNumber: String.t(),
    confirmations: String.t(),
    contractAddress: String.t(),
    cumulativeGasUsed: String.t(),
    from: String.t(),
    gas: String.t(),
    gasPrice: String.t(),
    gasUsed: String.t(),
    hash: String.t(),
    input: String.t(),
    isError: String.t(),
    nonce: String.t(),
    timeStamp: String.t(),
    to: String.t(),
    transactionIndex: String.t(),
    value: String.t(),
  }
end
