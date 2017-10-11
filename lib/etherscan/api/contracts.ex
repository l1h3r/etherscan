defmodule Etherscan.API.Contracts do
  @moduledoc """
  Module to wrap Etherscan contract endpoints.
  See: https://etherscan.io/apis#contracts
  """

  alias Etherscan.Utils

  def get_contract_abi(address) when is_binary(address) do
    params = %{
      address: address
    }

    "contract"
    |> Utils.api("getabi", params)
    |> Utils.parse()
    |> Poison.decode!() # Decode again. ABI result is JSON
    |> Utils.format()
  end
  def get_contract_abi(_), do: {:error, :invalid_address}
end
