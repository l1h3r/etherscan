defmodule Etherscan.Log do
  @moduledoc """
  Etherscan module for the Log struct.
  """

  @attributes [
    :address,
    :blockNumber,
    :data,
    :gasPrice,
    :gasUsed,
    :logIndex,
    :timeStamp,
    :topics,
    :transactionHash,
    :transactionIndex
  ]

  defstruct @attributes

  @type t :: %__MODULE__{
          address: String.t(),
          blockNumber: String.t(),
          data: String.t(),
          gasPrice: String.t(),
          gasUsed: String.t(),
          logIndex: String.t(),
          timeStamp: String.t(),
          topics: list(String.t()),
          transactionHash: String.t(),
          transactionIndex: String.t()
        }
end
