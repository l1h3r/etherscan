defmodule Etherscan.BlockReward do
  @moduledoc """
  Etherscan module for the BlockReward struct.
  """

  alias Etherscan.BlockRewardUncle

  @attributes [
    :blockMiner,
    :blockNumber,
    :blockReward,
    :timeStamp,
    :uncleInclusionReward,
    :uncles
  ]

  defstruct @attributes

  @type t :: %__MODULE__{
          blockMiner: String.t(),
          blockNumber: String.t(),
          blockReward: String.t(),
          timeStamp: String.t(),
          uncleInclusionReward: String.t(),
          uncles: list(BlockRewardUncle.t())
        }
end
