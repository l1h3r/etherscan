defmodule Etherscan.LogsTest do
  use ExUnit.Case
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  use Etherscan.Constants
  alias Etherscan.Log

  setup_all do
    HTTPoison.start()
    :ok
  end

  describe "get_logs/1" do
    test "returns a log struct" do
      use_cassette "get_logs" do
        response =
          %{
            address: @test_topic_address,
            topic0: @test_topic_0,
            topic1: @test_topic_1,
            topic0_1_opr: "and"
          }
          |> Etherscan.get_logs()

        assert {:ok, logs} = response
        assert [%Log{address: @test_topic_address} = log | _] = logs
        assert @test_topic_0 in log.topics
        assert @test_topic_1 in log.topics
      end
    end

    test "with invalid params" do
      response = Etherscan.get_logs("log_params")
      assert {:error, :invalid_params} = response
    end

    test "with invalid address" do
      response = Etherscan.get_logs(%{address: "not-an-address"})
      assert {:error, :invalid_address} = response
    end

    test "with invalid fromBlock string" do
      response = Etherscan.get_logs(%{fromBlock: "not latest"})
      assert {:error, :invalid_from_block} = response
    end

    test "with invalid fromBlock type" do
      response = Etherscan.get_logs(%{fromBlock: nil})
      assert {:error, :invalid_from_block} = response
    end

    test "with invalid toBlock string" do
      response = Etherscan.get_logs(%{toBlock: "not latest"})
      assert {:error, :invalid_to_block} = response
    end

    test "with invalid toBlock type" do
      response = Etherscan.get_logs(%{toBlock: nil})
      assert {:error, :invalid_to_block} = response
    end

    test "with invalid topic0_1_opr" do
      response = Etherscan.get_logs(%{topic0_1_opr: "a n d"})
      assert {:error, :invalid_topic0_1_opr} = response
    end

    test "with invalid topic1_2_opr" do
      response = Etherscan.get_logs(%{topic1_2_opr: "andddd"})
      assert {:error, :invalid_topic1_2_opr} = response
    end

    test "with invalid topic2_3_opr" do
      response = Etherscan.get_logs(%{topic2_3_opr: "banana"})
      assert {:error, :invalid_topic2_3_opr} = response
    end
  end
end
