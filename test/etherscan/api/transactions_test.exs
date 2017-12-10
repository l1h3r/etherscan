defmodule Etherscan.TransactionsTest do
  use ExUnit.Case
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  alias Etherscan.Factory

  @transaction_hash Factory.transaction_hash()
  @invalid_transaction_hash Factory.invalid_transaction_hash()

  setup_all do
    HTTPoison.start()
    :ok
  end

  describe "get_contract_execution_status/1" do
    test "with valid transaction" do
      use_cassette "get_contract_execution_status" do
        response = Etherscan.get_contract_execution_status(@transaction_hash)
        assert {:ok, status} = response
        assert %{"isError" => "0"} = status
      end
    end

    test "with transaction error" do
      use_cassette "get_contract_execution_status_error" do
        response = Etherscan.get_contract_execution_status(@invalid_transaction_hash)
        assert {:ok, status} = response
        assert %{"isError" => "1", "errDescription" => "Bad jump destination"} = status
      end
    end

    test "with invalid transaction hash" do
      response = Etherscan.get_contract_execution_status({:transaction})
      assert {:error, :invalid_transaction_hash} = response
    end
  end
end
