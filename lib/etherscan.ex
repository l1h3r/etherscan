defmodule Etherscan do
  @moduledoc """
  Documentation for Etherscan.
  """

  defmacrop is_address(address) do
    quote do
      unquote(address) |> is_binary()
    end
  end

  defmacrop is_transaction(transaction_hash) do
    quote do
      unquote(transaction_hash) |> is_binary()
    end
  end

  @api_base "https://api.etherscan.io/api"
  @api_key ""

  @account_transaction_def_params %{
    startblock: 0,
    endblock: nil,
    sort: "asc",
    page: 1,
    offset: 20
  }

  @blocks_mined_def_params %{
    page: 1,
    offset: 20
  }

  #
  # Accounts. See - https://etherscan.io/apis#accounts
  #

  @doc """
  Get ether balance for a single `address`. Balance is returned in wei.
  """
  @spec get_balance(address :: String.t) :: {:ok, non_neg_integer} | {:error, atom}
  def get_balance(address) when is_address(address) do
    params = %{
      tag: "latest",
      address: address
    }

    "account"
    |> call_api("balance", params)
    |> parse_response()
    |> String.to_integer()
    |> format_response()
  end
  def get_balance(_), do: {:error, :invalid_address}

  @doc """
  Get ether balance for a list of multiple `addresses`, up to a
  maximum of 20. Balances are returned in wei.
  """
  @spec get_balances(addresses :: list(String.t)) :: {:ok, map} | {:error, atom}
  def get_balances([head | _] = addresses) when
    is_list(addresses) and
    is_address(head) and
    length(addresses) <= 20
  do
    params = %{
      tag: "latest",
      address: Enum.join(addresses, ",")
    }

    "account"
    |> call_api("balancemulti", params)
    |> parse_response()
    |> Enum.map(fn account ->
      Map.update(account, "balance", 0, &String.to_integer/1)
    end)
    |> format_response()
  end
  def get_balances(_), do: {:error, :invalid_addresses}

  @doc """
  Get a list of 'Normal' transactions by `address`. Returns up to a maximum
  of the last 10,000 transactions only.

  *BETA*

  ```
  params = %{
    page: 1, # Page number
    offset: 10, # Max records returned
    sort: "asc", # Sort returned records
    startblock: 0, # Start block number
    endblock: 99999999 # End block number
  }
  ```
  """
  @spec get_transactions(address :: String.t, params :: map) :: {:ok, list(Etherscan.Block.t)} | {:error, atom}
  def get_transactions(address, params \\ %{})
  def get_transactions(address, params) when is_address(address) do
    params =
      @account_transaction_def_params
      |> Map.merge(params)
      |> Map.take(@account_transaction_def_params |> Map.keys())
      |> Map.put(:address, address)

    "account"
    |> call_api("txlist", params)
    |> parse_response(as: %{"result" => [%Etherscan.Block{}]})
    |> format_response()
  end
  def get_transactions(_, _), do: {:error, :invalid_address}

  @doc """
  Get a list of 'Internal' transactions by `address`. Returns up to a maximum
  of the last 10,000 transactions only.

  *BETA*

  ```
  params = %{
    page: 1, # Page number
    offset: 10, # Max records returned
    sort: "asc", # Sort returned records
    startblock: 0, # Start block number
    endblock: 99999999 # End block number
  }
  ```
  """
  @spec get_internal_transactions(address :: String.t, params :: map) :: {:ok, list(Etherscan.Block.t)} | {:error, atom}
  def get_internal_transactions(address, params \\ %{})
  def get_internal_transactions(address, params) when is_address(address) do
    params =
      @account_transaction_def_params
      |> Map.merge(params)
      |> Map.take(@account_transaction_def_params |> Map.keys())
      |> Map.put(:address, address)

    "account"
    |> call_api("txlistinternal", params)
    |> parse_response(as: %{"result" => [%Etherscan.Block{}]})
    |> format_response()
  end
  def get_internal_transactions(_, _), do: {:error, :invalid_address}

  @doc """
  Get a list of 'Internal Transactions' by `transaction_hash`. Returns up to
  a maximum of the last 10,000 transactions only.
  """
  @spec get_internal_transactions_by_hash(transaction_hash :: String.t) :: {:ok, list(Etherscan.Block.t)} | {:error, atom}
  def get_internal_transactions_by_hash(transaction_hash) when is_transaction(transaction_hash) do
    params = %{
      txhash: transaction_hash
    }

    "account"
    |> call_api("txlistinternal", params)
    |> parse_response(as: %{"result" => [%Etherscan.Block{}]})
    |> format_response()
  end
  def get_internal_transactions_by_hash(_), do: {:error, :invalid_transaction_hash}

  @doc """
  Get a list of blocks mined by `address`.

  ```
  params = %{
    page: 1, # Page number
    offset: 10 # Max records returned
  }
  ```
  """
  @spec get_blocks_mined(address :: String.t, params :: map) :: {:ok, list(Etherscan.Block.t)} | {:error, atom}
  def get_blocks_mined(address, params \\ %{})
  def get_blocks_mined(address, params) when is_address(address) do
    params =
      @blocks_mined_def_params
      |> Map.merge(params)
      |> Map.take(@blocks_mined_def_params |> Map.keys())
      |> Map.put(:blocktype, "blocks")
      |> Map.put(:address, address)

    "account"
    |> call_api("getminedblocks", params)
    |> parse_response(as: %{"result" => [%Etherscan.MinedBlock{}]})
    |> format_response()
  end
  def get_blocks_mined(_, _), do: {:error, :invalid_address}

  @doc """
  Get a list of uncles mined by `address`.

  ```
  params = %{
    page: 1, # Page number
    offset: 10 # Max records returned
  }
  ```
  """
  @spec get_uncles_mined(address :: String.t, params :: map) :: {:ok, list(Etherscan.Block.t)} | {:error, atom}
  def get_uncles_mined(address, params \\ %{})
  def get_uncles_mined(address, params) when is_address(address) do
    params =
      @blocks_mined_def_params
      |> Map.merge(params)
      |> Map.take(@blocks_mined_def_params |> Map.keys())
      |> Map.put(:blocktype, "uncles")
      |> Map.put(:address, address)

    "account"
    |> call_api("getminedblocks", params)
    |> parse_response(as: %{"result" => [%Etherscan.MinedUncle{}]})
    |> format_response()
  end
  def get_uncles_mined(_, _), do: {:error, :invalid_address}

  #
  # Blocks. See - https://etherscan.io/apis#blocks
  #

  @doc """
  Get block and uncle rewards by `block_number`.

  *BETA*
  """
  @spec get_block_and_uncle_rewards(block_number :: non_neg_integer) :: {:ok, Etherscan.BlockReward.t} :: {:error, atom}
  def get_block_and_uncle_rewards(block_number) when is_integer(block_number) and block_number >= 0 do
    params = %{
      blockno: block_number
    }

    "block"
    |> call_api("getblockreward", params)
    |> parse_response(as: %{"result" => %Etherscan.BlockReward{uncles: [%Etherscan.BlockRewardUncle{}]}})
    |> format_response()
  end
  def get_block_and_uncle_rewards(_), do: {:error, :invalid_block_number}

  #
  # Contracts. See - https://etherscan.io/apis#contracts
  #

  @doc """
  Get contract ABI for contracts with verified source code, by `address`.

  [More Info](https://etherscan.io/contractsVerified)
  """
  @spec get_contract_abi(address :: String.t) :: {:ok, list} | {:error, atom}
  def get_contract_abi(address) when is_address(address) do
    params = %{
      address: address
    }

    "contract"
    |> call_api("getabi", params)
    |> parse_response()
    |> Poison.decode!() # Decode again. ABI result is JSON
    |> format_response()
  end
  def get_contract_abi(_), do: {:error, :invalid_address}

  #
  # tokens. See - https://etherscan.io/apis#tokens
  #

  @doc """
  Get the ERC20 token balance of the `address` for token at `token_address`.
  """
  @spec get_token_balance(address :: String.t, token_address :: String.t) :: {:ok, non_neg_integer} | {:error, atom}
  def get_token_balance(address, token_address) when is_address(address) and is_address(token_address) do
    params = %{
      tag: "latest",
      address: address,
      contractaddress: token_address
    }

    "account"
    |> call_api("tokenbalance", params)
    |> parse_response()
    |> String.to_integer()
    |> format_response()
  end
  def get_token_balance(address, token_address) when not is_address(address) and is_address(token_address), do: {:error, :invalid_address}
  def get_token_balance(address, token_address) when not is_address(token_address) and is_address(address), do: {:error, :invalid_token_address}
  def get_token_balance(_, _), do: {:error, :invalid_address_and_token_address}

  @doc """
  Get total supply of ERC20 token, by `token_address`.
  """
  @spec get_token_supply(token_address :: String.t) :: {:ok, non_neg_integer} | {:error, atom}
  def get_token_supply(token_address) when is_address(token_address) do
    params = %{
      contractaddress: token_address
    }

    "stats"
    |> call_api("tokensupply", params)
    |> parse_response()
    |> String.to_integer()
    |> format_response()
  end
  def get_token_supply(_), do: {:error, :invalid_token_address}

  #
  # Stats. See - https://etherscan.io/apis#stats
  #

  @doc """
  Get total supply of ether. Total supply is returned in wei.
  """
  @spec get_eth_supply :: {:ok, non_neg_integer}
  def get_eth_supply do
    "stats"
    |> call_api("ethsupply")
    |> parse_response()
    |> String.to_integer()
    |> format_response()
  end

  @doc """
  Get ether price.
  """
  @spec get_eth_price :: {:ok, map}
  def get_eth_price do
    "stats"
    |> call_api("ethprice")
    |> parse_response()
    |> format_response()
  end

  #
  # Transactions. See - https://etherscan.io/apis#transactions
  #

  @doc """
  Check contract execution status (if there was an error during
  contract execution) by `transaction_hash`.

  *BETA*
  """
  @spec get_contract_execution_status(transaction_hash :: String.t) :: {:ok, map} | {:error, atom}
  def get_contract_execution_status(transaction_hash) when is_transaction(transaction_hash) do
    params = %{
      txhash: transaction_hash
    }

    "transaction"
    |> call_api("getstatus", params)
    |> parse_response()
    |> format_response()
  end
  def get_contract_execution_status(_), do: {:error, :invalid_transaction_hash}

  #
  # Api
  #

  defp call_api(module, action, params \\ %{}) do
    build_query(module, action, params)
    |> build_path()
    |> HTTPoison.get!([], [timeout: 20000, recv_timeout: 20000])
    |> Map.get(:body)
  end

  defp build_path(query), do: @api_base <> "?" <> query

  defp build_query(module, action, params) do
    params
    |> Map.put(:action, action)
    |> Map.put(:module, module)
    |> Map.put(:apikey, @api_key)
    |> URI.encode_query()
  end

  defp parse_response(response, opts \\ []) do
    response
    |> Poison.decode!(opts)
    |> Map.get("result")
  end

  defp format_response(response) do
    {:ok, response}
  end

end
