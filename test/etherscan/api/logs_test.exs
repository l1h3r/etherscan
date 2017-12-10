defmodule Etherscan.LogsTest do
  use ExUnit.Case
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  alias Etherscan.{Factory, Log}

  @topic_address Factory.topic_address()
  @topic_0 Factory.topic_0()
  @topic_1 Factory.topic_1()

  setup_all do
    HTTPoison.start()
    :ok
  end

  describe "get_logs/1" do
    test "returns a log struct" do
      use_cassette "get_logs" do
        response = %{
          address: @topic_address,
          topic0: @topic_0,
          topic1: @topic_1,
          topic0_1_opr: "and",
        } |> Etherscan.get_logs()

        assert {:ok, logs} = response
        assert [%Log{address: @topic_address} = log| _] = logs
        assert @topic_0 in log.topics
        assert @topic_1 in log.topics
      end
    end

    test "with invalid params" do
      response = Etherscan.get_logs("log_params")
      assert {:error, :invalid_params} = response
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
