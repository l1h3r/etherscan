defmodule Etherscan.ProxyTest do
  use ExUnit.Case
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  use Etherscan.Constants
  alias Etherscan.{ProxyBlock, ProxyTransaction, ProxyTransactionReceipt}

  setup_all do
    HTTPoison.start()
    :ok
  end

  describe "eth_block_number/0" do
    test "returns the most recent block number" do
      use_cassette "eth_block_number" do
        response = Etherscan.eth_block_number()
        assert {:ok, @test_proxy_block_number} = response
      end
    end
  end

  describe "eth_get_block_by_number/1" do
    test "with valid tag returns a block struct" do
      use_cassette "eth_get_block_by_number" do
        response = Etherscan.eth_get_block_by_number(@test_proxy_block_tag)
        assert {:ok, %ProxyBlock{}} = response
      end
    end

    test "with invalid tag" do
      response = Etherscan.eth_get_block_by_number(%{})
      assert {:error, :invalid_tag} = response
    end
  end

  describe "eth_get_uncle_by_block_number_and_index/2" do
    test "with valid tag and index" do
      use_cassette "eth_get_uncle_by_block_number_and_index" do
        response = Etherscan.eth_get_uncle_by_block_number_and_index(@test_proxy_uncle_tag, @test_proxy_index)
        assert {:ok, %{"number" => @test_proxy_uncle_block_tag}} = response
      end
    end

    test "with invalid tag" do
      response = Etherscan.eth_get_uncle_by_block_number_and_index(nil, @test_proxy_index)
      assert {:error, :invalid_tag} = response
    end

    test "with invalid index" do
      response = Etherscan.eth_get_uncle_by_block_number_and_index(@test_proxy_uncle_tag, nil)
      assert {:error, :invalid_index} = response
    end

    test "with invalid tag and index" do
      response = Etherscan.eth_get_uncle_by_block_number_and_index(nil, nil)
      assert {:error, :invalid_tag_and_index} = response
    end
  end

  describe "eth_get_block_transaction_count_by_number/1" do
    test "with valid tag" do
      use_cassette "eth_get_block_transaction_count_by_number" do
        response = Etherscan.eth_get_block_transaction_count_by_number(@test_proxy_transaction_tag)
        assert {:ok, @test_proxy_block_transaction_count} = response
      end
    end

    test "with invalid tag" do
      response = Etherscan.eth_get_block_transaction_count_by_number(nil)
      assert {:error, :invalid_tag} = response
    end
  end

  describe "eth_get_transaction_by_hash/1" do
    test "with valid transaction hash returns a transaction struct" do
      use_cassette "eth_get_transaction_by_hash" do
        response = Etherscan.eth_get_transaction_by_hash(@test_proxy_transaction_hash)
        assert {:ok, %ProxyTransaction{hash: @test_proxy_transaction_hash}} = response
      end
    end

    test "with invalid transaction hash" do
      response = Etherscan.eth_get_transaction_by_hash(nil)
      assert {:error, :invalid_transaction_hash} = response
    end
  end

  describe "eth_get_transaction_by_block_number_and_index/2" do
    test "with valid tag and index" do
      use_cassette "eth_get_transaction_by_block_number_and_index" do
        response = Etherscan.eth_get_transaction_by_block_number_and_index(@test_proxy_block_tag, @test_proxy_index)
        assert {:ok, %ProxyTransaction{}} = response
      end
    end

    test "with invalid tag" do
      response = Etherscan.eth_get_transaction_by_block_number_and_index(nil, @test_proxy_index)
      assert {:error, :invalid_tag} = response
    end

    test "with invalid index" do
      response = Etherscan.eth_get_transaction_by_block_number_and_index(@test_proxy_block_tag, nil)
      assert {:error, :invalid_index} = response
    end

    test "with invalid tag and index" do
      response = Etherscan.eth_get_transaction_by_block_number_and_index(nil, nil)
      assert {:error, :invalid_tag_and_index} = response
    end
  end

  describe "eth_get_transaction_count/1" do
    test "with valid address" do
      use_cassette "eth_get_transaction_count" do
        response = Etherscan.eth_get_transaction_count(@test_proxy_address)
        assert {:ok, @test_proxy_transaction_count} = response
      end
    end

    test "with invalid address" do
      response = Etherscan.eth_get_transaction_count(nil)
      assert {:error, :invalid_address} = response
    end
  end

  describe "eth_send_raw_transaction/1" do
    @tag :wip
    test "with valid hex" do
      use_cassette "eth_send_raw_transaction" do
        response = Etherscan.eth_send_raw_transaction(@test_proxy_hex)
        assert {:ok, %{"message" => "Invalid RLP.", "data" => "RlpIncorrectListLen"}} = response
      end
    end

    test "with invalid hex" do
      response = Etherscan.eth_send_raw_transaction(nil)
      assert {:error, :invalid_hex} = response
    end
  end

  describe "eth_get_transaction_receipt/1" do
    test "with valid transaction hash returns a transaction receipt struct" do
      use_cassette "eth_get_transaction_receipt" do
        response = Etherscan.eth_get_transaction_receipt(@test_proxy_transaction_hash)
        assert {:ok, %ProxyTransactionReceipt{transactionHash: @test_proxy_transaction_hash}} = response
      end
    end

    test "with invalid transaction hash" do
      response = Etherscan.eth_get_transaction_receipt(nil)
      assert {:error, :invalid_transaction_hash} = response
    end
  end

  describe "eth_call/3" do
    test "with valid to and data" do
      use_cassette "eth_call" do
        response = Etherscan.eth_call(@test_proxy_to, @test_proxy_data)
        assert {:ok, @test_proxy_eth_call_result} = response
      end
    end

    test "with invalid to" do
      response = Etherscan.eth_call(nil, @test_proxy_data)
      assert {:error, :invalid_to} = response
    end

    test "with invalid data" do
      response = Etherscan.eth_call(@test_proxy_to, nil)
      assert {:error, :invalid_data} = response
    end

    test "with invalid to and data" do
      response = Etherscan.eth_call(nil, nil)
      assert {:error, :invalid_to_and_data} = response
    end
  end

  describe "eth_get_code/2" do
    test "with valid address and tag" do
      use_cassette "eth_get_code" do
        response = Etherscan.eth_get_code(@test_proxy_code_address, "latest")
        assert {:ok, @test_proxy_code_result} = response
      end
    end

    test "with invalid address" do
      response = Etherscan.eth_get_code(nil, "latest")
      assert {:error, :invalid_address} = response
    end

    test "with invalid tag" do
      response = Etherscan.eth_get_code(@test_proxy_address, nil)
      assert {:error, :invalid_tag} = response
    end

    test "with invalid address and tag" do
      response = Etherscan.eth_get_code(nil, nil)
      assert {:error, :invalid_address_and_tag} = response
    end
  end

  describe "eth_get_storage_at/2" do
    test "with valid address and position" do
      use_cassette "eth_get_storage_at" do
        response = Etherscan.eth_get_storage_at(@test_proxy_storage_address, @test_proxy_storage_position)
        assert {:ok, @test_proxy_storage_result} = response
      end
    end

    test "with invalid address" do
      response = Etherscan.eth_get_storage_at(nil, @test_proxy_storage_position)
      assert {:error, :invalid_address} = response
    end

    test "with invalid position" do
      response = Etherscan.eth_get_storage_at(@test_proxy_storage_address, nil)
      assert {:error, :invalid_position} = response
    end

    test "with invalid address and position" do
      response = Etherscan.eth_get_storage_at(nil, nil)
      assert {:error, :invalid_address_and_position} = response
    end
  end

  describe "eth_gas_price/0" do
    test "returns the current price per gas" do
      use_cassette "eth_gas_price" do
        response = Etherscan.eth_gas_price()
        assert {:ok, @test_proxy_current_gas} = response
      end
    end
  end

  describe "eth_estimate_gas/1" do
    @tag :wip
    test "with valid params" do
      use_cassette "eth_estimate_gas" do
        params = %{
          to: @test_proxy_estimate_to,
          value: @test_proxy_value,
          gasPrice: @test_proxy_gas_price,
          gas: @test_proxy_gas,
        }
        response = Etherscan.eth_estimate_gas(params)
        assert {:ok, %{"data" => "Internal(\"Requires higher than upper limit of 80000290\")"}} = response
      end
    end

    test "with invalid params" do
      response = Etherscan.eth_estimate_gas(nil)
      assert {:error, :invalid_params} = response
    end
  end

end
