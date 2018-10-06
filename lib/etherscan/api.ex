defmodule Etherscan.API do
  @moduledoc """
  API helpers for Etherscan
  """
  alias Etherscan.Config

  defmacro __using__(_opts) do
    quote do
      alias Etherscan.Util
      import Etherscan.API
    end
  end

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
