defmodule DList.Mixfile do
  use Mix.Project

  def project do
    [
      app: :dlist,
      version: "0.0.0",
      elixir: "~> 1.4",
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      deps: deps()
    ]
  end

  def application do
    [extra_applications: []]
  end

  defp deps do
    [
      {:excheck, "~> 0.5", only: :test},
      {:triq, github: "triqng/triq", only: :test}
    ]
  end
end
