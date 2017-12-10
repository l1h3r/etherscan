defmodule Etherscan.StatsTest do
  use ExUnit.Case
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  alias Etherscan.Factory

  @token_address Factory.token_address()
  @token_supply Factory.token_supply()
  @eth_supply Factory.eth_supply()
  @eth_btc_price Factory.eth_btc_price()
  @eth_usd_price Factory.eth_usd_price()

  setup_all do
    HTTPoison.start()
    :ok
  end

  describe "get_token_supply/1" do
    test "with valid token address" do
      use_cassette "get_token_supply" do
        response = Etherscan.get_token_supply(@token_address)
        assert {:ok, @token_supply} = response
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
        assert {:ok, @eth_supply} = response
      end
    end
  end

  describe "get_eth_price/0" do
    test "returns the current eth price" do
      use_cassette "get_eth_price" do
        response = Etherscan.get_eth_price()
        assert {:ok, price} = response
        assert %{"ethbtc" => @eth_btc_price} = price
        assert %{"ethusd" => @eth_usd_price} = price
      end
    end
  end
end
