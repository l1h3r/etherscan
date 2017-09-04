defmodule Etherscan.BlockReward do
  @attributes [
    :blockMiner,
    :blockNumber,
    :blockReward,
    :timeStamp,
    :uncleInclusionReward,
    :uncles
  ]

  defstruct @attributes

  @type t :: %Etherscan.BlockReward{
    blockMiner: String.t,
    blockNumber: String.t,
    blockReward: String.t,
    timeStamp: String.t,
    uncleInclusionReward: String.t,
    uncles: list(Etherscan.BlockRewardUncle.t)
  }
end
