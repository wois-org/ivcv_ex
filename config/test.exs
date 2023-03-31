import Config

config :ivcv_ex,
  http_client: HTTPoisonMock,
  env: "test"

import_config "version_release.exs"
