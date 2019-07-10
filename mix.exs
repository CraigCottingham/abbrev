defmodule Abbrev.MixProject do
  use Mix.Project

  def project do
    [
      app: :abbrev,
      version: "0.1.0",
      elixir: "~> 1.8",
      elixirc_paths: elixirc_paths(Mix.env()),
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

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "spec/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:espec, "~> 1.7", only: :test}
    ]
  end

  defp aliases do
    [
      test: ["espec"]
    ]
  end
end
