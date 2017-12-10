defmodule Etherscan.API.Blocks do
  @moduledoc """
  Module to wrap Etherscan block endpoints.

  [Etherscan API Documentation](https://etherscan.io/apis#blocks)
  """

  alias Etherscan.{BlockReward, BlockRewardUncle, Factory, Utils}

  @doc """
  Get block and uncle rewards by `block_number`.

  ## Example

      iex> Etherscan.API.Blocks.get_block_and_uncle_rewards("#{Factory.block_number()}")
      {:ok, %Etherscan.BlockReward{uncles: [%Etherscan.BlockRewardUncle{}]}}
  """
  @spec get_block_and_uncle_rewards(block_number :: non_neg_integer()) :: {:ok, BlockReward.t()} :: {:error, atom()}
  def get_block_and_uncle_rewards(block_number) when is_integer(block_number) and block_number >= 0 do
    params = %{
      blockno: block_number,
    }

    "block"
    |> Utils.api("getblockreward", params)
    |> Utils.parse(as: %{"result" => %BlockReward{uncles: [%BlockRewardUncle{}]}})
    |> Utils.format()
  end
  def get_block_and_uncle_rewards(_), do: {:error, :invalid_block_number}
end
