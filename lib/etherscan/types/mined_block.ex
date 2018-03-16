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

  @type t :: %__MODULE__{
    blockNumber: String.t(),
    blockReward: String.t(),
    timeStamp: String.t(),
  }
end
