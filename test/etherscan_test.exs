defmodule EtherscanTest do
  use ExUnit.Case
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  @address1 "0xddbd2b932c763ba5b1b7ae3b362eac3e8d40121a"
  @address2 "0x63a9975ba31b0b9626b34300f7f627147df1f526"
  @address3 "0x198ef1ec325a96cc354c7266a038be8b5c558f67"
  @miner_address "0x9dd134d14d1e65f84b706d6f205cd5b1cd03a46b"
  @token_address "0x57d90b64a1a57749b0f932f1a3395792e12e7055"
  @contract_address "0xBB9bc244D798123fDe783fCc1C72d3Bb8C189413"
  @token_owner_address "0xe04f27eb70e025b78871a2ad7eabe85e61212761"
  @transaction_hash "0x40eb908387324f2b575b4879cd9d7188f69c8fc9d87c901b9e2daaea4b442170"
  @invalid_transaction_hash "0x15f8e5ea1079d9a0bb04a4c58ae5fe7654b5b2b4463375ff7ffb490aa0032f3a"

  @address1_balance 40807168564070000000000
  @address2_balance 332567136222827062478
  @address3_balance 136929866215627048268
  @token_address_balance 135499

  @token_supply 21265524714464
  @block_number 2165403
  @eth_supply 94414983467800000000000000

  setup_all do
    HTTPoison.start()
    :ok
  end

  #
  # Etherscan.get_balance()
  #

  test "get_balance with valid address" do
    use_cassette "get_balance" do
      assert Etherscan.get_balance(@address1) == {:ok, @address1_balance}
    end
  end

  test "get_balance with invalid address" do
    assert Etherscan.get_balance(%{}) == {:error, :invalid_address}
  end

  #
  # Etherscan.get_balances()
  #

  test "get_balances with valid addresses" do
    use_cassette "get_balances" do
      expected = {:ok,
        [
          %{"account" => @address1, "balance" => @address1_balance},
          %{"account" => @address2, "balance" => @address2_balance},
          %{"account" => @address3, "balance" => @address3_balance}
        ]
      }
      assert Etherscan.get_balances([@address1, @address2, @address3]) == expected
    end
  end

  test "get_balances with invalid addresses" do
    assert Etherscan.get_balances([%{}]) == {:error, :invalid_addresses}
  end

  #
  # Etherscan.get_transactions()
  #

  test "get_transactions returns a list of block structs" do
    use_cassette "get_transactions" do
      {:ok, blocks} = Etherscan.get_transactions(@address1)
      block = List.first(blocks)
      assert block.__struct__() == Etherscan.Block
    end
  end

  test "get_transactions with invalid address" do
    assert Etherscan.get_transactions({:hello, :world}) == {:error, :invalid_address}
  end

  test "get_transactions with startblock" do
    use_cassette "get_transactions_startblock" do
      {:ok, blocks} = Etherscan.get_transactions(@address1, %{startblock: 500000})
      block = List.first(blocks)
      assert block.blockNumber == "915000"
    end
  end

  test "get_transactions with endblock" do
    use_cassette "get_transactions_endblock" do
      {:ok, blocks} = Etherscan.get_transactions(@address1, %{endblock: 5000})
      block = List.last(blocks)
      assert block.blockNumber == "0"
    end
  end

  test "get_transactions with offset" do
    use_cassette "get_transactions_offset" do
      {:ok, blocks} = Etherscan.get_transactions(@address1, %{offset: 5})
      assert length(blocks) == 5
    end
  end

  test "get_transactions with page" do
    use_cassette "get_transactions_page" do
      {:ok, blocks} = Etherscan.get_transactions(@address1, %{page: 2})
      block = List.first(blocks)
      assert block.blockNumber == "1959340"
    end
  end

  test "get_transactions with sort" do
    use_cassette "get_transactions_sort" do
      {:ok, blocks} = Etherscan.get_transactions(@address1, %{sort: "desc"})
      block = List.first(blocks)
      assert block.blockNumber == "1961866"
    end
  end

  #
  # Etherscan.get_internal_transactions()
  #

  test "get_internal_transactions returns a list of block structs" do
    use_cassette "get_internal_transactions" do
      {:ok, blocks} = Etherscan.get_internal_transactions(@address1)
      block = List.first(blocks)
      assert block.__struct__() == Etherscan.Block
    end
  end

  test "get_internal_transactions with invalid address" do
    assert Etherscan.get_internal_transactions({:hello, :world}) == {:error, :invalid_address}
  end

  test "get_internal_transactions with startblock" do
    use_cassette "get_internal_transactions_startblock" do
      {:ok, blocks} = Etherscan.get_internal_transactions(@address1, %{startblock: 1960000})
      block = List.first(blocks)
      assert block.blockNumber == "1961849"
    end
  end

  test "get_internal_transactions with endblock" do
    use_cassette "get_internal_transactions_endblock" do
      {:ok, blocks} = Etherscan.get_internal_transactions(@address1, %{endblock: 1960000})
      block = List.last(blocks)
      assert block.blockNumber == "1959740"
    end
  end

  test "get_internal_transactions with offset" do
    use_cassette "get_internal_transactions_offset" do
      {:ok, blocks} = Etherscan.get_internal_transactions(@address1, %{offset: 2})
      assert length(blocks) == 2
    end
  end

  test "get_internal_transactions with page" do
    use_cassette "get_internal_transactions_page" do
      {:ok, blocks} = Etherscan.get_internal_transactions(@address1, %{offset: 1, page: 2})
      assert length(blocks) == 1
    end
  end

  test "get_internal_transactions with sort" do
    use_cassette "get_internal_transactions_sort" do
      {:ok, blocks} = Etherscan.get_internal_transactions(@address1, %{sort: "desc"})
      block = List.first(blocks)
      assert block.blockNumber == "1961866"
    end
  end

  #
  # Etherscan.get_internal_transactions_by_hash()
  #

  test "get_internal_transactions_by_hash returns a list of block structs" do
    use_cassette "get_internal_transactions_by_hash" do
      {:ok, blocks} = Etherscan.get_internal_transactions_by_hash(@transaction_hash)
      block = List.first(blocks)
      assert block.__struct__() == Etherscan.Block
    end
  end

  test "get_internal_transactions_by_hash with invalid transaction hash" do
    assert Etherscan.get_internal_transactions_by_hash({:transaction}) == {:error, :invalid_transaction_hash}
  end

  #
  # Etherscan.get_blocks_mined()
  #

  test "get_blocks_mined returns a list of mined block structs" do
    use_cassette "get_blocks_mined" do
      {:ok, rewards} = Etherscan.get_blocks_mined(@miner_address)
      reward = List.first(rewards)
      assert reward.__struct__() == Etherscan.MinedBlock
    end
  end

  test "get_blocks_mined with invalid address" do
    assert Etherscan.get_blocks_mined({:hello, :world}) == {:error, :invalid_address}
  end

  test "get_blocks_mined with offset" do
    use_cassette "get_blocks_mined_offset" do
      {:ok, rewards} = Etherscan.get_blocks_mined(@miner_address, %{offset: 8})
      assert length(rewards) == 8
    end
  end

  test "get_blocks_mined with page" do
    use_cassette "get_blocks_mined_page" do
      {:ok, rewards} = Etherscan.get_blocks_mined(@miner_address, %{offset: 4, page: 3})
      reward = List.first(rewards)
      assert reward.blockNumber == "2664645"
    end
  end

  #
  # Etherscan.get_uncles_mined()
  #

  test "get_uncles_mined returns a list of mined uncle structs" do
    use_cassette "get_uncles_mined" do
      {:ok, rewards} = Etherscan.get_uncles_mined(@miner_address)
      reward = List.first(rewards)
      assert reward.__struct__() == Etherscan.MinedUncle
    end
  end

  test "get_uncles_mined with invalid address" do
    assert Etherscan.get_uncles_mined({:hello, :world}) == {:error, :invalid_address}
  end

  test "get_uncles_mined with offset" do
    use_cassette "get_uncles_mined_offset" do
      {:ok, rewards} = Etherscan.get_uncles_mined(@miner_address, %{offset: 3})
      assert length(rewards) == 3
    end
  end

  test "get_uncles_mined with page" do
    use_cassette "get_uncles_mined_page" do
      {:ok, rewards} = Etherscan.get_uncles_mined(@miner_address, %{offset: 4, page: 3})
      reward = List.first(rewards)
      assert reward.blockNumber == "2431561"
    end
  end

  #
  # Etherscan.get_block_and_uncle_rewards()
  #

  test "get_block_and_uncle_rewards returns a block reward struct" do
    use_cassette "get_block_and_uncle_rewards" do
      {:ok, reward} = Etherscan.get_block_and_uncle_rewards(@block_number)
      assert reward.__struct__() == Etherscan.BlockReward
    end
  end

  test "get_block_and_uncle_rewards inclues block reward uncle structs" do
    use_cassette "get_block_and_uncle_rewards" do
      {:ok, reward} = Etherscan.get_block_and_uncle_rewards(@block_number)
      uncle = List.first(reward.uncles)
      assert uncle.__struct__() == Etherscan.BlockRewardUncle
    end
  end

  test "get_block_and_uncle_rewards with invalid block number" do
    assert Etherscan.get_block_and_uncle_rewards(-5) == {:error, :invalid_block_number}
    assert Etherscan.get_block_and_uncle_rewards("fake block") == {:error, :invalid_block_number}
  end

  #
  # Etherscan.get_contract_abi()
  #

  test "get_contract_abi" do
    use_cassette "get_contract_abi" do
      {:ok, abi} = Etherscan.get_contract_abi(@contract_address)
      assert abi |> List.first() |> Map.has_key?("name")
      assert abi |> List.first() |> Map.has_key?("type")
      assert abi |> List.first() |> Map.has_key?("constant")
      assert abi |> List.first() |> Map.has_key?("inputs")
      assert abi |> List.first() |> Map.has_key?("outputs")
    end
  end

  test "get_contract_abi with invalid address" do
    assert Etherscan.get_contract_abi({:hello, :world}) == {:error, :invalid_address}
  end

  #
  # Etherscan.get_token_balance()
  #

  test "get_token_balance with valid address and token address" do
    use_cassette "get_token_balance" do
      assert Etherscan.get_token_balance(@token_owner_address, @token_address) == {:ok, @token_address_balance}
    end
  end

  test "get_token_balance with invalid address" do
    assert Etherscan.get_token_balance(%{hello: "world"}, @token_address) == {:error, :invalid_address}
  end

  test "get_token_balance with invalid token address" do
    assert Etherscan.get_token_balance(@token_owner_address, %{hello: "world"}) == {:error, :invalid_token_address}
  end

  test "get_token_balance with both invalid addresses" do
    assert Etherscan.get_token_balance([1, 2], %{hello: "world"}) == {:error, :invalid_address_and_token_address}
  end

  #
  # Etherscan.get_token_supply()
  #

  test "get_token_supply with valid token address" do
    use_cassette "get_token_supply" do
      assert Etherscan.get_token_supply(@token_address) == {:ok, @token_supply}
    end
  end

  test "get_token_supply with invalid token address" do
    assert Etherscan.get_token_supply({:token}) == {:error, :invalid_token_address}
  end

  #
  # Etherscan.get_eth_supply()
  #

  test "get_eth_supply" do
    use_cassette "get_eth_supply" do
      assert Etherscan.get_eth_supply() == {:ok, @eth_supply}
    end
  end

  #
  # Etherscan.get_eth_price()
  #

  test "get_eth_price" do
    use_cassette "get_eth_price" do
      {:ok, price} = Etherscan.get_eth_price()
      assert price |> Map.has_key?("ethbtc")
      assert price |> Map.has_key?("ethusd")
    end
  end

  #
  # Etherscan.get_contract_execution_status()
  #

  test "get_contract_execution_status" do
    use_cassette "get_contract_execution_status" do
      {:ok, status} = Etherscan.get_contract_execution_status(@transaction_hash)
      assert status |> Map.get("isError") == "0"
    end
  end

  test "get_contract_execution_status with transaction error" do
    use_cassette "get_contract_execution_status_error" do
      {:ok, status} = Etherscan.get_contract_execution_status(@invalid_transaction_hash)
      assert status |> Map.get("isError") == "1"
      assert status |> Map.get("errDescription") == "Bad jump destination"
    end
  end

  test "get_contract_execution_status with invalid transaction hash" do
    assert Etherscan.get_contract_execution_status({:transaction}) == {:error, :invalid_transaction_hash}
  end

end
