defmodule Abbrev.MixProject do
  use Mix.Project

  def project do
    [
      app: :abbrev,
      version: "0.1.0",
      name: "Abbrev",
      description: description(),
      source_url: "http://github.com/CraigCottingham/abbrev",
      homepage_url: "http://github.com/CraigCottingham/abbrev",
      package: package(),
      elixir: "~> 1.8",
      elixirc_options: [warnings_as_errors: true],
      elixirc_paths: elixirc_paths(Mix.env()),
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      preferred_cli_env: [espec: :test],
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp aliases do
    [
      test: ["espec"]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:credo, "~> 1.1", only: [:dev, :test], runtime: false},
      {:espec, "~> 1.7", only: :test},
      {:ex_doc, "~> 0.19", only: :dev, runtime: false},
      {:mix_test_watch, "~> 1.0.3", only: :dev, runtime: false}
    ]
  end

  defp description do
    "Calculates the set of unambiguous abbreviations for a given set of strings."
  end

  defp elixirc_paths(:test), do: ["lib", "spec/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp package do
    [
      licenses: ["Apache-2.0"],
      links: %{"GitHub" => "https://github.com/CraigCottingham/abbrev"}
    ]
  end
end
