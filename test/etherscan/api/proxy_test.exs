defmodule Etherscan.ProxyTest do
  use ExUnit.Case
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  alias Etherscan.Factory

  @proxy_block_number Factory.proxy_block_number()
  @proxy_block_tag Factory.proxy_block_tag()
  @proxy_uncle_tag Factory.proxy_uncle_tag()
  @proxy_uncle_block_tag Factory.proxy_uncle_block_tag()
  @proxy_transaction_tag Factory.proxy_transaction_tag()
  @proxy_index Factory.proxy_index()
  @proxy_transaction_hash Factory.proxy_transaction_hash()
  @proxy_address Factory.proxy_address()
  @proxy_hex Factory.proxy_hex()
  @proxy_to Factory.proxy_to()
  @proxy_data Factory.proxy_data()
  @proxy_code_address Factory.proxy_code_address()
  @proxy_storage_address Factory.proxy_storage_address()
  @proxy_storage_position Factory.proxy_storage_position()
  @proxy_estimate_to Factory.proxy_estimate_to()
  @proxy_value Factory.proxy_value()
  @proxy_gas_price Factory.proxy_gas_price()
  @proxy_gas Factory.proxy_gas()
  @proxy_current_gas Factory.proxy_current_gas()
  @proxy_block_transaction_count Factory.proxy_block_transaction_count()
  @proxy_transaction_count Factory.proxy_transaction_count()
  @proxy_eth_call_result Factory.proxy_eth_call_result()
  @proxy_storage_result Factory.proxy_storage_result()
  @proxy_code_result Factory.proxy_code_result()

  setup_all do
    HTTPoison.start()
    :ok
  end

  describe "eth_block_number/0" do
    test "returns the most recent block number" do
      use_cassette "eth_block_number" do
        response = Etherscan.eth_block_number()
        assert {:ok, @proxy_block_number} = response
      end
    end
  end

  describe "eth_get_block_by_number/1" do
    test "with valid tag" do
      use_cassette "eth_get_block_by_number" do
        response = Etherscan.eth_get_block_by_number(@proxy_block_tag)
        assert {:ok, %{"number" => @proxy_block_tag}} = response
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
        response = Etherscan.eth_get_uncle_by_block_number_and_index(@proxy_uncle_tag, @proxy_index)
        assert {:ok, %{"number" => @proxy_uncle_block_tag}} = response
      end
    end

    test "with invalid tag" do
      response = Etherscan.eth_get_uncle_by_block_number_and_index(nil, @proxy_index)
      assert {:error, :invalid_tag} = response
    end

    test "with invalid index" do
      response = Etherscan.eth_get_uncle_by_block_number_and_index(@proxy_uncle_tag, nil)
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
        response = Etherscan.eth_get_block_transaction_count_by_number(@proxy_transaction_tag)
        assert {:ok, @proxy_block_transaction_count} = response
      end
    end

    test "with invalid tag" do
      response = Etherscan.eth_get_block_transaction_count_by_number(nil)
      assert {:error, :invalid_tag} = response
    end
  end

  describe "eth_get_transaction_by_hash/1" do
    test "with valid transaction hash" do
      use_cassette "eth_get_transaction_by_hash" do
        response = Etherscan.eth_get_transaction_by_hash(@proxy_transaction_hash)
        assert {:ok, %{"hash" => @proxy_transaction_hash}} = response
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
        response = Etherscan.eth_get_transaction_by_block_number_and_index(@proxy_block_tag, @proxy_index)
        assert {:ok, %{"blockNumber" => @proxy_block_tag}} = response
      end
    end

    test "with invalid tag" do
      response = Etherscan.eth_get_transaction_by_block_number_and_index(nil, @proxy_index)
      assert {:error, :invalid_tag} = response
    end

    test "with invalid index" do
      response = Etherscan.eth_get_transaction_by_block_number_and_index(@proxy_block_tag, nil)
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
        response = Etherscan.eth_get_transaction_count(@proxy_address)
        assert {:ok, @proxy_transaction_count} = response
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
        response = Etherscan.eth_send_raw_transaction(@proxy_hex)
        assert {:ok, %{"message" => "Invalid RLP.", "data" =>"RlpIncorrectListLen"}} = response
      end
    end

    test "with invalid hex" do
      response = Etherscan.eth_send_raw_transaction(nil)
      assert {:error, :invalid_hex} = response
    end
  end

  describe "eth_get_transaction_receipt/1" do
    test "with valid transaction hash" do
      use_cassette "eth_get_transaction_receipt" do
        response = Etherscan.eth_get_transaction_receipt(@proxy_transaction_hash)
        assert {:ok, %{"transactionHash" => @proxy_transaction_hash}} = response
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
        response = Etherscan.eth_call(@proxy_to, @proxy_data)
        assert {:ok, @proxy_eth_call_result} = response
      end
    end

    test "with invalid to" do
      response = Etherscan.eth_call(nil, @proxy_data)
      assert {:error, :invalid_to} = response
    end

    test "with invalid data" do
      response = Etherscan.eth_call(@proxy_to, nil)
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
        response = Etherscan.eth_get_code(@proxy_code_address, "latest")
        assert {:ok, @proxy_code_result} = response
      end
    end

    test "with invalid address" do
      response = Etherscan.eth_get_code(nil, "latest")
      assert {:error, :invalid_address} = response
    end

    test "with invalid tag" do
      response = Etherscan.eth_get_code(@proxy_address, nil)
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
        response = Etherscan.eth_get_storage_at(@proxy_storage_address, @proxy_storage_position)
        assert {:ok, @proxy_storage_result} = response
      end
    end

    test "with invalid address" do
      response = Etherscan.eth_get_storage_at(nil, @proxy_storage_position)
      assert {:error, :invalid_address} = response
    end

    test "with invalid position" do
      response = Etherscan.eth_get_storage_at(@proxy_storage_address, nil)
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
        assert {:ok, @proxy_current_gas} = response
      end
    end
  end

  describe "eth_estimate_gas/1" do
    @tag :wip
    test "with valid params" do
      use_cassette "eth_estimate_gas" do
        params = %{
          to: @proxy_estimate_to,
          value: @proxy_value,
          gasPrice: @proxy_gas_price,
          gas: @proxy_gas,
        }
        response = Etherscan.eth_estimate_gas(params)
        assert {:ok, %{"data" => "Internal(\"Requires higher than upper limit of 1000000000000\")"}} = response
      end
    end

    test "with invalid params" do
      response = Etherscan.eth_estimate_gas(nil)
      assert {:error, :invalid_params} = response
    end
  end

end
