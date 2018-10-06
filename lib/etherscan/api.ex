defmodule Etherscan.API do
  @moduledoc """
  API helpers for Etherscan
  """
  alias Etherscan.Config

  @address_list_max 20

  defmacro __using__(_opts) do
    quote do
      alias Etherscan.Util
      import Etherscan.API
    end
  end

  defguard is_address(value) when is_binary(value) and binary_part(value, 0, 2) == "0x"

  defguard is_block(block) when is_integer(block) or block == "latest"

  defguard is_address_list(addresses) when is_list(addresses) and length(addresses) <= @address_list_max

  @spec get(module :: String.t(), action :: String.t(), params :: map()) :: String.t()
  def get(module, action, params \\ %{}) do
    module
    |> build_url(action, params)
    |> HTTPoison.get!([], Config.request_opts())
    |> Map.get(:body)
  end

  @spec parse(binary) :: term
  def parse(json), do: json |> Jason.decode!() |> extract()

  @spec build_url(module :: String.t(), action :: String.t(), params :: map()) :: String.t()
  defp build_url(module, action, params) do
    params
    |> Map.put(:action, action)
    |> Map.put(:module, module)
    |> Map.put(:apikey, Config.api_key())
    |> Config.api_url()
  end

  @spec extract(map) :: term
  defp extract(%{"error" => error}), do: error
  defp extract(%{"result" => result}), do: result
  defp extract(json), do: json
end
