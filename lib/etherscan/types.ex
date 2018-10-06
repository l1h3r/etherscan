defmodule Etherscan.Types do
  @moduledoc false

  defmacro __using__(_) do
    quote do
      @type block_reward :: %{
              blockMiner: String.t(),
              blockNumber: String.t(),
              blockReward: String.t(),
              timeStamp: String.t(),
              uncleInclusionReward: String.t(),
              uncles: [block_reward_uncle]
            }

      @type block_reward_uncle :: %{
              blockreward: String.t(),
              miner: String.t(),
              unclePosition: String.t()
            }

      @type contract_status :: %{
              isError: String.t(),
              errDescription: String.t()
            }

      @type internal_transaction :: %{
              blockNumber: String.t(),
              contractAddress: String.t(),
              errCode: String.t(),
              from: String.t(),
              gas: String.t(),
              gasUsed: String.t(),
              hash: String.t(),
              input: String.t(),
              isError: String.t(),
              timeStamp: String.t(),
              to: String.t(),
              traceId: String.t(),
              type: String.t(),
              value: String.t()
            }

      @type log :: %{
              address: String.t(),
              blockNumber: String.t(),
              data: String.t(),
              gasPrice: String.t(),
              gasUsed: String.t(),
              logIndex: String.t(),
              timeStamp: String.t(),
              topics: list(String.t()),
              transactionHash: String.t(),
              transactionIndex: String.t()
            }

      @type mined_block :: %{
              blockNumber: String.t(),
              blockReward: String.t(),
              timeStamp: String.t()
            }

      @type mined_uncle :: %{
              blockNumber: String.t(),
              blockReward: String.t(),
              timeStamp: String.t()
            }

      @type transaction :: %{
              blockNumber: String.t(),
              timeStamp: String.t(),
              hash: String.t(),
              nonce: String.t(),
              blockHash: String.t(),
              transactionIndex: String.t(),
              from: String.t(),
              to: String.t(),
              value: String.t(),
              gas: String.t(),
              gasPrice: String.t(),
              isError: String.t(),
              txreceipt_status: String.t(),
              input: String.t(),
              contractAddress: String.t(),
              cumulativeGasUsed: String.t(),
              gasUsed: String.t(),
              confirmations: String.t()
            }

      @type address :: String.t()
      @type addresses :: [address]
      @type token_address :: String.t()
      @type transaction_hash :: String.t()
      @type block_number :: non_neg_integer
      @type params :: map

      @type response(inner) :: {:ok, inner} | {:error, atom()}
    end
  end
end
