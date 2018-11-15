defmodule EtherscanTest do
  use ExUnit.Case
  use Etherscan.Constants

  describe "get_balance/1" do
    @tag :api
    test "with valid address" do
      assert {:ok, <<_::binary>>} = Etherscan.get_balance(@test_wallet_1)
    end

    test "with invalid address" do
      assert {:error, :invalid_params} = Etherscan.get_balance("foo")
    end
  end

  describe "get_balances/1" do
    @tag :api
    test "with valid addresses" do
      addresses = [
        @test_wallet_1,
        @test_wallet_2,
        @test_wallet_3
      ]

      assert {:ok, [
        %{"account" => "0x" <> _, "balance" => <<_::binary>>},
        %{"account" => "0x" <> _, "balance" => <<_::binary>>},
        %{"account" => "0x" <> _, "balance" => <<_::binary>>}
      ]} = Etherscan.get_balances(addresses)
    end

    test "with invalid addresses" do
      assert {:error, :invalid_params} = Etherscan.get_balances(["foo"])
    end
  end

  describe "get_transactions/2" do
    @tag :api
    test "with valid address" do
      assert {:ok, [%{
        "blockHash" => <<_::binary>>,
        "blockNumber" => <<_::binary>>,
        "confirmations" => <<_::binary>>,
        "contractAddress" => <<_::binary>>,
        "cumulativeGasUsed" => <<_::binary>>,
        "from" => <<_::binary>>,
        "gas" => <<_::binary>>,
        "gasPrice" => <<_::binary>>,
        "gasUsed" => <<_::binary>>,
        "hash" => <<_::binary>>,
        "input" => <<_::binary>>,
        "isError" => <<_::binary>>,
        "nonce" => <<_::binary>>,
        "timeStamp" => <<_::binary>>,
        "to" => <<_::binary>>,
        "transactionIndex" => <<_::binary>>,
        "txreceipt_status" => <<_::binary>>,
        "value" => <<_::binary>>
      } | _]} = Etherscan.get_transactions(@test_wallet_1)
    end

    @tag :api
    test "with startblock" do
      assert {:ok, _} = Etherscan.get_transactions(@test_wallet_1, %{startblock: 500_000})
    end

    @tag :api
    test "with endblock" do
      assert {:ok, _} = Etherscan.get_transactions(@test_wallet_1, %{endblock: 195_000})
    end

    @tag :api
    test "with offset" do
      assert {:ok, _} = Etherscan.get_transactions(@test_wallet_1, %{offset: 5})
    end

    @tag :api
    test "with page" do
      assert {:ok, _} = Etherscan.get_transactions(@test_wallet_1, %{page: 2})
    end

    @tag :api
    test "with sort" do
      assert {:ok, _} = Etherscan.get_transactions(@test_wallet_1, %{sort: "desc"})
    end

    test "with invalid address" do
      assert {:error, :invalid_params} = Etherscan.get_transactions("foo")
    end
  end

  describe "get_internal_transactions/2" do
    @tag :api
    test "with valid address" do
      assert {:ok, [%{
        "blockNumber" => <<_::binary>>,
        "contractAddress" => <<_::binary>>,
        "errCode" => <<_::binary>>,
        "from" => <<_::binary>>,
        "gas" => <<_::binary>>,
        "gasUsed" => <<_::binary>>,
        "hash" => <<_::binary>>,
        "input" => <<_::binary>>,
        "isError" => <<_::binary>>,
        "timeStamp" => <<_::binary>>,
        "to" => <<_::binary>>,
        "traceId" => <<_::binary>>,
        "type" => <<_::binary>>,
        "value" => <<_::binary>>
      } | _]} = Etherscan.get_internal_transactions(@test_wallet_1)
    end

    @tag :api
    test "with startblock" do
      assert {:ok, _} = Etherscan.get_internal_transactions(@test_wallet_1, %{startblock: 1_960_000})
    end

    @tag :api
    test "with endblock" do
      assert {:ok, _} = Etherscan.get_internal_transactions(@test_wallet_1, %{endblock: 1_960_000})
    end

    @tag :api
    test "with offset" do
      assert {:ok, _} = Etherscan.get_internal_transactions(@test_wallet_1, %{offset: 2})
    end

    @tag :api
    test "with page" do
      assert {:ok, _} = Etherscan.get_internal_transactions(@test_wallet_1, %{offset: 1, page: 2})
    end

    @tag :api
    test "with sort" do
      assert {:ok, _} = Etherscan.get_internal_transactions(@test_wallet_1, %{sort: "desc"})
    end

    test "with invalid address" do
      assert {:error, :invalid_params} = Etherscan.get_internal_transactions("foo")
    end
  end

  describe "get_internal_transactions_by_hash/1" do
    @tag :api
    test "with valid transaction hash" do
      assert {:ok, [%{
        "blockNumber" => <<_::binary>>,
        "contractAddress" => <<_::binary>>,
        "errCode" => <<_::binary>>,
        "from" => <<_::binary>>,
        "gas" => <<_::binary>>,
        "gasUsed" => <<_::binary>>,
        "input" => <<_::binary>>,
        "isError" => <<_::binary>>,
        "timeStamp" => <<_::binary>>,
        "to" => <<_::binary>>,
        "type" => <<_::binary>>,
        "value" => <<_::binary>>
      } | _]} = Etherscan.get_internal_transactions_by_hash(@test_transaction_success)
    end

    test "with invalid transaction hash" do
      assert {:error, :invalid_params} = Etherscan.get_internal_transactions_by_hash("foo")
    end
  end

  describe "get_blocks_mined/2" do
    @tag :api
    test "with valid address" do
      assert {:ok, [%{
        "blockNumber" => <<_::binary>>,
        "blockReward" => <<_::binary>>,
        "timeStamp" => <<_::binary>>
      } | _]} = Etherscan.get_blocks_mined(@test_miner)
    end

    @tag :api
    test "with offset" do
      assert {:ok, _} = Etherscan.get_blocks_mined(@test_miner, %{offset: 8})
    end

    @tag :api
    test "with page" do
      assert {:ok, _} = Etherscan.get_blocks_mined(@test_miner, %{offset: 4, page: 3})
    end

    test "with invalid address" do
      assert {:error, :invalid_params} = Etherscan.get_blocks_mined("foo")
    end
  end

  describe "get_uncles_mined/2" do
    @tag :api
    test "with valid address" do
      assert {:ok, [%{
        "blockNumber" => <<_::binary>>,
        "blockReward" => <<_::binary>>,
        "timeStamp" => <<_::binary>>
      } | _]} = Etherscan.get_uncles_mined(@test_miner)
    end

    @tag :api
    test "with offset" do
      assert {:ok, _} = Etherscan.get_uncles_mined(@test_miner, %{offset: 3})
    end

    @tag :api
    test "with page" do
      assert {:ok, _} = Etherscan.get_uncles_mined(@test_miner, %{offset: 3, page: 2})
    end

    test "with invalid address" do
      assert {:error, :invalid_params} = Etherscan.get_uncles_mined("foo")
    end
  end

  describe "get_token_balance/2" do
    @tag :api
    test "with valid address and token address" do
      assert {:ok, <<_::binary>>} = Etherscan.get_token_balance(@test_token_owner, @test_token)
    end

    test "with invalid address" do
      assert {:error, :invalid_params} = Etherscan.get_token_balance("foo", @test_token)
    end

    test "with invalid token address" do
      assert {:error, :invalid_params} = Etherscan.get_token_balance(@test_token_owner, "foo")
    end

    test "with invalid address and invalid token address" do
      assert {:error, :invalid_params} = Etherscan.get_token_balance("foo", "foo")
    end
  end

  describe "get_block_and_uncle_rewards/1" do
    @tag :api
    test "with valid block number" do
      assert {:ok, %{
        "blockMiner" => <<_::binary>>,
        "blockNumber" => <<_::binary>>,
        "blockReward" => <<_::binary>>,
        "timeStamp" => <<_::binary>>,
        "uncleInclusionReward" => <<_::binary>>,
        "uncles" => [%{
          "blockreward" => <<_::binary>>,
          "miner" => <<_::binary>>,
          "unclePosition" => <<_::binary>>
        } | _]
      }} = Etherscan.get_block_and_uncle_rewards(@test_block)
    end

    test "with invalid block number" do
      assert {:error, :invalid_params} = Etherscan.get_block_and_uncle_rewards("foo")
    end
  end

  describe "get_contract_abi/1" do
    @tag :api
    test "with valid address" do
      assert {:ok, [%{
        "constant" => _,
        "inputs" => _,
        "name" => <<_::binary>>,
        "outputs" => _,
        "type" => <<_::binary>>
      } | _]} = Etherscan.get_contract_abi(@test_contract)
    end

    test "with invalid address" do
      assert {:error, :invalid_params} = Etherscan.get_contract_abi("foo")
    end
  end

  describe "get_contract_source/1" do
    @tag :api
    test "with valid address" do
      assert {:ok, [%{
        "ABI" => <<_::binary>>,
        "CompilerVersion" => <<_::binary>>,
        "ConstructorArguments" => <<_::binary>>,
        "ContractName" => <<_::binary>>,
        "Library" => <<_::binary>>,
        "OptimizationUsed" => <<_::binary>>,
        "Runs" => <<_::binary>>,
        "SourceCode" => <<_::binary>>,
        "SwarmSource" => <<_::binary>>
      } | _]} = Etherscan.get_contract_source(@test_contract)
    end

    test "with invalid address" do
      assert {:error, :invalid_params} = Etherscan.get_contract_source("foo")
    end
  end

  describe "get_logs/1" do
    @tag :api
    test "with valid params" do
      params = %{
        address: @test_topic_address,
        topic0: @test_topic_1,
        topic1: @test_topic_2,
        topic0_1_opr: "and"
      }

      assert {:ok, [%{
        "address" => <<_::binary>>,
        "blockNumber" => <<_::binary>>,
        "data" => <<_::binary>>,
        "gasPrice" => <<_::binary>>,
        "gasUsed" => <<_::binary>>,
        "logIndex" => <<_::binary>>,
        "timeStamp" => <<_::binary>>,
        "topics" => [
          <<_::binary>>,
          <<_::binary>>,
          <<_::binary>>
        ],
        "transactionHash" => <<_::binary>>,
        "transactionIndex" => <<_::binary>>
      } | _]} = Etherscan.get_logs(params)
    end

    test "with invalid params" do
      assert {:error, :invalid_params} = Etherscan.get_logs("foo")
    end

    test "with invalid address" do
      assert {:error, :invalid_params} = Etherscan.get_logs(%{address: "foo"})
    end

    test "with invalid fromBlock string" do
      assert {:error, :invalid_params} = Etherscan.get_logs(%{fromBlock: "foo"})
    end

    test "with invalid fromBlock type" do
      assert {:error, :invalid_params} = Etherscan.get_logs(%{fromBlock: nil})
    end

    test "with invalid toBlock string" do
      assert {:error, :invalid_params} = Etherscan.get_logs(%{toBlock: "foo"})
    end

    test "with invalid toBlock type" do
      assert {:error, :invalid_params} = Etherscan.get_logs(%{toBlock: nil})
    end

    test "with invalid topic0_1_opr" do
      assert {:error, :invalid_params} = Etherscan.get_logs(%{topic0_1_opr: "foo"})
    end

    test "with invalid topic1_2_opr" do
      assert {:error, :invalid_params} = Etherscan.get_logs(%{topic1_2_opr: "foo"})
    end

    test "with invalid topic2_3_opr" do
      assert {:error, :invalid_params} = Etherscan.get_logs(%{topic2_3_opr: "foo"})
    end
  end

  describe "get_token_supply/1" do
    @tag :api
    test "with valid token address" do
      assert {:ok, <<_::binary>>} = Etherscan.get_token_supply(@test_token)
    end

    test "with invalid token address" do
      assert {:error, :invalid_params} = Etherscan.get_token_supply({:token})
    end
  end

  describe "get_eth_supply/0" do
    @tag :api
    test "returns current supply of eth" do
      assert {:ok, <<_::binary>>} = Etherscan.get_eth_supply()
    end
  end

  describe "get_eth_price/0" do
    @tag :api
    test "returns current eth price" do
      assert {:ok, %{
        "ethbtc" => <<_::binary>>,
        "ethbtc_timestamp" => <<_::binary>>,
        "ethusd" => <<_::binary>>,
        "ethusd_timestamp" => <<_::binary>>
      }} = Etherscan.get_eth_price()
    end
  end

  describe "get_contract_execution_status/1" do
    @tag :api
    test "with valid transaction hash (success)" do
      assert {:ok, %{
        "errDescription" => "",
        "isError" => "0"
      }} = Etherscan.get_contract_execution_status(@test_transaction_success)
    end

    @tag :api
    test "with valid transaction hash (error)" do
      assert {:ok, %{
        "errDescription" => "Bad jump destination",
        "isError" => "1"
      }} = Etherscan.get_contract_execution_status(@test_transaction_error)
    end

    test "with invalid transaction hash" do
      assert {:error, :invalid_params} = Etherscan.get_contract_execution_status("foo")
    end
  end

  describe "get_transaction_receipt_status/1" do
    @tag :api
    test "with valid transaction hash" do
      assert {:ok, %{
        "status" => "1"
      }} = Etherscan.get_transaction_receipt_status(@test_transaction_receipt)
    end

    @tag :api
    test "with pre-byzantium transaction hash" do
      assert {:ok, %{
        "status" => ""
      }} = Etherscan.get_transaction_receipt_status(@test_transaction_success)
    end

    test "with invalid transaction hash" do
      assert {:error, :invalid_params} = Etherscan.get_transaction_receipt_status("foo")
    end
  end
end
