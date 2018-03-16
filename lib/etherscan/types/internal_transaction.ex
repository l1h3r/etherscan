defmodule Etherscan.InternalTransaction do
  @moduledoc """
  Etherscan module for the InternalTransaction struct.
  """

  @attributes [
    :blockNumber,
    :contractAddress,
    :errCode,
    :from,
    :gas,
    :gasUsed,
    :hash,
    :input,
    :isError,
    :timeStamp,
    :to,
    :traceId,
    :type,
    :value,
  ]

  defstruct @attributes

  @type t :: %__MODULE__{
    blockNumber: String.t(),
    contractAddress: String.t(),
    errCode: String.t(),
    from: String.t(),
    gas: String.t(),
    gasUsed: String.t(),
    hash: String.t(),
    input: String.t(),
    isError: String.t(),
    timeStamp: String.t(),
    to: String.t(),
    traceId: String.t(),
    type: String.t(),
    value: String.t(),
  }
end
