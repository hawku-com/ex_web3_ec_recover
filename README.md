# ExWeb3EcRecover

Library for recovering and verifying public keys from signatures,

## Installation

The package can be installed
by adding `ex_web3_ec_recover` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:ex_web3_ec_recover, "~> 0.1.0"}
  ]
end
```


## Usage

```elixir
iex> ExWeb3EcRecover.recover_personal_signature(%{sig: "0x30755ed65396facf86c53e6217c52b4daebe72aa4941d89635409de4c9c7f9466d4e9aaec7977f05e923889b33c0d0dd27d7226b6e6f56ce737465c5cfd04be400", msg: "Hello world"})
"0x11f4d0A3c12e86B4b5F39B213F7E19D048276DAe"

```



## Documentation
Hosted on [http://hexdocs.pm/exiban/ExIban.html](http://hexdocs.pm/ex_web3_ec_recover.html)

## Author
Charlie Graham (Hawku)

ExWeb3EcRecover is released under the [MIT License](https://github.com/appcues/exsentry/blob/master/LICENSE.txt).