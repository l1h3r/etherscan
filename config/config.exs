use Mix.Config

config :etherscan,
  api_key: "",
  network: :default,
  request: []

env = "#{Mix.env()}.exs"

if File.exists?("config/#{env}") do
  import_config(env)
end
