defmodule Etherscan.API.Contracts do
  @moduledoc """
  Module to wrap Etherscan contract endpoints.

  [Etherscan API Documentation](https://etherscan.io/apis#contracts)
  """

  alias Etherscan.{Factory, Utils}

  @doc """
  Get contract ABI for contracts with verified source code, by `address`.

  [More Info](https://etherscan.io/contractsVerified)

  ## Example

      iex> Etherscan.API.Contracts.get_contract_abi("#{Factory.contract_address()}")
      {:ok, [%{"name" => _, ...} | _] = contract_abi}
  """
  @spec get_contract_abi(address :: String.t()) :: {:ok, list()} | {:error, atom()}
  def get_contract_abi(address) when is_binary(address) do
    params = %{
      address: address,
    }

    "contract"
    |> Utils.api("getabi", params)
    |> Utils.parse()
    |> Poison.decode!() # Decode again. ABI result is JSON
    |> Utils.format()
  end
  def get_contract_abi(_), do: {:error, :invalid_address}
end
