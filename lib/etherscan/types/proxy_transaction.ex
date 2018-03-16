defmodule Etherscan.ProxyTransaction do
  @moduledoc """
  Etherscan module for the ProxyTransaction struct.
  """

  @attributes [
    :blockHash,
    :blockNumber,
    :condition,
    :creates,
    :from,
    :gas,
    :gasPrice,
    :hash,
    :input,
    :networkId,
    :nonce,
    :publicKey,
    :r,
    :raw,
    :s,
    :standardV,
    :to,
    :transactionIndex,
    :v,
    :value,
  ]

  defstruct @attributes

  @type t :: %__MODULE__{
    blockHash: String.t(),
    blockNumber: String.t(),
    condition: String.t(),
    creates: String.t(),
    from: String.t(),
    gas: String.t(),
    gasPrice: String.t(),
    hash: String.t(),
    input: String.t(),
    networkId: integer(),
    nonce: String.t(),
    publicKey: String.t(),
    r: String.t(),
    raw: String.t(),
    s: String.t(),
    standardV: String.t(),
    to: String.t(),
    transactionIndex: String.t(),
    v: String.t(),
    value: String.t(),
  }
end

defimpl Poison.Decoder, for: Etherscan.ProxyTransaction do
  alias Etherscan.Util

  @keys [
    :gas,
    :gasUsed,
    :gasPrice,
    :blockNumber,
    :transactionIndex,
    :cumulativeGasUsed,
    :nonce,
    :value,
  ]

  def decode(value, _options) do
    @keys
    |> Enum.reduce(value, fn item, acc ->
      Map.update(acc, item, 0, &Util.safe_hex_to_number/1)
    end)
    |> Map.update(:gasPrice, 0, &Util.convert/1)
    |> Map.update(:value, 0, &Util.convert/1)
  end
end
