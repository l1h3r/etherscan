defmodule Etherscan.API.Contracts do
  @moduledoc """
  Module to wrap Etherscan contract endpoints.

  [Etherscan API Documentation](https://etherscan.io/apis#contracts)
  """

  use Etherscan.API
  use Etherscan.Constants

  @doc """
  Get contract ABI for contracts with verified source code, by `address`.

  [More Info](https://etherscan.io/contractsVerified)

  ## Example

      iex> Etherscan.API.Contracts.get_contract_abi("#{@test_contract_address}")
      {:ok, [%{"name" => _, ...} | _] = contract_abi}
  """
  @spec get_contract_abi(address :: String.t()) :: {:ok, list()} | {:error, atom()}
  def get_contract_abi(address) when is_address(address) do
    "contract"
    |> get("getabi", %{address: address})
    |> parse()
    |> Poison.decode!() # Decode again. ABI result is JSON
    |> wrap(:ok)
  end
  def get_contract_abi(_), do: @error_invalid_address
end
