defmodule Etherscan.API do
  @moduledoc """
  Etherscan base API module.
  """

  use Etherscan.Constants
  alias Etherscan.Util

  defmacro __using__(_opts) do
    quote do
      import Etherscan.API
    end
  end

  @doc """
  Checks if the provided value is a valid Ethereum address.
  Currently very naive...
  """
  defmacro is_address(value) do
    quote do
      is_binary(unquote(value)) and binary_part(unquote(value), 0, 2) == "0x"
    end
  end

  defdelegate wrap(value, tag), to: Util
  defdelegate format_balance(balance), to: Util
  defdelegate hex_to_number(value), to: Util, as: :safe_hex_to_number

  @spec merge_params(params :: map(), default :: map()) :: map()
  def merge_params(params, default \\ %{}) do
    default
    |> Map.merge(params)
    |> Map.take(default |> Map.keys())
  end

  @spec get(module :: String.t(), action :: String.t(), params :: map()) :: String.t()
  def get(module, action, params \\ %{}) do
    module
    |> build_url(action, params)
    |> HTTPoison.get!([], request_opts())
    |> Map.get(:body)
  end

  @spec parse(response :: any(), opts :: Keyword.t()) :: any()
  def parse(response, opts \\ []) do
    response
    |> Poison.decode!(opts)
    |> extract()
  end

  @spec extract(response :: map()) :: any()
  defp extract(%{"error" => error}), do: error
  defp extract(%{"result" => result}), do: result
  defp extract(response), do: response

  @spec build_url(module :: String.t(), action :: String.t(), params :: map()) :: String.t()
  defp build_url(module, action, params) do
    params
    |> Map.put(:action, action)
    |> Map.put(:module, module)
    |> Map.put(:apikey, api_key())
    |> URI.encode_query()
    |> (&"#{network_url()}?#{&1}").()
  end

  @spec api_key :: String.t()
  defp api_key do
    Application.get_env(:etherscan, :api_key, "")
  end

  @spec network_url :: String.t()
  defp network_url do
    case Application.get_env(:etherscan, :network) do
      network when network in @api_networks ->
        Keyword.get(@api_network_urls, network)
      _ ->
        Keyword.get(@api_network_urls, :default)
    end
  end

  @spec request_opts :: Keyword.t()
  defp request_opts do
    opts = Application.get_env(:etherscan, :request, [])
    Keyword.merge(@api_request_opts, opts)
  end
end
