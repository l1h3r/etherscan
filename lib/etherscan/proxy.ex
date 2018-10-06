defmodule Etherscan.Proxy do
  @moduledoc """
  Module to wrap Etherscan Geth/Parity proxy endpoints.

  [Etherscan API Documentation](https://etherscan.io/apis#proxy)
  """
  use Etherscan.API
  use Etherscan.Constants

  @type block :: %{
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
          uncles: list()
        }

  @type transaction :: %{
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
          value: String.t()
        }

  @type transaction_receipt :: %{
          blockHash: String.t(),
          blockNumber: String.t(),
          contractAddress: String.t(),
          cumulativeGasUsed: String.t(),
          gasUsed: String.t(),
          logs: list(),
          logsBloom: String.t(),
          root: String.t(),
          status: integer(),
          transactionHash: String.t(),
          transactionIndex: String.t()
        }

  @type response(inner) :: Etherscan.response(inner)

  @estimate_gas_default_params %{
    to: nil,
    value: nil,
    gasPrice: nil,
    gas: nil
  }

  @doc """
  Returns the number of most recent block.

  ## Example

      iex> Etherscan.block_number()
      {:ok, "#{@test_proxy_block_number}"}

  """
  @spec block_number :: response(term)
  def block_number do
    "proxy"
    |> get("eth_blockNumber")
    |> parse()
    # |> hex_to_number()
    |> Util.wrap(:ok)
  end

  @doc """
  Returns information about a block by block number.

  ## Example

      iex> Etherscan.get_block_by_number("#{@test_proxy_block_tag}")
      {:ok, <TODO>}

  """
  @spec get_block_by_number(binary) :: response(block)
  def get_block_by_number(tag) when is_binary(tag) do
    params = %{
      tag: tag,
      boolean: true
    }

    "proxy"
    |> get("eth_getBlockByNumber", params)
    |> parse()
    |> Util.wrap(:ok)
  end

  def get_block_by_number(_) do
    {:error, :invalid_params}
  end

  @doc """
  Returns information about a uncle by block number.

  ## Example

      iex> Etherscan.get_uncle_by_block_number_and_index("#{@test_proxy_uncle_tag}", "#{@test_proxy_index}")
      {:ok, %{"number" => "#{@test_proxy_uncle_block_tag}", ...}}

  """
  @spec get_uncle_by_block_number_and_index(binary, binary) :: response(term)
  def get_uncle_by_block_number_and_index(tag, index) when is_binary(tag) and is_binary(index) do
    params = %{
      tag: tag,
      index: index
    }

    "proxy"
    |> get("eth_getUncleByBlockNumberAndIndex", params)
    |> parse()
    |> Util.wrap(:ok)
  end

  def get_uncle_by_block_number_and_index(_, _) do
    {:error, :invalid_params}
  end

  @doc """
  Returns the number of transactions in a block from a block matching the
  given block number.

  ## Example

      iex> Etherscan.get_block_transaction_count_by_number("#{@test_proxy_transaction_tag}")
      {:ok, "#{@test_proxy_block_transaction_count}"}

  """
  @spec get_block_transaction_count_by_number(binary) :: response(term)
  def get_block_transaction_count_by_number(tag) when is_binary(tag) do
    params = %{
      tag: tag
    }

    "proxy"
    |> get("eth_getBlockTransactionCountByNumber", params)
    |> parse()
    # |> hex_to_number()
    |> Util.wrap(:ok)
  end

  def get_block_transaction_count_by_number(_) do
    {:error, :invalid_params}
  end

  @doc """
  Returns the information about a transaction requested by transaction hash.

  ## Example

      iex> Etherscan.get_transaction_by_hash("#{@test_proxy_transaction_hash}")
      {:ok, <TODO>}

  """
  @spec get_transaction_by_hash(binary) :: response(transaction)
  def get_transaction_by_hash(transaction_hash) when is_binary(transaction_hash) do
    params = %{
      txhash: transaction_hash
    }

    "proxy"
    |> get("eth_getTransactionByHash", params)
    |> parse()
    |> Util.wrap(:ok)
  end

  def get_transaction_by_hash(_) do
    {:error, :invalid_params}
  end

  @doc """
  Returns information about a transaction by block number and transaction
  index position.

  ## Example

      iex> Etherscan.get_transaction_by_block_number_and_index("#{@test_proxy_block_tag}", "#{@test_proxy_index}")
      {:ok, <TODO>}

  """
  @spec get_transaction_by_block_number_and_index(binary, binary) :: response(transaction)
  def get_transaction_by_block_number_and_index(tag, index) when is_binary(tag) and is_binary(index) do
    params = %{
      tag: tag,
      index: index
    }

    "proxy"
    |> get("eth_getTransactionByBlockNumberAndIndex", params)
    |> parse()
    |> Util.wrap(:ok)
  end

  def get_transaction_by_block_number_and_index(_, _) do
    {:error, :invalid_params}
  end

  @doc """
  Returns the number of transactions sent from an address.

  ## Example

      iex> Etherscan.get_transaction_count("#{@test_proxy_address}")
      {:ok, #{@test_proxy_transaction_count}}

  """
  @spec get_transaction_count(binary) :: response(term)
  def get_transaction_count(address) when is_binary(address) do
    params = %{
      address: address,
      tag: "latest"
    }

    "proxy"
    |> get("eth_getTransactionCount", params)
    |> parse()
    # |> hex_to_number()
    |> Util.wrap(:ok)
  end

  def get_transaction_count(_) do
    {:error, :invalid_params}
  end

  @doc """
  Creates new message call transaction or a contract creation for
  signed transactions.

  Replace the hex value with your raw hex encoded transaction that you want
  to send.

  ## Example

      iex> Etherscan.send_raw_transaction("#{@test_proxy_hex}")
      {:ok, <TODO>}

  """
  @spec send_raw_transaction(binary) :: response(term)
  def send_raw_transaction(hex) when is_binary(hex) do
    params = %{
      hex: hex
    }

    "proxy"
    |> get("eth_sendRawTransaction", params)
    |> parse()
    |> Util.wrap(:ok)
  end

  def send_raw_transaction(_) do
    {:error, :invalid_params}
  end

  @doc """
  Returns the receipt of a transaction by transaction hash.

  ## Example

      iex> Etherscan.get_transaction_receipt("#{@test_proxy_transaction_hash}")
      {:ok, <TODO>}

  """
  @spec get_transaction_receipt(binary) :: response(transaction_receipt)
  def get_transaction_receipt(transaction_hash) when is_binary(transaction_hash) do
    params = %{
      txhash: transaction_hash
    }

    "proxy"
    |> get("eth_getTransactionReceipt", params)
    |> parse()
    |> Util.wrap(:ok)
  end

  def get_transaction_receipt(_) do
    {:error, :invalid_params}
  end

  @doc """
  Executes a new message call immediately without creating a transaction on
  the block chain.

  ## Example

      iex> Etherscan.call("#{@test_proxy_to}", "#{@test_proxy_data}")
      {:ok, "#{@test_proxy_eth_call_result}"}

  """
  @spec call(binary, binary) :: response(term)
  def call(to, data) when is_binary(to) and is_binary(data) do
    params = %{
      to: to,
      data: data,
      tag: "latest"
    }

    "proxy"
    |> get("eth_call", params)
    |> parse()
    |> Util.wrap(:ok)
  end

  def call(_, _) do
    {:error, :invalid_params}
  end

  @doc """
  Returns code at a given address.

  ## Example

      iex> Etherscan.get_code("#{@test_proxy_code_address}", "latest")
      {:ok, "#{@test_proxy_code_result}"}

  """
  @spec get_code(binary, binary) :: response(term)
  def get_code(address, tag) when is_binary(address) and is_binary(tag) do
    params = %{
      address: address,
      tag: tag
    }

    "proxy"
    |> get("eth_getCode", params)
    |> parse()
    |> Util.wrap(:ok)
  end

  def get_code(_, _) do
    {:error, :invalid_params}
  end

  @doc """
  Returns the value from a storage position at a given address.

  ## Example

      iex> Etherscan.Proxy.get_storage_at("#{@test_proxy_storage_address}", "#{@test_proxy_storage_position}")
      {:ok, "#{@test_proxy_storage_result}"}

  """
  @spec get_storage_at(binary, binary) :: response(term)
  def get_storage_at(address, position) when is_binary(address) and is_binary(position) do
    params = %{
      address: address,
      position: position,
      tag: "latest"
    }

    "proxy"
    |> get("eth_getStorageAt", params)
    |> parse()
    |> Util.wrap(:ok)
  end

  def get_storage_at(_, _) do
    {:error, :invalid_params}
  end

  @doc """
  Returns the current gas price in wei.

  ## Example

      iex> Etherscan.Proxy.gas_price()
      {:ok, "#{@test_proxy_current_gas}"}

  """
  @spec gas_price :: response(term)
  def gas_price do
    "proxy"
    |> get("eth_gasPrice")
    |> parse()
    # |> hex_to_number()
    |> Util.wrap(:ok)
  end

  @doc """
  Makes a call or transaction, which won't be added to the blockchain and
  returns the used gas, which can be used for estimating the used gas.

  ## Example

      iex> params = %{
      ...>   to: "#{@test_proxy_estimate_to}",
      ...>   value: "#{@test_proxy_value}",
      ...>   gasPrice: "#{@test_proxy_gas_price}",
      ...>   gas: "#{@test_proxy_gas}",
      ...> }
      ...> Etherscan.Proxy.estimate_gas(params)
      {:ok, <TODO>}

  """
  @spec estimate_gas(map) :: response(term)
  def estimate_gas(%{to: _, value: _, gasPrice: _, gas: _} = params) do
    params = Util.merge_params(params, @estimate_gas_default_params)

    "proxy"
    |> get("eth_estimateGas", params)
    |> parse()
    |> Util.wrap(:ok)
  end

  def estimate_gas(_) do
    {:error, :invalid_params}
  end
end
