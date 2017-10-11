use Mix.Config

config :etherscan,
  :api_key, System.get_env("ETHERSCAN_API_KEY")
