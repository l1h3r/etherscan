defmodule Etherscan.BlockRewardUncle do
  @attributes [
    :blockreward,
    :miner,
    :unclePosition
  ]

  defstruct @attributes

  @type t :: %Etherscan.BlockRewardUncle{
    blockreward: String.t,
    miner: String.t,
    unclePosition: String.t
  }
end
