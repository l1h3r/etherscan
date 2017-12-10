defmodule Etherscan.BlockRewardUncle do
  @moduledoc """
  Etherscan module for the BlockRewardUncle struct.
  """

  @attributes [
    :blockreward,
    :miner,
    :unclePosition,
  ]

  defstruct @attributes

  @type t :: %Etherscan.BlockRewardUncle{
    blockreward: String.t(),
    miner: String.t(),
    unclePosition: String.t(),
  }
end
