defmodule Etherscan.MinedUncle do
  @moduledoc """
  Etherscan module for the MinedUncle struct.
  """

  @attributes [
    :blockNumber,
    :blockReward,
    :timeStamp
  ]

  defstruct @attributes

  @type t :: %__MODULE__{
          blockNumber: String.t(),
          blockReward: String.t(),
          timeStamp: String.t()
        }
end
