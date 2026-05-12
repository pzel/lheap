defmodule LHeap.Mixfile do
  use Mix.Project

  def project do
    [
      app: :lheap,
      version: "2.0.0",
      elixir: "~> 1.3",
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      deps: deps(),
      description: description(),
      package: package()
    ]
  end

  def application do
    []
    # [extra_applications: [:logger]]
  end

  defp deps do
    [
      {:stream_data, "~> 1.3.0", only: :test},
      {:ex_doc, "~> 0.40.0", only: :dev},
    ]
  end

  defp description do
    """
    Leftist heap in Elixir
    """
  end

  defp package do
    [
      maintainers: ["pzel"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/pzel/lheap"}
    ]
  end
end
