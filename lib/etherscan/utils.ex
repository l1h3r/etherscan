defmodule Etherscan.Utils do

  @api_base "https://api.etherscan.io/api"

  def api(module, action, params \\ %{}) do
    build_query(module, action, params)
    |> build_path()
    |> HTTPoison.get!([], [timeout: 20000, recv_timeout: 20000])
    |> Map.get(:body)
  end

  def parse(response, opts \\ []) do
    response
    |> Poison.decode!(opts)
    |> Map.get("result")
  end

  def format(response) do
    {:ok, response}
  end

  defp build_path(query), do: @api_base <> "?" <> query

  defp build_query(module, action, params) do
    params
    |> Map.put(:action, action)
    |> Map.put(:module, module)
    |> Map.put(:apikey, api_key())
    |> URI.encode_query()
  end

  defp api_key do
    Application.get_env(:etherscan, :api_key, "")
  end

end
