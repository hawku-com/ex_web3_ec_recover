# ExWeb3EcRecover

Library for recovering and verifying public keys from signatures,

## Installation

This package relies on `ExSecp256k1` which uses Rust.
Please visit [rusts website](https://www.rust-lang.org/tools/install) and install it.

The package can be installed
by adding `ex_web3_ec_recover` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:ex_web3_ec_recover, "~> 0.2.0"}
  ]
end
```


## Usage


### Personal Sign
```elixir
iex> ExWeb3EcRecover.recover_personal_signature(%{sig: "0x1dd3657c91d95f350ab25f17ee7cbcdbccd3f5bc52976bfd4dd03bd6bc29d2ac23e656bee509ca33b921e0e6b53eb64082be1bb3c69c3a4adccd993b1d667f8d1b", msg: "hello world"})
"0x11f4d0A3c12e86B4b5F39B213F7E19D048276DAe"

```

### Typed Sign (Types 3 and 4)


```

 iex>  types: %{
        "Message" => [%{"name" => "data", "type" => "string"}],
        "EIP712Domain" => [
          %{
            "name" => "name",
            "type" => "string"
          },
          %{
            "name" => "version",
            "type" => "string"
          },
          %{
            "name" => "chainId",
            "type" => "uint256"
          },
          %{
            "name" => "verifyingContract",
            "type" => "address"
          }
        ]
      },
      primary_type: "Message",
      message: %{
        "data" => "test"
      },
      domain: %{
        "name" => "example.metamask.io",
        "version" => "3",
        "chainId" => 1,
        "verifyingContract" => "0x"
      }
    }
iex> ExWeb3EcRecover.recover_typed_signature(message, sig, :v4)
"0x29c76e6ad8f28bb1004902578fb108c507be341b"

```


## Documentation
Hosted on [http://hexdocs.pm/exiban/ExIban.html](http://hexdocs.pm/ex_web3_ec_recover.html)

## Authors
Charlie Graham & Jakub Hajto (Hawku, Inc)

## Releases
0.2 Support for Typed Signatures (EIP 712) and signatures using Ledger devices
<br/> 0.1 Initial Release


ExWeb3EcRecover is released under the [MIT License](https://github.com/appcues/exsentry/blob/master/LICENSE.txt).
