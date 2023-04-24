import Config

config :ivcv_ex,
  http_client: HTTPoison,
  auth_key: "abc123",
  base_url: "https://api.ivcv.eu",
  env: "test"

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:module, :function, :response]

import_config "#{config_env()}.exs"
