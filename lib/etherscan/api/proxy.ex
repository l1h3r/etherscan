defmodule Etherscan.API.Proxy do
  @moduledoc """
  Module to wrap Etherscan Geth/Parity proxy endpoints.

  [Etherscan API Documentation](https://etherscan.io/apis#proxy)
  """

  use Etherscan.API
  use Etherscan.Constants
  alias Etherscan.{ProxyBlock, ProxyTransaction, ProxyTransactionReceipt}

  @eth_estimate_gas_default_params %{
    to: nil,
    value: nil,
    gasPrice: nil,
    gas: nil
  }

  @doc """
  Returns the number of most recent block.

  ## Example

      iex> Etherscan.eth_block_number()
      {:ok, "#{@test_proxy_block_number}"}
  """
  def eth_block_number do
    "proxy"
    |> get("eth_blockNumber")
    |> parse()
    |> hex_to_number()
    |> wrap(:ok)
  end

  @doc """
  Returns information about a block by block number.

  ## Example

      iex> Etherscan.eth_get_block_by_number("#{@test_proxy_block_tag}")
      {:ok, %Etherscan.ProxyBlock{}}
  """
  def eth_get_block_by_number(tag) when is_binary(tag) do
    "proxy"
    |> get("eth_getBlockByNumber", %{tag: tag, boolean: true})
    |> parse(as: %{"result" => %ProxyBlock{transactions: [%ProxyTransaction{}]}})
    |> wrap(:ok)
  end

  def eth_get_block_by_number(_), do: @error_invalid_tag

  @doc """
  Returns information about a uncle by block number.

  ## Example

      iex> Etherscan.eth_get_uncle_by_block_number_and_index("#{@test_proxy_uncle_tag}", "#{
    @test_proxy_index
  }")
      {:ok, %{"number" => "#{@test_proxy_uncle_block_tag}", ...}}
  """
  def eth_get_uncle_by_block_number_and_index(tag, index)
      when is_binary(tag) and is_binary(index) do
    "proxy"
    |> get("eth_getUncleByBlockNumberAndIndex", %{tag: tag, index: index})
    |> parse()
    |> wrap(:ok)
  end

  def eth_get_uncle_by_block_number_and_index(tag, index)
      when not is_binary(tag) and is_binary(index),
      do: @error_invalid_tag

  def eth_get_uncle_by_block_number_and_index(tag, index)
      when not is_binary(index) and is_binary(tag),
      do: @error_invalid_index

  def eth_get_uncle_by_block_number_and_index(_, _), do: @error_invalid_tag_and_index

  @doc """
  Returns the number of transactions in a block from a block matching the
  given block number.

  ## Example

      iex> Etherscan.eth_get_block_transaction_count_by_number("#{@test_proxy_transaction_tag}")
      {:ok, "#{@test_proxy_block_transaction_count}"}
  """
  def eth_get_block_transaction_count_by_number(tag) when is_binary(tag) do
    "proxy"
    |> get("eth_getBlockTransactionCountByNumber", %{tag: tag})
    |> parse()
    |> hex_to_number()
    |> wrap(:ok)
  end

  def eth_get_block_transaction_count_by_number(_), do: @error_invalid_tag

  @doc """
  Returns the information about a transaction requested by transaction hash.

  ## Example

      iex> transaction_hash = "#{@test_proxy_transaction_hash}"
      iex> Etherscan.eth_get_transaction_by_hash(transaction_hash)
      {:ok, %Etherscan.ProxyTransaction{}}
  """
  def eth_get_transaction_by_hash(transaction_hash) when is_binary(transaction_hash) do
    "proxy"
    |> get("eth_getTransactionByHash", %{txhash: transaction_hash})
    |> parse(as: %{"result" => %ProxyTransaction{}})
    |> wrap(:ok)
  end

  def eth_get_transaction_by_hash(_), do: @error_invalid_transaction_hash

  @doc """
  Returns information about a transaction by block number and transaction
  index position.

  ## Example

      iex> Etherscan.eth_get_transaction_by_block_number_and_index("#{@test_proxy_block_tag}", "#{
    @test_proxy_index
  }")
      {:ok, %Etherscan.ProxyTransaction{}}
  """
  def eth_get_transaction_by_block_number_and_index(tag, index)
      when is_binary(tag) and is_binary(index) do
    "proxy"
    |> get("eth_getTransactionByBlockNumberAndIndex", %{tag: tag, index: index})
    |> parse(as: %{"result" => %ProxyTransaction{}})
    |> wrap(:ok)
  end

  def eth_get_transaction_by_block_number_and_index(tag, index)
      when not is_binary(tag) and is_binary(index),
      do: @error_invalid_tag

  def eth_get_transaction_by_block_number_and_index(tag, index)
      when not is_binary(index) and is_binary(tag),
      do: @error_invalid_index

  def eth_get_transaction_by_block_number_and_index(_, _), do: @error_invalid_tag_and_index

  @doc """
  Returns the number of transactions sent from an address.

  ## Example

      iex> Etherscan.eth_get_transaction_count("#{@test_proxy_address}")
      {:ok, #{@test_proxy_transaction_count}}
  """
  def eth_get_transaction_count(address) when is_binary(address) do
    "proxy"
    |> get("eth_getTransactionCount", %{address: address, tag: "latest"})
    |> parse()
    |> hex_to_number()
    |> wrap(:ok)
  end

  def eth_get_transaction_count(_), do: @error_invalid_address

  @doc """
  Creates new message call transaction or a contract creation for
  signed transactions.

  Replace the hex value with your raw hex encoded transaction that you want
  to send.

  ## Example

      iex> Etherscan.eth_send_raw_transaction("#{@test_proxy_hex}")
      {:ok, <TODO>}
  """
  def eth_send_raw_transaction(hex) when is_binary(hex) do
    "proxy"
    |> get("eth_sendRawTransaction", %{hex: hex})
    |> parse()
    |> wrap(:ok)
  end

  def eth_send_raw_transaction(_), do: @error_invalid_hex

  @doc """
  Returns the receipt of a transaction by transaction hash.

  ## Example

      iex> transaction_hash = "#{@test_proxy_transaction_hash}"
      iex> Etherscan.eth_get_transaction_receipt(transaction_hash)
      {:ok, %Etherscan.ProxyTransactionReceipt{}}
  """
  def eth_get_transaction_receipt(transaction_hash) when is_binary(transaction_hash) do
    "proxy"
    |> get("eth_getTransactionReceipt", %{txhash: transaction_hash})
    |> parse(as: %{"result" => %ProxyTransactionReceipt{}})
    |> wrap(:ok)
  end

  def eth_get_transaction_receipt(_), do: @error_invalid_transaction_hash

  @doc """
  Executes a new message call immediately without creating a transaction on
  the block chain.

  ## Example

      iex> Etherscan.eth_call("#{@test_proxy_to}", "#{@test_proxy_data}")
      {:ok, "#{@test_proxy_eth_call_result}"}
  """
  def eth_call(to, data) when is_binary(to) and is_binary(data) do
    "proxy"
    |> get("eth_call", %{to: to, data: data, tag: "latest"})
    |> parse()
    |> wrap(:ok)
  end

  def eth_call(to, data) when not is_binary(to) and is_binary(data), do: @error_invalid_to
  def eth_call(to, data) when not is_binary(data) and is_binary(to), do: @error_invalid_data
  def eth_call(_, _), do: @error_invalid_to_and_data

  @doc """
  Returns code at a given address.

  ## Example

      iex> Etherscan.eth_get_code("#{@test_proxy_code_address}", "latest")
      {:ok, "#{@test_proxy_code_result}"}
  """
  def eth_get_code(address, tag) when is_binary(address) and is_binary(tag) do
    "proxy"
    |> get("eth_getCode", %{address: address, tag: tag})
    |> parse()
    |> wrap(:ok)
  end

  def eth_get_code(address, tag) when not is_binary(address) and is_binary(tag),
    do: @error_invalid_address

  def eth_get_code(address, tag) when not is_binary(tag) and is_binary(address),
    do: @error_invalid_tag

  def eth_get_code(_, _), do: @error_invalid_address_and_tag

  @doc """
  Returns the value from a storage position at a given address.

  ## Example

      iex> Etherscan.eth_get_storage_at("#{@test_proxy_storage_address}", "#{
    @test_proxy_storage_position
  }")
      {:ok, "#{@test_proxy_storage_result}"}
  """
  def eth_get_storage_at(address, position) when is_binary(address) and is_binary(position) do
    "proxy"
    |> get("eth_getStorageAt", %{address: address, position: position, tag: "latest"})
    |> parse()
    |> wrap(:ok)
  end

  def eth_get_storage_at(address, position) when not is_binary(address) and is_binary(position),
    do: @error_invalid_address

  def eth_get_storage_at(address, position) when not is_binary(position) and is_binary(address),
    do: @error_invalid_position

  def eth_get_storage_at(_, _), do: @error_invalid_address_and_position

  @doc """
  Returns the current price per gas in wei.

  ## Example

      iex> Etherscan.eth_gas_price()
      {:ok, "#{@test_proxy_current_gas}"}
  """
  def eth_gas_price do
    "proxy"
    |> get("eth_gasPrice")
    |> parse()
    |> hex_to_number()
    |> wrap(:ok)
  end

  @doc """
  Makes a call or transaction, which won't be added to the blockchain and
  returns the used gas, which can be used for estimating the used gas.

  ## Example

      iex> params = %{
        to: "#{@test_proxy_estimate_to}",
        value: "#{@test_proxy_value}",
        gasPrice: "#{@test_proxy_gas_price}",
        gas: "#{@test_proxy_gas}",
      }
      iex> Etherscan.eth_estimate_gas(params)
      {:ok, <TODO>}
  """
  def eth_estimate_gas(%{to: _, value: _, gasPrice: _, gas: _} = params) when is_map(params) do
    params = merge_params(params, @eth_estimate_gas_default_params)

    "proxy"
    |> get("eth_estimateGas", params)
    |> parse()
    |> wrap(:ok)
  end

  def eth_estimate_gas(_), do: @error_invalid_params
end
