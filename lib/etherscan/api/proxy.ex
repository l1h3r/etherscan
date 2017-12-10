defmodule Etherscan.API.Proxy do
  @moduledoc """
  Module to wrap Etherscan Geth/Parity proxy endpoints.

  [Etherscan API Documentation](https://etherscan.io/apis#proxy)
  """

  alias Etherscan.{Factory, Utils}

  @eth_estimate_gas_default_params %{
    to: nil,
    value: nil,
    gasPrice: nil,
    gas: nil,
  }

  @doc """
  Returns the number of most recent block.

  ## Example

      iex> Etherscan.API.Proxy.eth_block_number()
      {:ok, "#{Factory.proxy_block_number()}"}
  """
  def eth_block_number do
    "proxy"
    |> Utils.api("eth_blockNumber")
    |> Utils.parse()
    |> Utils.format()
  end

  @doc """
  Returns information about a block by block number.

  ## Example

      iex> Etherscan.API.Proxy.eth_get_block_by_number("#{Factory.proxy_block_tag()}")
      {:ok, %{"number" => "#{Factory.proxy_block_tag()}", ...}}
  """
  def eth_get_block_by_number(tag) when is_binary(tag) do
    params = %{
      tag: tag,
      boolean: true,
    }

    "proxy"
    |> Utils.api("eth_getBlockByNumber", params)
    |> Utils.parse()
    |> Utils.format()
  end
  def eth_get_block_by_number(_), do: {:error, :invalid_tag}

  @doc """
  Returns information about a uncle by block number.

  ## Example

      iex> Etherscan.API.Proxy.eth_get_uncle_by_block_number_and_index("#{Factory.proxy_uncle_tag()}", "#{Factory.proxy_index()}")
      {:ok, %{"number" => "#{Factory.proxy_uncle_block_tag()}", ...}}
  """
  def eth_get_uncle_by_block_number_and_index(tag, index) when is_binary(tag) and is_binary(index) do
    params = %{
      tag: tag,
      index: index,
    }

    "proxy"
    |> Utils.api("eth_getUncleByBlockNumberAndIndex", params)
    |> Utils.parse()
    |> Utils.format()
  end
  def eth_get_uncle_by_block_number_and_index(tag, index) when not is_binary(tag) and is_binary(index), do: {:error, :invalid_tag}
  def eth_get_uncle_by_block_number_and_index(tag, index) when not is_binary(index) and is_binary(tag), do: {:error, :invalid_index}
  def eth_get_uncle_by_block_number_and_index(_, _), do: {:error, :invalid_tag_and_index}

  @doc """
  Returns the number of transactions in a block from a block matching the
  given block number.

  ## Example

      iex> Etherscan.API.Proxy.eth_get_block_transaction_count_by_number("#{Factory.proxy_transaction_tag()}")
      {:ok, "#{Factory.proxy_block_transaction_count()}"}
  """
  def eth_get_block_transaction_count_by_number(tag) when is_binary(tag) do
    params = %{
      tag: tag,
    }

    "proxy"
    |> Utils.api("eth_getBlockTransactionCountByNumber", params)
    |> Utils.parse()
    |> Utils.format()
  end
  def eth_get_block_transaction_count_by_number(_), do: {:error, :invalid_tag}

  @doc """
  Returns the information about a transaction requested by transaction hash.

  ## Example

      iex> transaction_hash = "#{Factory.proxy_transaction_hash()}"
      iex> Etherscan.API.Proxy.eth_get_transaction_by_hash(transaction_hash)
      {:ok, %{"hash" => "#{Factory.proxy_transaction_hash()}", ...}}
  """
  def eth_get_transaction_by_hash(transaction_hash) when is_binary(transaction_hash) do
    params = %{
      txhash: transaction_hash,
    }

    "proxy"
    |> Utils.api("eth_getTransactionByHash", params)
    |> Utils.parse()
    |> Utils.format()
  end
  def eth_get_transaction_by_hash(_), do: {:error, :invalid_transaction_hash}

  @doc """
  Returns information about a transaction by block number and transaction
  index position.

  ## Example

      iex> Etherscan.API.Proxy.eth_get_transaction_by_block_number_and_index("#{Factory.proxy_block_tag()}", "#{Factory.proxy_index()}")
      {:ok, %{"blockNumber" => "#{Factory.proxy_block_tag()}", ...}}
  """
  def eth_get_transaction_by_block_number_and_index(tag, index) when is_binary(tag) and is_binary(index) do
    params = %{
      tag: tag,
      index: index,
    }

    "proxy"
    |> Utils.api("eth_getTransactionByBlockNumberAndIndex", params)
    |> Utils.parse()
    |> Utils.format()
  end
  def eth_get_transaction_by_block_number_and_index(tag, index) when not is_binary(tag) and is_binary(index), do: {:error, :invalid_tag}
  def eth_get_transaction_by_block_number_and_index(tag, index) when not is_binary(index) and is_binary(tag), do: {:error, :invalid_index}
  def eth_get_transaction_by_block_number_and_index(_, _), do: {:error, :invalid_tag_and_index}

  @doc """
  Returns the number of transactions sent from an address.

  ## Example

      iex> Etherscan.API.Proxy.eth_get_transaction_count("#{Factory.proxy_address()}")
      {:ok, #{Factory.proxy_transaction_count()}}
  """
  def eth_get_transaction_count(address) when is_binary(address) do
    params = %{
      address: address,
      tag: "latest",
    }

    "proxy"
    |> Utils.api("eth_getTransactionCount", params)
    |> Utils.parse()
    |> Utils.format()
  end
  def eth_get_transaction_count(_), do: {:error, :invalid_address}

  @doc """
  Creates new message call transaction or a contract creation for
  signed transactions.

  Replace the hex value with your raw hex encoded transaction that you want
  to send.

  ## Example

      iex> Etherscan.API.Proxy.eth_send_raw_transaction("#{Factory.proxy_hex()}")
      {:ok, <TODO>}
  """
  def eth_send_raw_transaction(hex) when is_binary(hex) do
    params = %{
      hex: hex,
    }

    "proxy"
    |> Utils.api("eth_sendRawTransaction", params)
    |> Utils.parse()
    |> Utils.format()
  end
  def eth_send_raw_transaction(_), do: {:error, :invalid_hex}

  @doc """
  Returns the receipt of a transaction by transaction hash.

  ## Example

      iex> transaction_hash = "#{Factory.proxy_transaction_hash()}"
      iex> Etherscan.API.Proxy.eth_get_transaction_receipt(transaction_hash)
      {:ok, %{"transactionHash" => transaction_hash, ...}}
  """
  def eth_get_transaction_receipt(transaction_hash) when is_binary(transaction_hash) do
    params = %{
      txhash: transaction_hash,
    }

    "proxy"
    |> Utils.api("eth_getTransactionReceipt", params)
    |> Utils.parse()
    |> Utils.format()
  end
  def eth_get_transaction_receipt(_), do: {:error, :invalid_transaction_hash}

  @doc """
  Executes a new message call immediately without creating a transaction on
  the block chain.

  ## Example

      iex> params = %{
        to: "#{Factory.proxy_to()}",
        data: "#{Factory.proxy_data()}",
      }
      iex> Etherscan.API.Proxy.eth_call(params.to, params.data)
      {:ok, "#{Factory.proxy_eth_call_result()}"}
  """
  def eth_call(to, data) when is_binary(to) and is_binary(data) do
    params = %{
      to: to,
      data: data,
      tag: "latest",
    }

    "proxy"
    |> Utils.api("eth_call", params)
    |> Utils.parse()
    |> Utils.format()
  end
  def eth_call(to, data) when not is_binary(to) and is_binary(data), do: {:error, :invalid_to}
  def eth_call(to, data) when not is_binary(data) and is_binary(to), do: {:error, :invalid_data}
  def eth_call(_, _), do: {:error, :invalid_to_and_data}

  @doc """
  Returns code at a given address.

  ## Example

      iex> Etherscan.API.Proxy.eth_get_code("#{Factory.proxy_code_address()}", "latest")
      {:ok, "#{Factory.proxy_code_result()}"}
  """
  def eth_get_code(address, tag) when is_binary(address) and is_binary(tag) do
    params = %{
      address: address,
      tag: tag,
    }

    "proxy"
    |> Utils.api("eth_getCode", params)
    |> Utils.parse()
    |> Utils.format()
  end
  def eth_get_code(address, tag) when not is_binary(address) and is_binary(tag), do: {:error, :invalid_address}
  def eth_get_code(address, tag) when not is_binary(tag) and is_binary(address), do: {:error, :invalid_tag}
  def eth_get_code(_, _), do: {:error, :invalid_address_and_tag}

  @doc """
  Returns the value from a storage position at a given address.

  ## Example

      iex> Etherscan.API.Proxy.eth_get_storage_at("#{Factory.proxy_storage_address()}", "#{Factory.proxy_storage_position()}")
      {:ok, "#{Factory.proxy_storage_result()}"}
  """
  def eth_get_storage_at(address, position) when is_binary(address) and is_binary(position) do
    params = %{
      address: address,
      position: position,
      tag: "latest",
    }

    "proxy"
    |> Utils.api("eth_getStorageAt", params)
    |> Utils.parse()
    |> Utils.format()
  end
  def eth_get_storage_at(address, position) when not is_binary(address) and is_binary(position), do: {:error, :invalid_address}
  def eth_get_storage_at(address, position) when not is_binary(position) and is_binary(address), do: {:error, :invalid_position}
  def eth_get_storage_at(_, _), do: {:error, :invalid_address_and_position}

  @doc """
  Returns the current price per gas in wei.

  ## Example

      iex> Etherscan.API.Proxy.eth_gas_price()
      {:ok, "#{Factory.proxy_current_gas()}"}
  """
  def eth_gas_price do
    "proxy"
    |> Utils.api("eth_gasPrice")
    |> Utils.parse()
    |> Utils.format()
  end

  @doc """
  Makes a call or transaction, which won't be added to the blockchain and
  returns the used gas, which can be used for estimating the used gas.

  ## Example

      iex> params = %{
        to: "#{Factory.proxy_estimate_to()}",
        value: "#{Factory.proxy_value()}",
        gasPrice: "#{Factory.proxy_gas_price()}",
        gas: "#{Factory.proxy_gas()}",
      }
      iex> Etherscan.API.Proxy.eth_estimate_gas(params)
      {:ok, <TODO>}
  """
  def eth_estimate_gas(%{to: _, value: _, gasPrice: _, gas: _} = params) do
    params =
      @eth_estimate_gas_default_params
      |> Map.merge(params)
      |> Map.take(@eth_estimate_gas_default_params |> Map.keys())

    "proxy"
    |> Utils.api("eth_estimateGas", params)
    |> Utils.parse()
    |> Utils.format()
  end
  def eth_estimate_gas(_), do: {:error, :invalid_params}
end
