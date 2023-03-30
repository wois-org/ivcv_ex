# IvcvEx

[![Docs](https://img.shields.io/badge/hex-docs-blue)](https://wois.hexdocs.pm/ivcv_ex/)

IvcvEx is an unofficial client library IVCV(https://ivcv.eu/), so you can request video analysis and later fetch the results.

You only need to set your authentication api key in the config file and enjoy the feature of IVCV withou having to configure http calls, ensure urls or dealing with tricky configurations. Use your time in the business logic of your app.


-----
## Installation

The package can be installed by adding `ivcv_ex` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:ivcv_ex, "~> 0.1.0"}
  ]
end
```
-----
## Configurations

* config.exs

```elixir
config :ivcv_ex,
  http_client: HTTPoison,
  auth_key: "[your_authentication_key]",
  base_url: "https://api.ivcv.eu"
```

-----

## License
Licensed under [MIT license](LICENSE)


-----
## PS
If you found this library useful, dont forget to star it (on github) =)

![GitHub stars](https://img.shields.io/github/stars/wois-org/ivcv_ex?style=social)

