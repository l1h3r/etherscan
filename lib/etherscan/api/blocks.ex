defmodule Etherscan.API.Blocks do
  @moduledoc """
  Module to wrap Etherscan block endpoints.
  See: https://etherscan.io/apis#blocks
  """

  alias Etherscan.Utils

  def get_block_and_uncle_rewards(block_number) when is_integer(block_number) and block_number >= 0 do
    params = %{
      blockno: block_number
    }

    "block"
    |> Utils.api("getblockreward", params)
    |> Utils.parse(as: %{"result" => %Etherscan.BlockReward{uncles: [%Etherscan.BlockRewardUncle{}]}})
    |> Utils.format()
  end
  def get_block_and_uncle_rewards(_), do: {:error, :invalid_block_number}
end
