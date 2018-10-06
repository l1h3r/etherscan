defmodule Etherscan.Util do
  @moduledoc false

  @denominations [
    wei: 1,
    kwei: 1000,
    mwei: 1_000_000,
    gwei: 1_000_000_000,
    shannon: 1_000_000_000,
    nano: 1_000_000_000,
    szabo: 1_000_000_000_000,
    micro: 1_000_000_000_000,
    finney: 1_000_000_000_000_000,
    milli: 1_000_000_000_000_000,
    ether: 1_000_000_000_000_000_000
  ]

  @precision 20

  @type maybe_number :: number | binary

  @spec wrap(term, atom) :: {atom, term}
  def wrap(term, tag) when is_atom(tag) do
    {tag, term}
  end

  @spec merge_params(map, map) :: map
  def merge_params(params, default) do
    default
    |> Map.merge(params)
    |> Map.take(default |> Map.keys())
  end

  @spec convert(maybe_number, keyword) :: binary
  def convert(number, opts \\ [])

  def convert(number, opts) when is_number(number) do
    as = Keyword.get(opts, :as, :ether)
    precision = Keyword.get(opts, :precision, @precision)

    denom =
      @denominations
      |> List.keyfind(as, 0)
      |> elem(1)

    pretty_float(number / denom, precision)
  end

  def convert(number, opts) when is_binary(number) do
    number
    |> String.to_integer()
    |> convert(opts)
  end

  @doc """
  Converts a float to a nicely formatted string
  """
  @spec pretty_float(maybe_number, integer) :: binary
  def pretty_float(number, precision \\ @precision)

  def pretty_float(number, precision) when is_number(number) do
    :erlang.float_to_binary(number, [:compact, decimals: precision])
  end

  def pretty_float(number, precision) when is_binary(number) do
    number
    |> String.to_float()
    |> pretty_float(precision)
  end
end
