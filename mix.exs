defmodule EthereumSignatures.MixProject do
  use Mix.Project

  def project do
    [
      name: "ethereum_signatures",
      source_url: "https://github.com/DennisDv24/ethereum_signatures",
      docs: [
        # The main page in the docs
        main: "EthereumSignatures",
        extras: ["README.md"]
      ],
      app: :ethereum_signatures,
      version: "0.6.1",
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      description: description(),
      package: package(),
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp description() do
    "Library for recovering web3 ETH signatures."
  end

  defp package() do
    [
      name: "ethereum_signatures",
      files: ["lib", "mix.exs", "README*", "LICENSE*"],
      maintainers: ["DennisDv24"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/DennisDv24/ethereum_signatures"}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_secp256k1, "~> 0.7.2"},
      {:ex_keccak, "~> 0.3"},
      {:ex_doc, "~> 0.24", only: :dev, runtime: false},
      {:ex_abi, "~> 0.6.4"},
      {:credo, "~> 1.6.1", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.0", only: [:dev, :test], runtime: false}
    ]
  end
end
