defmodule Etherscan.ProxyTest do
  use ExUnit.Case
  use Etherscan.Constants

  defp assert_transaction(fun) do
    assert {:ok, %{
      "blockHash" => <<_::binary>>,
      "blockNumber" => <<_::binary>>,
      "from" => <<_::binary>>,
      "gas" => <<_::binary>>,
      "gasPrice" => <<_::binary>>,
      "hash" => <<_::binary>>,
      "input" => <<_::binary>>,
      "nonce" => <<_::binary>>,
      "r" => <<_::binary>>,
      "s" => <<_::binary>>,
      "to" => <<_::binary>>,
      "transactionIndex" => <<_::binary>>,
      "v" => <<_::binary>>,
      "value" => <<_::binary>>
    }} = fun.()
  end

  describe "eth_block_number/0" do
    @tag :api
    test "returns the most recent block number" do
      assert {:ok, <<_::binary>>} = Etherscan.eth_block_number()
    end
  end

  describe "eth_get_block_by_number/1" do
    @tag :api
    test "with valid tag" do
      assert {:ok, %{
        "difficulty" => <<_::binary>>,
        "extraData" => <<_::binary>>,
        "gasLimit" => <<_::binary>>,
        "gasUsed" => <<_::binary>>,
        "hash" => <<_::binary>>,
        "logsBloom" => <<_::binary>>,
        "miner" => <<_::binary>>,
        "mixHash" => <<_::binary>>,
        "nonce" => <<_::binary>>,
        "number" => <<_::binary>>,
        "parentHash" => <<_::binary>>,
        "receiptsRoot" => <<_::binary>>,
        "sha3Uncles" => <<_::binary>>,
        "size" => <<_::binary>>,
        "stateRoot" => <<_::binary>>,
        "timestamp" => <<_::binary>>,
        "totalDifficulty" => <<_::binary>>,
        "transactions" => _,
        "transactionsRoot" => <<_::binary>>,
        "uncles" => _
      }} = Etherscan.eth_get_block_by_number(@test_proxy_block_tag)
    end

    test "with invalid tag" do
      assert {:error, :invalid_params} = Etherscan.eth_get_block_by_number(nil)
    end
  end

  describe "eth_get_uncle_by_block_number_and_index/2" do
    @tag :api
    test "with valid tag and index" do
      assert {:ok, %{
        "difficulty" => <<_::binary>>,
        "extraData" => <<_::binary>>,
        "gasLimit" => <<_::binary>>,
        "gasUsed" => <<_::binary>>,
        "hash" => <<_::binary>>,
        "logsBloom" => <<_::binary>>,
        "miner" => <<_::binary>>,
        "mixHash" => <<_::binary>>,
        "nonce" => <<_::binary>>,
        "number" => <<_::binary>>,
        "parentHash" => <<_::binary>>,
        "receiptsRoot" => <<_::binary>>,
        "sha3Uncles" => <<_::binary>>,
        "size" => <<_::binary>>,
        "stateRoot" => <<_::binary>>,
        "timestamp" => <<_::binary>>,
        "totalDifficulty" => nil,
        "transactionsRoot" => <<_::binary>>,
        "uncles" => _
      }} = Etherscan.eth_get_uncle_by_block_number_and_index(@test_proxy_uncle_tag, @test_proxy_index)
    end

    test "with invalid tag" do
      assert {:error, :invalid_params} = Etherscan.eth_get_uncle_by_block_number_and_index(nil, @test_proxy_index)
    end

    test "with invalid index" do
      assert {:error, :invalid_params} = Etherscan.eth_get_uncle_by_block_number_and_index(@test_proxy_uncle_tag, nil)
    end

    test "with invalid tag and index" do
      assert {:error, :invalid_params} = Etherscan.eth_get_uncle_by_block_number_and_index(nil, nil)
    end
  end

  describe "eth_get_block_transaction_count_by_number/1" do
    @tag :api
    test "with valid tag" do
      assert {:ok, <<_::binary>>} = Etherscan.eth_get_block_transaction_count_by_number(@test_proxy_transaction_tag)
    end

    test "with invalid tag" do
      assert {:error, :invalid_params} = Etherscan.eth_get_block_transaction_count_by_number(nil)
    end
  end

  describe "eth_get_transaction_by_hash/1" do
    @tag :api
    test "with valid transaction hash" do
      assert_transaction(fn ->
        Etherscan.eth_get_transaction_by_hash(@test_proxy_transaction_hash)
      end)
    end

    test "with invalid transaction hash" do
      assert {:error, :invalid_params} = Etherscan.eth_get_transaction_by_hash(nil)
    end
  end

  describe "eth_get_transaction_by_block_number_and_index/2" do
    test "with valid tag and index" do
      assert_transaction(fn ->
        Etherscan.eth_get_transaction_by_block_number_and_index(@test_proxy_block_tag, @test_proxy_index)
      end)
    end

    test "with invalid tag" do
      assert {:error, :invalid_params} = Etherscan.eth_get_transaction_by_block_number_and_index(nil, @test_proxy_index)
    end

    test "with invalid index" do
      assert {:error, :invalid_params} = Etherscan.eth_get_transaction_by_block_number_and_index(@test_proxy_block_tag, nil)
    end

    test "with invalid tag and index" do
      assert {:error, :invalid_params} = Etherscan.eth_get_transaction_by_block_number_and_index(nil, nil)
    end
  end

  describe "eth_get_transaction_count/1" do
    @tag :api
    test "with valid address" do
      assert {:ok, <<_::binary>>} = Etherscan.eth_get_transaction_count(@test_proxy_address)
    end

    test "with invalid address" do
      assert {:error, :invalid_params} = Etherscan.eth_get_transaction_count(nil)
    end
  end

  describe "eth_send_raw_transaction/1" do
    # @tag :api
    # @tag :wip
    # test "with valid hex" do
    #   assert {:ok, %{"code" => -32000}} = Etherscan.eth_send_raw_transaction(@test_proxy_hex)
    # end

    test "with invalid hex" do
      assert {:error, :invalid_params} = Etherscan.eth_send_raw_transaction(nil)
    end
  end

  describe "eth_get_transaction_receipt/1" do
    @tag :api
    test "with valid transaction hash" do
      assert {:ok, %{
        "blockHash" => <<_::binary>>,
        "blockNumber" => <<_::binary>>,
        "contractAddress" => nil,
        "cumulativeGasUsed" => <<_::binary>>,
        "from" => <<_::binary>>,
        "gasUsed" => <<_::binary>>,
        "logs" => _,
        "logsBloom" => <<_::binary>>,
        "root" => <<_::binary>>,
        "to" => <<_::binary>>,
        "transactionHash" => <<_::binary>>,
        "transactionIndex" => <<_::binary>>
      }} = Etherscan.eth_get_transaction_receipt(@test_proxy_transaction_hash)
    end

    test "with invalid transaction hash" do
      assert {:error, :invalid_params} = Etherscan.eth_get_transaction_receipt(nil)
    end
  end

  describe "eth_call/3" do
    @tag :api
    test "with valid to and data" do
      assert {:ok, <<_::binary>>} = Etherscan.eth_call(@test_proxy_to, @test_proxy_data)
    end

    test "with invalid to" do
      assert {:error, :invalid_params} = Etherscan.eth_call(nil, @test_proxy_data)
    end

    test "with invalid data" do
      assert {:error, :invalid_params} = Etherscan.eth_call(@test_proxy_to, nil)
    end

    test "with invalid to and data" do
      assert {:error, :invalid_params} = Etherscan.eth_call(nil, nil)
    end
  end

  describe "eth_get_code/2" do
    @tag :api
    test "with valid address and tag" do
      assert {:ok, <<_::binary>>} = Etherscan.eth_get_code(@test_proxy_code_address, "latest")
    end

    test "with invalid address" do
      assert {:error, :invalid_params} = Etherscan.eth_get_code(nil, "latest")
    end

    test "with invalid tag" do
      assert {:error, :invalid_params} = Etherscan.eth_get_code(@test_proxy_address, nil)
    end

    test "with invalid address and tag" do
      assert {:error, :invalid_params} = Etherscan.eth_get_code(nil, nil)
    end
  end

  describe "eth_get_storage_at/2" do
    test "with valid address and position" do
      assert {:ok, <<_::binary>>} = Etherscan.eth_get_storage_at(@test_proxy_storage_address, @test_proxy_storage_position)
    end

    test "with invalid address" do
      assert {:error, :invalid_params} = Etherscan.eth_get_storage_at(nil, @test_proxy_storage_position)
    end

    test "with invalid position" do
      assert {:error, :invalid_params} = Etherscan.eth_get_storage_at(@test_proxy_storage_address, nil)
    end

    test "with invalid address and position" do
      assert {:error, :invalid_params} = Etherscan.eth_get_storage_at(nil, nil)
    end
  end

  describe "eth_gas_price/0" do
    @tag :api
    test "returns the current price per gas" do
      assert {:ok, <<_::binary>>} = Etherscan.eth_gas_price()
    end
  end

  describe "eth_estimate_gas/1" do
    # @tag :api
    # @tag :wip
    # test "with valid params" do
    #   params = %{
    #     to: @test_proxy_estimate_to,
    #     value: @test_proxy_value,
    #     gasPrice: @test_proxy_gas_price,
    #     gas: @test_proxy_gas
    #   }

    #   assert {:ok, %{"code" => -32602}} = Etherscan.eth_estimate_gas(params)
    # end

    test "with invalid params" do
      assert {:error, :invalid_params} = Etherscan.eth_estimate_gas(nil)
    end
  end
end
