defmodule Etherscan.BlocksTest do
  use ExUnit.Case
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  alias Etherscan.{BlockReward, BlockRewardUncle, Factory}

  @block_number Factory.block_number()

  setup_all do
    HTTPoison.start()
    :ok
  end

  describe "get_block_and_uncle_rewards/1" do
    test "returns a block reward struct" do
      use_cassette "get_block_and_uncle_rewards" do
        response = Etherscan.get_block_and_uncle_rewards(@block_number)
        assert {:ok, reward} = response
        assert %BlockReward{} = reward
      end
    end

    test "inclues block reward uncle structs" do
      use_cassette "get_block_and_uncle_rewards" do
        response = Etherscan.get_block_and_uncle_rewards(@block_number)
        assert {:ok, %BlockReward{uncles: uncles}} = response
        assert [%BlockRewardUncle{} | _] = uncles
      end
    end

    test "with invalid block number" do
      response = Etherscan.get_block_and_uncle_rewards(-5)
      assert {:error, :invalid_block_number} = response
      response = Etherscan.get_block_and_uncle_rewards("fake block")
      assert {:error, :invalid_block_number} = response
    end
  end
end
