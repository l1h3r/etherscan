defmodule EtherscanTest do
  use ExUnit.Case
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  use Etherscan.Constants
  import Etherscan

  setup_all do
    HTTPoison.start()
    :ok
  end

  describe "get_balance/1" do
    test "with valid address" do
      use_cassette "get_balance" do
        assert {:ok, @test_address1_balance} = get_balance(@test_address1)
      end
    end

    test "with invalid address" do
      assert {:error, :invalid_params} = get_balance(%{})
    end
  end

  describe "get_balances/1" do
    test "with valid addresses" do
      use_cassette "get_balances" do
        expected = [
          %{"account" => @test_address1, "balance" => @test_address1_balance},
          %{"account" => @test_address2, "balance" => @test_address2_balance},
          %{"account" => @test_address3, "balance" => @test_address3_balance}
        ]

        assert {:ok, ^expected} = get_balances([@test_address1, @test_address2, @test_address3])
      end
    end

    test "with invalid addresses" do
      assert {:error, :invalid_params} = get_balances([%{}])
    end
  end

  describe "get_transactions/1" do
    test "returns a list of transaction structs" do
      use_cassette "get_transactions" do
        assert {:ok, result} = get_transactions(@test_address1)
        assert [%{"blockNumber" => "0", "from" => "GENESIS"} | _] = result
      end
    end

    test "with invalid address" do
      assert {:error, :invalid_params} = get_transactions({:hello, :world})
    end
  end

  describe "get_transactions/2" do
    test "with startblock" do
      use_cassette "get_transactions_startblock" do
        assert {:ok, result} = get_transactions(@test_address1, %{startblock: 500_000})
        assert [%{"blockNumber" => "915000"} | _] = result
      end
    end

    test "with endblock" do
      use_cassette "get_transactions_endblock" do
        assert {:ok, result} = get_transactions(@test_address1, %{endblock: 195_000})
        assert %{"blockNumber" => "101773"} = List.last(result)
      end
    end

    test "with offset" do
      use_cassette "get_transactions_offset" do
        assert {:ok, result} = get_transactions(@test_address1, %{offset: 5})
        assert length(result) == 5
      end
    end

    test "with page" do
      use_cassette "get_transactions_page" do
        assert {:ok, result} = get_transactions(@test_address1, %{page: 2})
        assert [%{"blockNumber" => "1959340"} | _] = result
      end
    end

    test "with sort" do
      use_cassette "get_transactions_sort" do
        assert {:ok, result} = get_transactions(@test_address1, %{sort: "desc"})
        assert [%{"blockNumber" => "6451971"} | _] = result
      end
    end
  end

  describe "get_internal_transactions/1" do
    test "returns a list of internal transaction structs" do
      use_cassette "get_internal_transactions" do
        assert {:ok, result} = get_internal_transactions(@test_address1)
        assert [%{"blockNumber" => "1959340"} | _] = result
      end
    end

    test "with invalid address" do
      assert {:error, :invalid_params} = get_internal_transactions({:hello, :world})
    end
  end

  describe "get_internal_transactions/2" do
    test "with startblock" do
      use_cassette "get_internal_transactions_startblock" do
        assert {:ok, result} = get_internal_transactions(@test_address1, %{startblock: 1_960_000})
        assert [%{"blockNumber" => "1961849"} | _] = result
      end
    end

    test "with endblock" do
      use_cassette "get_internal_transactions_endblock" do
        assert {:ok, result} = get_internal_transactions(@test_address1, %{endblock: 1_960_000})
        assert %{"blockNumber" => "1959740"} = List.last(result)
      end
    end

    test "with offset" do
      use_cassette "get_internal_transactions_offset" do
        assert {:ok, result} = get_internal_transactions(@test_address1, %{offset: 2})
        assert length(result) == 2
      end
    end

    test "with page" do
      use_cassette "get_internal_transactions_page" do
        assert {:ok, result} = get_internal_transactions(@test_address1, %{offset: 1, page: 2})
        assert length(result) == 1
      end
    end

    test "with sort" do
      use_cassette "get_internal_transactions_sort" do
        assert {:ok, result} = get_internal_transactions(@test_address1, %{sort: "desc"})
        assert [%{"blockNumber" => "1961866"} | _] = result
      end
    end
  end

  describe "get_internal_transactions_by_hash/1" do
    test "returns a list of internal transaction structs" do
      use_cassette "get_internal_transactions_by_hash" do
        assert {:ok, result} = get_internal_transactions_by_hash(@test_transaction_hash)
        assert [%{"blockNumber" => "1743059"} | _] = result
      end
    end

    test "with invalid transaction hash" do
      assert {:error, :invalid_params} = get_internal_transactions_by_hash({:transaction})
    end
  end

  describe "get_blocks_mined/1" do
    test "returns a list of mined block structs" do
      use_cassette "get_blocks_mined" do
        assert {:ok, result} = get_blocks_mined(@test_miner_address)
        assert [%{"blockNumber" => "3462296", "timeStamp" => "1491118514"} | _] = result
      end
    end

    test "with invalid address" do
      assert {:error, :invalid_params} = get_blocks_mined({:hello, :world})
    end
  end

  describe "get_blocks_mined/2" do
    test "get_blocks_mined with offset" do
      use_cassette "get_blocks_mined_offset" do
        assert {:ok, result} = get_blocks_mined(@test_miner_address, %{offset: 8})
        assert length(result) == 8
      end
    end

    test "get_blocks_mined with page" do
      use_cassette "get_blocks_mined_page" do
        assert {:ok, result} = get_blocks_mined(@test_miner_address, %{offset: 4, page: 3})
        assert [%{"blockNumber" => "2664645"} | _] = result
      end
    end
  end

  describe "get_uncles_mined/1" do
    test "returns a list of mined uncle structs" do
      use_cassette "get_uncles_mined" do
        assert {:ok, result} = get_uncles_mined(@test_miner_address)
        assert [%{"blockNumber" => "2691795", "timeStamp" => "1480077905"} | _] = result
      end
    end

    test "with invalid address" do
      assert {:error, :invalid_params} = get_uncles_mined({:hello, :world})
    end
  end

  describe "get_uncles_mined/2" do
    test "with offset" do
      use_cassette "get_uncles_mined_offset" do
        assert {:ok, result} = get_uncles_mined(@test_miner_address, %{offset: 3})
        assert length(result) == 3
      end
    end

    test "with page" do
      use_cassette "get_uncles_mined_page" do
        assert {:ok, result} = get_uncles_mined(@test_miner_address, %{offset: 4, page: 3})
        assert [%{"blockNumber" => "2431561"} | _] = result
      end
    end
  end

  describe "get_token_balance/2" do
    test "with valid address and token address" do
      use_cassette "get_token_balance" do
        assert {:ok, @test_token_address_balance} = get_token_balance(@test_token_owner, @test_token_address)
      end
    end

    test "with invalid address" do
      assert {:error, :invalid_params} = get_token_balance(%{hello: "world"}, @test_token_address)
    end

    test "with invalid token address" do
      assert {:error, :invalid_params} = get_token_balance(@test_token_owner, %{hello: "world"})
    end

    test "with both invalid addresses" do
      assert {:error, :invalid_params} = get_token_balance([1, 2], %{hello: "world"})
    end
  end

  describe "get_block_and_uncle_rewards/1" do
    test "returns a block reward struct" do
      use_cassette "get_block_and_uncle_rewards" do
        assert {:ok, result} = get_block_and_uncle_rewards(@test_block_number)
        assert %{"blockNumber" => "2165403"} = result
      end
    end

    test "inclues block reward uncle structs" do
      use_cassette "get_block_and_uncle_rewards" do
        assert {:ok, result} = get_block_and_uncle_rewards(@test_block_number)
        assert %{"uncles" => [uncle | _]} = result
        assert %{"blockreward" => "3750000000000000000", "unclePosition" => "0"} = uncle
      end
    end

    test "with invalid block number" do
      assert {:error, :invalid_params} = get_block_and_uncle_rewards(-5)
      assert {:error, :invalid_params} = get_block_and_uncle_rewards("fake block")
    end
  end

  describe "get_contract_abi/1" do
    test "with valid address" do
      use_cassette "get_contract_abi" do
        assert {:ok, result} = get_contract_abi(@test_contract_address)
        assert [%{"name" => _} | _] = result
        assert [%{"type" => _} | _] = result
        assert [%{"constant" => _} | _] = result
        assert [%{"inputs" => _} | _] = result
        assert [%{"outputs" => _} | _] = result
      end
    end

    test "with invalid address" do
      assert {:error, :invalid_params} = get_contract_abi({:hello, :world})
    end
  end

  describe "get_contract_source/1" do
    test "with valid address" do
      use_cassette "get_contract_source" do
        assert {:ok, result} = get_contract_source(@test_contract_address)
        assert [%{"ABI" => _} | _] = result
        assert [%{"CompilerVersion" => _} | _] = result
        assert [%{"ConstructorArguments" => _} | _] = result
        assert [%{"ContractName" => _} | _] = result
        assert [%{"Library" => _} | _] = result
        assert [%{"OptimizationUsed" => _} | _] = result
        assert [%{"Runs" => _} | _] = result
        assert [%{"SourceCode" => _} | _] = result
        assert [%{"SwarmSource" => _} | _] = result
      end
    end

    test "with invalid address" do
      assert {:error, :invalid_params} = get_contract_source({:foo, :bar})
    end
  end

  describe "get_logs/1" do
    test "returns a log struct" do
      use_cassette "get_logs" do
        params = %{
          address: @test_topic_address,
          topic0: @test_topic_0,
          topic1: @test_topic_1,
          topic0_1_opr: "and"
        }

        assert {:ok, result} = get_logs(params)
        assert [%{"address" => @test_topic_address, "topics" => topics} | _] = result
        assert @test_topic_0 in topics
        assert @test_topic_1 in topics
      end
    end

    test "with invalid params" do
      assert {:error, :invalid_params} = get_logs("log_params")
    end

    test "with invalid address" do
      assert {:error, :invalid_params} = get_logs(%{address: "not-an-address"})
    end

    test "with invalid fromBlock string" do
      assert {:error, :invalid_params} = get_logs(%{fromBlock: "not latest"})
    end

    test "with invalid fromBlock type" do
      assert {:error, :invalid_params} = get_logs(%{fromBlock: nil})
    end

    test "with invalid toBlock string" do
      assert {:error, :invalid_params} = get_logs(%{toBlock: "not latest"})
    end

    test "with invalid toBlock type" do
      assert {:error, :invalid_params} = get_logs(%{toBlock: nil})
    end

    test "with invalid topic0_1_opr" do
      assert {:error, :invalid_params} = get_logs(%{topic0_1_opr: "a n d"})
    end

    test "with invalid topic1_2_opr" do
      assert {:error, :invalid_params} = get_logs(%{topic1_2_opr: "andddd"})
    end

    test "with invalid topic2_3_opr" do
      assert {:error, :invalid_params} = get_logs(%{topic2_3_opr: "banana"})
    end
  end

  describe "get_token_supply/1" do
    test "with valid token address" do
      use_cassette "get_token_supply" do
        assert {:ok, @test_token_supply} = get_token_supply(@test_token_address)
      end
    end

    test "with invalid token address" do
      assert {:error, :invalid_params} = get_token_supply({:token})
    end
  end

  describe "get_eth_supply/0" do
    test "returns the current supply of eth" do
      use_cassette "get_eth_supply" do
        assert {:ok, @test_eth_supply} = get_eth_supply()
      end
    end
  end

  describe "get_eth_price/0" do
    test "returns the current eth price" do
      use_cassette "get_eth_price" do
        assert {:ok, result} = get_eth_price()
        assert %{"ethbtc" => @test_eth_btc_price} = result
        assert %{"ethusd" => @test_eth_usd_price} = result
      end
    end
  end

  describe "get_contract_execution_status/1" do
    test "with valid transaction returns a contract status struct" do
      use_cassette "get_contract_execution_status" do
        assert {:ok, result} = get_contract_execution_status(@test_transaction_hash)
        assert %{"isError" => "0"} = result
      end
    end

    test "with transaction error" do
      use_cassette "get_contract_execution_status_error" do
        assert {:ok, result} = get_contract_execution_status(@test_invalid_transaction_hash)
        assert %{"isError" => "1", "errDescription" => "Bad jump destination"} = result
      end
    end

    test "with invalid transaction hash" do
      assert {:error, :invalid_params} = get_contract_execution_status({:transaction})
    end
  end

  describe "get_transaction_receipt_status/1" do
    test "with valid transaction returns the transaction receipt status" do
      use_cassette "get_transaction_receipt_status" do
        assert {:ok, result} = get_transaction_receipt_status(@test_transaction_hash_2)
        assert %{"status" => "1"} = result
      end
    end

    test "with pre-byzantium transaction returns empty value" do
      use_cassette "get_transaction_receipt_status_pre_byzantium" do
        assert {:ok, result} = get_transaction_receipt_status(@test_transaction_hash)
        assert %{"status" => ""} = result
      end
    end

    test "with invalid transaction hash" do
      assert {:error, :invalid_params} = get_transaction_receipt_status("my-transaction")
    end
  end
end
