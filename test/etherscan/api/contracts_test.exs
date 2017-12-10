defmodule Etherscan.ContractsTest do
  use ExUnit.Case
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  alias Etherscan.Factory

  @contract_address Factory.contract_address()

  setup_all do
    HTTPoison.start()
    :ok
  end

  describe "get_contract_abi/1" do
    test "with valid address" do
      use_cassette "get_contract_abi" do
        response = Etherscan.get_contract_abi(@contract_address)
        assert {:ok, abi} = response
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
end
