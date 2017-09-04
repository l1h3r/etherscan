defmodule Etherscan.MinedBlock do
  @attributes [
    :blockNumber,
    :blockReward,
    :timeStamp
  ]

  defstruct @attributes

  @type t :: %Etherscan.MinedBlock{
    blockNumber: String.t,
    blockReward: String.t,
    timeStamp: String.t
  }
end
