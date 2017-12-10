defmodule Etherscan.MinedBlock do
  @moduledoc """
  Etherscan module for the MinedBlock struct.
  """

  @attributes [
    :blockNumber,
    :blockReward,
    :timeStamp,
  ]

  defstruct @attributes

  @type t :: %Etherscan.MinedBlock{
    blockNumber: String.t(),
    blockReward: String.t(),
    timeStamp: String.t(),
  }
end
