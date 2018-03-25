# Etherscan

[![Build Status](https://travis-ci.org/l1h3r/etherscan.svg?branch=master)](https://travis-ci.org/l1h3r/etherscan)
[![Coverage Status](https://coveralls.io/repos/github/l1h3r/etherscan/badge.svg?branch=master)](https://coveralls.io/github/l1h3r/etherscan?branch=master)
[![Hex.pm](https://img.shields.io/hexpm/v/etherscan.svg?style=flat-square)](https://hex.pm/packages/etherscan)
[![Hex.pm](https://img.shields.io/hexpm/dt/etherscan.svg?style=flat-square)](https://hex.pm/packages/etherscan)

An Elixir wrapper for the [Etherscan](https://etherscan.io/) API

[Official API Documentation](https://etherscan.io/apis)

[Create API Key (optional)](https://etherscan.io/myapikey)

## Installation

Etherscan is available on [Hex](https://hex.pm/). You can install the package via:

```elixir
def deps do
  [
    {:etherscan, "~> 2.0.0"}
  ]
end
```

## Usage

#### Setting Your API Key

An API key is not required to use the Etherscan API, however, you can set one with the following:

```elixir
config :etherscan,
  api_key: "<YOUR-API-KEY>"
```

#### Using a Testnet

You can use one of the test networks with the following:
```elixir
config :etherscan,
  network: :ropsten
```

#### Setting Request Options

You can set additional request options which are passed to [HTTPoison]:

```elixir
config :etherscan,
  request: [recv_timeout: 500]
```

Check out the HTTPoison [README](https://github.com/edgurgel/httpoison#options) for all available options.

[HTTPoison]: https://github.com/edgurgel/httpoison
