defmodule Etherscan.ContractsTest do
  use ExUnit.Case
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  use Etherscan.Constants

  setup_all do
    HTTPoison.start()
    :ok
  end

  describe "get_contract_abi/1" do
    test "with valid address" do
      use_cassette "get_contract_abi" do
        assert {:ok, abi} = Etherscan.get_contract_abi(@test_contract_address)
        assert [%{"name" => _} | _] = abi
        assert [%{"type" => _} | _] = abi
        assert [%{"constant" => _} | _] = abi
        assert [%{"inputs" => _} | _] = abi
        assert [%{"outputs" => _} | _] = abi
      end
    end

    test "with invalid address" do
      response = Etherscan.get_contract_abi({:hello, :world})
      assert {:error, :invalid_address} = response
    end
  end

  describe "get_contract_source/1" do
    test "with valid address" do
      use_cassette "get_contract_source" do
        assert {:ok, source} = Etherscan.get_contract_source(@test_contract_address)
        assert [%{"ABI" => _} | _] = source
        assert [%{"CompilerVersion" => _} | _] = source
        assert [%{"ConstructorArguments" => _} | _] = source
        assert [%{"ContractName" => _} | _] = source
        assert [%{"Library" => _} | _] = source
        assert [%{"OptimizationUsed" => _} | _] = source
        assert [%{"Runs" => _} | _] = source
        assert [%{"SourceCode" => _} | _] = source
        assert [%{"SwarmSource" => _} | _] = source
      end
    end

    test "with invalid address" do
      response = Etherscan.get_contract_source({:foo, :bar})
      assert {:error, :invalid_address} = response
    end
  end
end
