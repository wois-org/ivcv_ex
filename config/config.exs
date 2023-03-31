import Config

config :ivcv_ex,
  http_client: HTTPoison,
  auth_key: "abc123",
  base_url: "https://api.ivcv.eu",
  env: "test"

import_config "#{config_env()}.exs"
