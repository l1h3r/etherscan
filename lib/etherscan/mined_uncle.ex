defmodule Etherscan.MinedUncle do
  @attributes [
    :blockNumber,
    :blockReward,
    :timeStamp
  ]

  defstruct @attributes

  @type t :: %Etherscan.MinedUncle{
    blockNumber: String.t,
    blockReward: String.t,
    timeStamp: String.t
  }
end
