defmodule Etherscan do
  @moduledoc """
  Documentation for Etherscan.
  """
  use Etherscan.API
  use Etherscan.Constants

  @type block_reward :: %{
          blockMiner: String.t(),
          blockNumber: String.t(),
          blockReward: String.t(),
          timeStamp: String.t(),
          uncleInclusionReward: String.t(),
          uncles: [block_reward_uncle]
        }

  @type block_reward_uncle :: %{
          blockreward: String.t(),
          miner: String.t(),
          unclePosition: String.t()
        }

  @type contract_status :: %{
          isError: String.t(),
          errDescription: String.t()
        }

  @type internal_transaction :: %{
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
          value: String.t()
        }

  @type log :: %{
          address: String.t(),
          blockNumber: String.t(),
          data: String.t(),
          gasPrice: String.t(),
          gasUsed: String.t(),
          logIndex: String.t(),
          timeStamp: String.t(),
          topics: list(String.t()),
          transactionHash: String.t(),
          transactionIndex: String.t()
        }

  @type mined_block :: %{
          blockNumber: String.t(),
          blockReward: String.t(),
          timeStamp: String.t()
        }

  @type mined_uncle :: %{
          blockNumber: String.t(),
          blockReward: String.t(),
          timeStamp: String.t()
        }

  @type transaction :: %{
          blockNumber: String.t(),
          timeStamp: String.t(),
          hash: String.t(),
          nonce: String.t(),
          blockHash: String.t(),
          transactionIndex: String.t(),
          from: String.t(),
          to: String.t(),
          value: String.t(),
          gas: String.t(),
          gasPrice: String.t(),
          isError: String.t(),
          txreceipt_status: String.t(),
          input: String.t(),
          contractAddress: String.t(),
          cumulativeGasUsed: String.t(),
          gasUsed: String.t(),
          confirmations: String.t()
        }

  @type address :: String.t()
  @type addresses :: [address]
  @type token_address :: String.t()
  @type transaction_hash :: String.t()

  @type response(inner) :: {:ok, inner} | {:error, atom()}

  @operators ["and", "or"]

  @get_logs_default_params %{
    address: nil,
    fromBlock: 0,
    toBlock: "latest",
    topic0: nil,
    topic0_1_opr: nil,
    topic1: nil,
    topic1_2_opr: nil,
    topic2: nil,
    topic2_3_opr: nil,
    topic3: nil
  }

  @account_transaction_default_params %{
    startblock: 0,
    endblock: nil,
    sort: "asc",
    page: 1,
    offset: 20
  }

  @blocks_mined_default_params %{
    page: 1,
    offset: 20
  }

  @address_list_max 20

  defguardp is_address(value) when is_binary(value) and binary_part(value, 0, 2) == "0x"

  defguardp is_block(block) when is_integer(block) or block == "latest"

  defguardp is_address_list(addresses) when is_list(addresses) and length(addresses) <= @address_list_max

  #
  # ============================================================================
  # Accounts - https://etherscan.io/apis#accounts
  # ============================================================================
  #

  @doc """
  Get ether balance for a single `address`.

  ## Example

      iex> Etherscan.get_balance("#{@test_address1}")
      {:ok, #{@test_address1_balance}}

  """
  @spec get_balance(address) :: response(non_neg_integer)
  def get_balance(address) when is_address(address) do
    params = %{
      address: address,
      tag: "latest"
    }

    "account"
    |> get("balance", params)
    |> parse()
    |> format_ether()
    |> wrap(:ok)
  end

  def get_balance(_) do
    {:error, :invalid_params}
  end

  @doc """
  Get ether balance for a list of multiple `addresses`, up to a maximum of 20.

  ## Example

      iex> Etherscan.get_balances(["#{@test_address1}", "#{@test_address2}"])
      {:ok, [
        %{"account" => "#{@test_address1}", "balance" => "#{@test_address1_balance}"},
        %{"account" => "#{@test_address2}", "balance" => "#{@test_address2_balance}"}
      ]}

  """
  @spec get_balances(addresses) :: response(map)
  def get_balances([head | _] = addresses) when is_address(head) and is_address_list(addresses) do
    params = %{
      address: Enum.join(addresses, ","),
      tag: "latest"
    }

    "account"
    |> get("balancemulti", params)
    |> parse()
    |> format_balances()
    |> wrap(:ok)
  end

  def get_balances(_) do
    {:error, :invalid_params}
  end

  @doc """
  Get a list of 'Normal' transactions by `address`.

  Returns up to a maximum of the last 10,000 transactions only.

  ## Example

      iex> params = %{
      ...>   page: 1, # Page number
      ...>   offset: 10, # Max records returned
      ...>   sort: "asc", # Sort returned records
      ...>   startblock: 0, # Start block number
      ...>   endblock: 99999999, # End block number
      ...> }
      ...> Etherscan.get_transactions("#{@test_address1}", params)
      {:ok, [
        %{
          "blockNumber" => "0",
          "from" => "GENESIS",
          "value" => "10000000000000000000000"
        },
        ...
      ]}

  """
  @spec get_transactions(address, map) :: response([transaction])
  def get_transactions(address, params \\ %{})

  def get_transactions(address, %{} = params) when is_address(address) do
    params =
      params
      |> merge_params(@account_transaction_default_params)
      |> Map.put(:address, address)

    "account"
    |> get("txlist", params)
    |> parse()
    |> wrap(:ok)
  end

  def get_transactions(_, _) do
    {:error, :invalid_params}
  end

  @doc """
  Get a list of 'Internal' transactions by `address`.

  Returns up to a maximum of the last 10,000 transactions only.

  ## Example

      iex> params = %{
      ...>   page: 1, # Page number
      ...>   offset: 10, # Max records returned
      ...>   sort: "asc", # Sort returned records
      ...>   startblock: 0, # Start block number
      ...>   endblock: 99999999, # End block number
      ...> }
      ...> Etherscan.get_internal_transactions("#{@test_address1}", params)
      {:ok, [%{"blockNumber" => "1959340"}]}

  """
  @spec get_internal_transactions(address, map) :: response([internal_transaction])
  def get_internal_transactions(address, params \\ %{})

  def get_internal_transactions(address, %{} = params) when is_address(address) do
    params =
      params
      |> merge_params(@account_transaction_default_params)
      |> Map.put(:address, address)

    "account"
    |> get("txlistinternal", params)
    |> parse()
    |> wrap(:ok)
  end

  def get_internal_transactions(_, _) do
    {:error, :invalid_params}
  end

  @doc """
  Get a list of 'Internal Transactions' by `transaction_hash`.

  Returns up to a maximum of the last 10,000 transactions only.

  ## Example

      iex> Etherscan.get_internal_transactions_by_hash("#{@test_transaction_hash}")
      {:ok, [
        %{
          "blockNumber" => "1743059",
          "contractAddress" => "",
          "errCode" => "",
          "from" => "0x2cac6e4b11d6b58f6d3c1c9d5fe8faa89f60e5a2",
          "gas" => "2300",
          "gasUsed" => "0",
          "input" => "",
          "isError" => "0",
          "timeStamp" => "1466489498",
          "to" => "0x66a1c3eaf0f1ffc28d209c0763ed0ca614f3b002",
          "type" => "call",
          "value" => "7106740000000000"
        },
        ...
      ]}

  """
  @spec get_internal_transactions_by_hash(transaction_hash) :: response([internal_transaction])
  def get_internal_transactions_by_hash(hash) when is_address(hash) do
    params = %{
      txhash: hash
    }

    "account"
    |> get("txlistinternal", params)
    |> parse()
    |> wrap(:ok)
  end

  def get_internal_transactions_by_hash(_) do
    {:error, :invalid_params}
  end

  @doc """
  Get a list of blocks mined by `address`.

  ## Example

      iex> params = %{
      ...>   page: 1, # Page number
      ...>   offset: 10, # Max records returned
      ...> }
      ...> Etherscan.get_blocks_mined("#{@test_miner_address}", params)
      {:ok, [
        %{
          "blockNumber" => "3462296",
          "timeStamp" => "1491118514",
          "blockReward" => "5194770940000000000"
        },
        ...
      ]}

  """
  @spec get_blocks_mined(address, map) :: response(mined_block)
  def get_blocks_mined(address, params \\ %{})

  def get_blocks_mined(address, %{} = params) when is_address(address) do
    params =
      params
      |> merge_params(@blocks_mined_default_params)
      |> Map.put(:blocktype, "blocks")
      |> Map.put(:address, address)

    "account"
    |> get("getminedblocks", params)
    |> parse()
    |> wrap(:ok)
  end

  def get_blocks_mined(_, _) do
    {:error, :invalid_params}
  end

  @doc """
  Get a list of uncles mined by `address`.

  ## Example

      iex> params = %{
      ...>   page: 1, # Page number
      ...>   offset: 10, # Max records returned
      ...> }
      ...> Etherscan.get_uncles_mined("#{@test_miner_address}", params)
      {:ok, [
        %{
          "blockNumber" => "2691795",
          "timeStamp" => "1480077905",
          "blockReward" => "3125000000000000000"
        },
        ...
      ]}

  """
  @spec get_uncles_mined(address, map) :: response([mined_uncle])
  def get_uncles_mined(address, params \\ %{})

  def get_uncles_mined(address, %{} = params) when is_address(address) do
    params =
      params
      |> merge_params(@blocks_mined_default_params)
      |> Map.put(:blocktype, "uncles")
      |> Map.put(:address, address)

    "account"
    |> get("getminedblocks", params)
    |> parse()
    |> wrap(:ok)
  end

  def get_uncles_mined(_, _) do
    {:error, :invalid_params}
  end

  @doc """
  Get the ERC20 token balance of the `address` for token at `token_address`.

  [More Info](https://etherscan.io/apis#tokens)

  ## Example

      iex> Etherscan.get_token_balance("#{@test_token_owner}", "#{@test_token_address}")
      {:ok, #{@test_token_address_balance}}

  """
  @spec get_token_balance(address, token_address) :: response(non_neg_integer)
  def get_token_balance(address, token) when is_address(address) and is_address(token) do
    params = %{
      address: address,
      contractaddress: token,
      tag: "latest"
    }

    "account"
    |> get("tokenbalance", params)
    |> parse()
    |> String.to_integer()
    |> wrap(:ok)
  end

  def get_token_balance(_, _) do
    {:error, :invalid_params}
  end

  #
  # ============================================================================
  # Blocks - https://etherscan.io/apis#blocks
  # ============================================================================
  #

  @doc """
  Get block and uncle rewards by `block_number`.

  ## Example

      iex> Etherscan.get_block_and_uncle_rewards(#{@test_block_number})
      {:ok, %{
        "blockNumber" => "2165403",
        "blockMiner" => "0x13a06d3dfe21e0db5c016c03ea7d2509f7f8d1e3",
        "blockReward" => "5314181600000000000",
        "timeStamp" => "1472533979",
        "uncleInclusionReward" => "312500000000000000",
        "uncles" => [
          %{"blockreward" => "3750000000000000000", "miner" => "0xbcdfc35b86bedf72f0cda046a3c16829a2ef41d1", "unclePosition" => "0"},
          %{"blockreward" => "3750000000000000000", "miner" => "0x0d0c9855c722ff0c78f21e43aa275a5b8ea60dce", "unclePosition" => "1"}
        ]
      }}

  """
  @spec get_block_and_uncle_rewards(block :: non_neg_integer) :: response(block_reward)
  def get_block_and_uncle_rewards(block) when is_integer(block) and block >= 0 do
    params = %{
      blockno: block
    }

    "block"
    |> get("getblockreward", params)
    |> parse()
    |> wrap(:ok)
  end

  def get_block_and_uncle_rewards(_) do
    {:error, :invalid_params}
  end

  #
  # ============================================================================
  # Contracts - https://etherscan.io/apis#contracts
  # ============================================================================
  #

  @doc """
  Get contract ABI for contracts with verified source code, by `address`.

  ## Example

      iex> Etherscan.get_contract_abi("#{@test_contract_address}")
      {:ok, [%{"name" => "proposals", "constant" => true}]}

  """
  @spec get_contract_abi(address) :: response([map])
  def get_contract_abi(address) when is_address(address) do
    params = %{
      address: address
    }

    "contract"
    |> get("getabi", params)
    |> parse()
    # Decode again. ABI result is JSON
    |> Jason.decode!()
    |> wrap(:ok)
  end

  def get_contract_abi(_) do
    {:error, :invalid_params}
  end

  @doc """
  Get contract source code for contacts with verified source code

      iex> Etherscan.get_contract_source("#{@test_contract_address}")
      {:ok, %{
        "CompilerVersion" => "v0.3.1-2016-04-12-3ad5e82",
        "ConstructorArguments" => "000000000000000000000000da4a4626d3e16e094de3225a751aab7128e965260000000000000000000000004a574510c7014e4ae985403536074abe582adfc80000000000000000000000000000000000000000000000001bc16d674ec80000000000000000000000000000000000000000000000000a968163f0a57b4000000000000000000000000000000000000000000000000000000000000057495e100000000000000000000000000000000000000000000000000000000000000000",
        "ContractName" => "DAO",
        "Library" => "",
        "OptimizationUsed" => "1",
        "Runs" => "200"
      }}

  """
  @spec get_contract_source(address) :: response([map])
  def get_contract_source(address) when is_address(address) do
    params = %{
      address: address
    }

    "contract"
    |> get("getsourcecode", params)
    |> parse()
    |> wrap(:ok)
  end

  def get_contract_source(_) do
    {:error, :invalid_params}
  end

  #
  # ============================================================================
  # Logs - https://etherscan.io/apis#logs
  # ============================================================================
  #

  @doc """
  Returns a list of valid topic operators for `get_logs/1`.

  ## Example

      iex> Etherscan.operators()
      #{@operators |> inspect()}

  """
  @spec operators :: list(String.t())
  def operators, do: @operators

  @doc """
  An alternative API to the native eth_getLogs.

  See `operators/0` for all valid topic operators.

  `params[fromBlock|toBlock]` can be a block number or the string `"latest"`.

  Either the `address` or `topic(x)` params are required.

  For API performance and security considerations, **only the first 1000 results
  are returned.**

  ## Example

      iex> params = %{
      ...>   address: "#{@test_topic_address}", # Ethereum blockchain address
      ...>   fromBlock: 0, # Start block number
      ...>   toBlock: "latest", # End block number
      ...>   topic0: "#{@test_topic_0}", # The first topic filter
      ...>   topic0_1_opr: "and", # The topic operator between topic0 and topic1
      ...>   topic1: "", # The second topic filter
      ...>   topic1_2_opr: "and", # The topic operator between topic1 and topic2
      ...>   topic2: "", # The third topic filter
      ...>   topic2_3_opr: "and", # The topic operator between topic2 and topic3
      ...>   topic3: "", # The fourth topic filter
      ...> }
      ...> Etherscan.get_logs(params)
      {:ok, [
        %{
          "address" => "#{@test_topic_address}",
          "topics" => [#{@test_topic_0}, ...],
        },
        ...
      ]}

  """
  @spec get_logs(map) :: response([log])
  def get_logs(%{address: address}) when not is_address(address), do: {:error, :invalid_params}
  def get_logs(%{fromBlock: block}) when not is_block(block), do: {:error, :invalid_params}
  def get_logs(%{toBlock: block}) when not is_block(block), do: {:error, :invalid_params}
  def get_logs(%{topic0_1_opr: op}) when op not in @operators, do: {:error, :invalid_params}
  def get_logs(%{topic1_2_opr: op}) when op not in @operators, do: {:error, :invalid_params}
  def get_logs(%{topic2_3_opr: op}) when op not in @operators, do: {:error, :invalid_params}

  def get_logs(params) when is_map(params) do
    params = merge_params(params, @get_logs_default_params)

    "logs"
    |> get("getLogs", params)
    |> parse()
    |> wrap(:ok)
  end

  def get_logs(_) do
    {:error, :invalid_params}
  end

  #
  # ============================================================================
  # Stats - https://etherscan.io/apis#stats
  # ============================================================================
  #

  @doc """
  Get total supply of ether.

  ## Example

      iex> Etherscan.get_eth_supply()
      {:ok, #{@test_eth_supply}}

  """
  @spec get_eth_supply :: response(non_neg_integer)
  def get_eth_supply do
    "stats"
    |> get("ethsupply")
    |> parse()
    |> format_ether()
    |> wrap(:ok)
  end

  @doc """
  Get ether price.

  ## Example

      iex> Etherscan.get_eth_price()
      {:ok, %{"ethbtc" => #{@test_eth_btc_price}, "ethusd" => #{@test_eth_usd_price}}}

  """
  @spec get_eth_price :: response(map)
  def get_eth_price do
    "stats"
    |> get("ethprice")
    |> parse()
    |> wrap(:ok)
  end

  @doc """
  Get total supply of ERC20 token, by `token_address`.

  [More Info](https://etherscan.io/apis#tokens)

  ## Example

      iex> Etherscan.get_token_supply("#{@test_token_address}")
      {:ok, #{@test_token_supply}}

  """
  @spec get_token_supply(token_address) :: response(non_neg_integer)
  def get_token_supply(address) when is_address(address) do
    params = %{
      contractaddress: address
    }

    "stats"
    |> get("tokensupply", params)
    |> parse()
    |> String.to_integer()
    |> wrap(:ok)
  end

  def get_token_supply(_) do
    {:error, :invalid_params}
  end

  #
  # ============================================================================
  # Transactions - https://etherscan.io/apis#transactions
  # ============================================================================
  #

  @doc """
  Check contract execution status by `transaction_hash`.

  ## Examples

      iex> Etherscan.get_contract_execution_status("#{@test_transaction_hash}")
      {:ok, %{"errDescription" => "", "isError" => "0"}}

      iex> Etherscan.get_contract_execution_status("#{@test_invalid_transaction_hash}")
      {:ok, %{"errDescription" => "Bad jump destination", "isError" => "1"}}

  """
  @spec get_contract_execution_status(transaction_hash) :: response(contract_status)
  def get_contract_execution_status(hash) when is_address(hash) do
    params = %{
      txhash: hash
    }

    "transaction"
    |> get("getstatus", params)
    |> parse()
    |> wrap(:ok)
  end

  def get_contract_execution_status(_) do
    {:error, :invalid_params}
  end

  @doc """
  Check transaction receipt status by `transaction_hash`.

  Pre-Byzantium fork transactions return null/empty value.
  """
  @spec get_transaction_receipt_status(transaction_hash) :: response(map)
  def get_transaction_receipt_status(hash) when is_address(hash) do
    params = %{
      txhash: hash
    }

    "transaction"
    |> get("gettxreceiptstatus", params)
    |> parse()
    |> wrap(:ok)
  end

  def get_transaction_receipt_status(_) do
    {:error, :invalid_params}
  end

  #
  # ============================================================================
  # Helper Functions
  # ============================================================================
  #

  # Wraps a value inside a tagged Tuple using the provided tag.
  @spec wrap(term, atom) :: {atom, term}
  defp wrap(term, tag) when is_atom(tag), do: {tag, term}

  @spec format_ether(binary) :: binary
  defp format_ether(balance), do: Util.convert(balance, as: :ether)

  @spec format_balances([map]) :: [map]
  defp format_balances(accounts) do
    Enum.map(accounts, fn account ->
      Map.update!(account, "balance", &format_ether/1)
    end)
  end

  @spec merge_params(map, map) :: map
  defp merge_params(params, default) do
    default
    |> Map.merge(params)
    |> Map.take(default |> Map.keys())
  end
end
