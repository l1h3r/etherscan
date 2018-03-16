defmodule Etherscan.StatsTest do
  use ExUnit.Case
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  use Etherscan.Constants

  setup_all do
    HTTPoison.start()
    :ok
  end

  describe "get_token_supply/1" do
    test "with valid token address" do
      use_cassette "get_token_supply" do
        response = Etherscan.get_token_supply(@test_token_address)
        assert {:ok, @test_token_supply} = response
      end
    end

    test "with invalid token address" do
      response = Etherscan.get_token_supply({:token})
      assert {:error, :invalid_token_address} = response
    end
  end

  describe "get_eth_supply/0" do
    test "returns the current supply of eth" do
      use_cassette "get_eth_supply" do
        response = Etherscan.get_eth_supply()
        assert {:ok, @test_eth_supply} = response
      end
    end
  end

  describe "get_eth_price/0" do
    test "returns the current eth price" do
      use_cassette "get_eth_price" do
        response = Etherscan.get_eth_price()
        assert {:ok, price} = response
        assert %{"ethbtc" => @test_eth_btc_price} = price
        assert %{"ethusd" => @test_eth_usd_price} = price
      end
    end
  end
end
