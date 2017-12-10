defmodule Etherscan.AccountsTest do
  use ExUnit.Case
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  alias Etherscan.{Block, Factory, MinedBlock, MinedUncle}

  @address1 Factory.address1()
  @address2 Factory.address2()
  @address3 Factory.address3()
  @miner_address Factory.miner_address()
  @token_address Factory.token_address()
  @token_owner_address Factory.token_owner_address()
  @transaction_hash Factory.transaction_hash()
  @address1_balance Factory.address1_balance()
  @address2_balance Factory.address2_balance()
  @address3_balance Factory.address3_balance()
  @token_address_balance Factory.token_address_balance()

  setup_all do
    HTTPoison.start()
    :ok
  end

  describe "get_balance/1" do
    test "with valid address" do
      use_cassette "get_balance" do
        response = Etherscan.get_balance(@address1)
        assert {:ok, @address1_balance} = response
      end
    end

    test "with invalid address" do
      response = Etherscan.get_balance(%{})
      assert {:error, :invalid_address} = response
    end
  end

  describe "get_balances/1" do
    test "with valid addresses" do
      use_cassette "get_balances" do
        response = Etherscan.get_balances([@address1, @address2, @address3])
        assert {:ok,
          [
            %{"account" => @address1, "balance" => @address1_balance},
            %{"account" => @address2, "balance" => @address2_balance},
            %{"account" => @address3, "balance" => @address3_balance}
          ]
        } = response
      end
    end

    test "with invalid addresses" do
      response = Etherscan.get_balances([%{}])
      assert {:error, :invalid_addresses} = response
    end
  end

  describe "get_transactions/1" do
    test "returns a list of block structs" do
      use_cassette "get_transactions" do
        response = Etherscan.get_transactions(@address1)
        {:ok, blocks} = response
        assert [%Block{} | _] = blocks
      end
    end

    test "with invalid address" do
      response = Etherscan.get_transactions({:hello, :world})
      assert {:error, :invalid_address} = response
    end
  end

  describe "get_transactions/2" do
    test "with startblock" do
      use_cassette "get_transactions_startblock" do
        response = Etherscan.get_transactions(@address1, %{startblock: 500_000})
        assert {:ok, blocks} = response
        block_number = blocks |> List.first() |> Map.get(:blockNumber)
        assert block_number == "915000"
      end
    end

    test "with endblock" do
      use_cassette "get_transactions_endblock" do
        response = Etherscan.get_transactions(@address1, %{endblock: 5000})
        assert {:ok, blocks} = response
        block_number = blocks |> List.last() |> Map.get(:blockNumber)
        assert block_number == "0"
      end
    end

    test "with offset" do
      use_cassette "get_transactions_offset" do
        response = Etherscan.get_transactions(@address1, %{offset: 5})
        assert {:ok, blocks} = response
        assert length(blocks) == 5
      end
    end

    test "with page" do
      use_cassette "get_transactions_page" do
        response = Etherscan.get_transactions(@address1, %{page: 2})
        assert {:ok, blocks} = response
        block_number = blocks |> List.first() |> Map.get(:blockNumber)
        assert block_number == "1959340"
      end
    end

    test "with sort" do
      use_cassette "get_transactions_sort" do
        response = Etherscan.get_transactions(@address1, %{sort: "desc"})
        assert {:ok, blocks} = response
        block_number = blocks |> List.first() |> Map.get(:blockNumber)
        assert block_number == "1961866"
      end
    end
  end

  describe "get_internal_transactions/1" do
    test "returns a list of block structs" do
      use_cassette "get_internal_transactions" do
        response = Etherscan.get_internal_transactions(@address1)
        assert {:ok, blocks} = response
        assert [%Block{} | _] = blocks
      end
    end

    test "with invalid address" do
      response = Etherscan.get_internal_transactions({:hello, :world})
      assert {:error, :invalid_address} = response
    end
  end

  describe "get_internal_transactions/2" do
    test "with startblock" do
      use_cassette "get_internal_transactions_startblock" do
        response = Etherscan.get_internal_transactions(@address1, %{startblock: 1_960_000})
        assert {:ok, blocks} = response
        block_number = blocks |> List.first() |> Map.get(:blockNumber)
        assert block_number == "1961849"
      end
    end

    test "with endblock" do
      use_cassette "get_internal_transactions_endblock" do
        response = Etherscan.get_internal_transactions(@address1, %{endblock: 1_960_000})
        assert {:ok, blocks} = response
        block_number = blocks |> List.last() |> Map.get(:blockNumber)
        assert block_number == "1959740"
      end
    end

    test "with offset" do
      use_cassette "get_internal_transactions_offset" do
        response = Etherscan.get_internal_transactions(@address1, %{offset: 2})
        assert {:ok, blocks} = response
        assert length(blocks) == 2
      end
    end

    test "with page" do
      use_cassette "get_internal_transactions_page" do
        response = Etherscan.get_internal_transactions(@address1, %{offset: 1, page: 2})
        assert {:ok, blocks} = response
        assert length(blocks) == 1
      end
    end

    test "with sort" do
      use_cassette "get_internal_transactions_sort" do
        response = Etherscan.get_internal_transactions(@address1, %{sort: "desc"})
        assert {:ok, blocks} = response
        block_number = blocks |> List.first() |> Map.get(:blockNumber)
        assert block_number == "1961866"
      end
    end
  end

  describe "get_internal_transactions_by_hash/1" do
    test "returns a list of block structs" do
      use_cassette "get_internal_transactions_by_hash" do
        response = Etherscan.get_internal_transactions_by_hash(@transaction_hash)
        assert {:ok, blocks} = response
        assert [%Block{} | _] = blocks
      end
    end

    test "with invalid transaction hash" do
      response = Etherscan.get_internal_transactions_by_hash({:transaction})
      assert {:error, :invalid_transaction_hash} = response
    end
  end

  describe "get_blocks_mined/1" do
    test "returns a list of mined block structs" do
      use_cassette "get_blocks_mined" do
        response = Etherscan.get_blocks_mined(@miner_address)
        assert {:ok, rewards} = response
        assert [%MinedBlock{} | _] = rewards
      end
    end

    test "with invalid address" do
      response = Etherscan.get_blocks_mined({:hello, :world})
      assert {:error, :invalid_address} = response
    end
  end

  describe "get_blocks_mined/2" do
    test "get_blocks_mined with offset" do
      use_cassette "get_blocks_mined_offset" do
        response = Etherscan.get_blocks_mined(@miner_address, %{offset: 8})
        assert {:ok, rewards} = response
        assert length(rewards) == 8
      end
    end

    test "get_blocks_mined with page" do
      use_cassette "get_blocks_mined_page" do
        response = Etherscan.get_blocks_mined(@miner_address, %{offset: 4, page: 3})
        assert {:ok, rewards} = response
        block_number = rewards |> List.first() |> Map.get(:blockNumber)
        assert block_number == "2664645"
      end
    end
  end

  describe "get_uncles_mined/1" do
    test "returns a list of mined uncle structs" do
      use_cassette "get_uncles_mined" do
        response = Etherscan.get_uncles_mined(@miner_address)
        assert {:ok, rewards} = response
        assert [%MinedUncle{} | _] = rewards
      end
    end

    test "with invalid address" do
      response = Etherscan.get_uncles_mined({:hello, :world})
      assert {:error, :invalid_address} = response
    end
  end

  describe "get_uncles_mined/2" do
    test "with offset" do
      use_cassette "get_uncles_mined_offset" do
        response = Etherscan.get_uncles_mined(@miner_address, %{offset: 3})
        assert {:ok, rewards} = response
        assert length(rewards) == 3
      end
    end

    test "with page" do
      use_cassette "get_uncles_mined_page" do
        response = Etherscan.get_uncles_mined(@miner_address, %{offset: 4, page: 3})
        assert {:ok, rewards} = response
        block_number = rewards |> List.first() |> Map.get(:blockNumber)
        assert block_number == "2431561"
      end
    end
  end

  describe "get_token_balance/2" do
    test "with valid address and token address" do
      use_cassette "get_token_balance" do
        response = Etherscan.get_token_balance(@token_owner_address, @token_address)
        assert {:ok, @token_address_balance} = response
      end
    end

    test "with invalid address" do
      response = Etherscan.get_token_balance(%{hello: "world"}, @token_address)
      assert {:error, :invalid_address} = response
    end

    test "with invalid token address" do
      response = Etherscan.get_token_balance(@token_owner_address, %{hello: "world"})
      assert {:error, :invalid_token_address} = response
    end

    test "with both invalid addresses" do
      response = Etherscan.get_token_balance([1, 2], %{hello: "world"})
      assert {:error, :invalid_address_and_token_address} = response
    end
  end
end
