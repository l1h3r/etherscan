use Mix.Config

config :exvcr,
  filter_request_headers: [
    "Access-Control-Allow-Headers",
    "Access-Control-Allow-Methods",
    "Access-Control-Allow-Origin",
    "Cache-Control",
    "Content-Length",
    "Content-Type",
    "Date",
    "Server",
    "X-Frame-Options"
  ]
