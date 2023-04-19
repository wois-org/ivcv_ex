defmodule IvcvEx.MixProject do
  use Mix.Project

  def project do
    [
      app: :ivcv_ex,
      version: "0.12.0",
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      name: "IvcvEx",
      description: description(),
      package: package(),
      test_coverage: [tool: ExCoveralls],
      docs: [
        main: "readme",
        extras: ["README.md", "CHANGELOG.md", "LICENSE"]
      ],
      source_url: "https://github.com/wois-org/ivcv_ex"
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp description() do
    "Unofficial IVCV Client Library"
  end

  defp package() do
    [
      name: "ivcv_ex",
      files: ~w(lib .formatter.exs mix.exs README* LICENSE CHANGELOG*),
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/wois-org/ivcv_ex"}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:httpoison, "~> 2.1"},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false},
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false},
      {:excoveralls, "0.16.1", only: :test},
      {:version_release, "0.5.2", only: [:test, :dev], runtime: false},
      {:mox, "~> 1.0", only: :test}
    ]
  end
end
