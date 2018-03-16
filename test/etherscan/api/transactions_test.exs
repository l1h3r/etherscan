defmodule Etherscan.TransactionsTest do
  use ExUnit.Case
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  use Etherscan.Constants
  alias Etherscan.ContractStatus

  setup_all do
    HTTPoison.start()
    :ok
  end

  describe "get_contract_execution_status/1" do
    test "with valid transaction returns a contract status struct" do
      use_cassette "get_contract_execution_status" do
        response = Etherscan.get_contract_execution_status(@test_transaction_hash)
        assert {:ok, status} = response
        assert %ContractStatus{isError: "0"} = status
      end
    end

    test "with transaction error" do
      use_cassette "get_contract_execution_status_error" do
        response = Etherscan.get_contract_execution_status(@test_invalid_transaction_hash)
        assert {:ok, status} = response
        assert %ContractStatus{isError: "1", errDescription: "Bad jump destination"} = status
      end
    end

    test "with invalid transaction hash" do
      response = Etherscan.get_contract_execution_status({:transaction})
      assert {:error, :invalid_transaction_hash} = response
    end
  end

  describe "get_transaction_receipt_status/1" do
    test "with valid transaction returns the transaction receipt status" do
      use_cassette "get_transaction_receipt_status" do
        response = Etherscan.get_transaction_receipt_status(@test_transaction_hash_2)
        assert {:ok, %{"status" => "1"}} = response
      end
    end

    test "with pre-byzantium transaction returns empty value" do
      use_cassette "get_transaction_receipt_status_pre_byzantium" do
        response = Etherscan.get_transaction_receipt_status(@test_transaction_hash)
        assert {:ok, %{"status" => ""}} = response
      end
    end

    test "with invalid transaction hash" do
      response = Etherscan.get_transaction_receipt_status("my-transaction")
      assert {:error, :invalid_transaction_hash} = response
    end
  end
end
