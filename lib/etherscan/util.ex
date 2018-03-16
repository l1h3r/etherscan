defmodule Etherscan.Util do
  @moduledoc false

  @denominations [
    wei: 1,
    kwei: 1000,
    mwei: 1000000,
    gwei: 1000000000,
    shannon: 1000000000,
    nano: 1000000000,
    szabo: 1000000000000,
    micro: 1000000000000,
    finney: 1000000000000000,
    milli: 1000000000000000,
    ether: 1000000000000000000,
  ]

  @doc """
  Formats a string representing an Ethereum balance
  """
  @spec format_balance(balance :: String.t()) :: String.t()
  def format_balance(balance) do
    balance
    |> String.to_integer()
    |> convert()
  end

  @spec convert(number :: integer() | float(), opts :: Keyword.t()) :: String.t()
  def convert(number, opts \\ [])
  def convert(number, opts) when is_number(number) do
    denom =
      @denominations
      |> List.keyfind(Keyword.get(opts, :denomination, :ether), 0)
      |> elem(1)
    pretty_float(number / denom, Keyword.get(opts, :decimals, 20))
  end
  def convert(number, opts) when is_binary(number) do
    number
    |> String.to_integer()
    |> convert(opts)
  end

  @doc """
  Converts a float to a nicely formatted string
  """
  @spec pretty_float(number :: float() | String.t(), decimals :: integer()) :: String.t()
  def pretty_float(number, decimals \\ 20)
  def pretty_float(number, decimals) when is_number(number) do
    :erlang.float_to_binary(number, [:compact, decimals: decimals])
  end
  def pretty_float(number, decimals) when is_binary(number) do
    number
    |> String.to_float()
    |> pretty_float(decimals)
  end

  @doc """
  Wraps a value inside a tagged Tuple using the provided tag.
  """
  @spec wrap(value :: any(), tag :: atom()) :: {atom(), any()}
  def wrap(value, tag) when is_atom(tag), do: {tag, value}

  @spec hex_to_number(hex :: String.t()) :: {:ok, integer()} | {:error, String.t()}
  def hex_to_number("0x" <> hex) do
    hex
    |> Integer.parse(16)
    |> case do
      {integer, _} ->
        integer
        |> wrap(:ok)
      :error ->
        "invalid hex - #{inspect "0x" <> hex}"
        |> wrap(:error)
    end
  end
  def hex_to_number(hex), do: "invalid hex - #{inspect hex}" |> wrap(:error)

  @spec safe_hex_to_number(hex :: String.t()) :: integer()
  def safe_hex_to_number(hex) do
    hex
    |> hex_to_number()
    |> case do
      {:ok, integer} ->
        integer
      {:error, _reason} ->
        0
    end
  end

  @spec number_to_hex(number :: integer() | String.t()) :: String.t()
  def number_to_hex(number) when is_integer(number) do
    number
    |> Integer.to_string(16)
    |> (&Kernel.<>("0x", &1)).()
  end
  def number_to_hex(number) when is_binary(number) do
    number
    |> String.to_integer()
    |> number_to_hex()
  end
end
