defmodule Etherscan.UtilsTest do
  use ExUnit.Case, async: true
  alias Etherscan.Utils

  @default_api_url "https://api.etherscan.io/api"
  @ropsten_api_url "https://ropsten.etherscan.io/api"

  setup do
    on_exit fn ->
      Application.put_env(:etherscan, :network, nil)
    end
  end

  test "network_url/0 with default network" do
    assert Utils.network_url() == @default_api_url
  end

  test "network_url/0 with valid testnet" do
    Application.put_env(:etherscan, :network, :ropsten)
    assert Utils.network_url() == @ropsten_api_url
  end

  test "network_url/0 with invalid testnet" do
    Application.put_env(:etherscan, :network, :ethereum_blockchain)
    assert Utils.network_url() == @default_api_url
  end

  test "network_url/0 with invalid testnet type" do
    Application.put_env(:etherscan, :network, "rinkeby")
    assert Utils.network_url() == @default_api_url
  end
end
