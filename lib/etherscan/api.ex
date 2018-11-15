defmodule Etherscan.API do
  @moduledoc """
  API helpers for Etherscan
  """
  alias Etherscan.Config

  @type action :: String.t()
  @type params :: map
  @type format :: (term -> term)
  @type response :: {:ok, term} | {:error, {integer, binary}}

  @spec get(module :: String.t(), action, params, format) :: response
  def get(module, action, params \\ %{}, format \\ & &1) do
    module
    |> build_url(action, params)
    |> HTTPoison.get!([], Config.request_opts())
    |> case do
      %{status_code: code, body: body} when code in 200..299 ->
        body
        |> Jason.decode!()
        |> extract()
        |> format.()
        |> wrap(:ok)

      %{status_code: code, body: body} ->
        {:error, {code, body}}
    end
  end

  @spec merge(map, map) :: map
  def merge(params, default) do
    default
    |> Map.merge(params)
    |> Map.take(default |> Map.keys())
  end

  @spec build_url(module :: String.t(), action, params) :: String.t()
  defp build_url(module, action, params) do
    params
    |> Map.put(:action, action)
    |> Map.put(:module, module)
    |> Map.put(:apikey, Config.api_key())
    |> Config.api_url()
  end

  @spec extract(term) :: term
  defp extract(%{"error" => error}), do: error
  defp extract(%{"result" => result}), do: result
  defp extract(term), do: term

  @spec wrap(term, atom) :: {atom, term}
  defp wrap(term, tag) when is_atom(tag), do: {tag, term}
end
