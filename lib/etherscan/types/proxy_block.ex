defmodule Etherscan.ProxyBlock do
  @moduledoc """
  Etherscan module for the ProxyBlock struct.
  """

  alias Etherscan.ProxyTransaction

  @attributes [
    :author,
    :difficulty,
    :extraData,
    :gasLimit,
    :gasUsed,
    :hash,
    :logsBloom,
    :miner,
    :mixHash,
    :nonce,
    :number,
    :parentHash,
    :receiptsRoot,
    :sealFields,
    :sha3Uncles,
    :size,
    :stateRoot,
    :timestamp,
    :totalDifficulty,
    :transactions,
    :transactionsRoot,
    :uncles,
  ]

  defstruct @attributes

  @type t :: %__MODULE__{
    author: String.t(),
    difficulty: String.t(),
    extraData: String.t(),
    gasLimit: String.t(),
    gasUsed: String.t(),
    hash: String.t(),
    logsBloom: String.t(),
    miner: String.t(),
    mixHash: String.t(),
    nonce: String.t(),
    number: String.t(),
    parentHash: String.t(),
    receiptsRoot: String.t(),
    sealFields: list(),
    sha3Uncles: String.t(),
    size: String.t(),
    stateRoot: String.t(),
    timestamp: String.t(),
    totalDifficulty: String.t(),
    transactions: list(ProxyTransaction.t()),
    transactionsRoot: String.t(),
    uncles: list(),
  }
end

defimpl Poison.Decoder, for: Etherscan.ProxyBlock do
  alias Etherscan.Util

  @keys [
    :difficulty,
    :gasLimit,
    :gasUsed,
    :number,
    :size,
    :timestamp,
    :totalDifficulty,
  ]

  def decode(value, _options) do
    Enum.reduce(@keys, value, fn item, acc ->
      Map.update(acc, item, 0, &Util.safe_hex_to_number/1)
    end)
  end
end
