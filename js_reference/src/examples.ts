import { Wallet } from "ethers"
import {TypedDataEncoder} from "./logged_typed_data_encoder"

const defaultDomain = {
    "name": "example.metamask.io",
    "version": "4",
    "chainId": 1,
    "verifyingContract": "0x0000000000000000000000000000000000000000"
  }

export const basicString = async (wallet: Wallet) =>{
    const types = {
        "Message": [{"name": "data", "type": "string"}]
    }
    
    return wallet._signTypedData(defaultDomain, types, {data: "test"});
}

export const zeroX = async (wallet: Wallet) => {
    const types = {
        "Order": [
          {"name": "makerAddress", "type": "address"},
          {"name": "takerAddress", "type": "address"},
          {"name": "feeRecipientAddress", "type": "address"},
          {"name": "senderAddress", "type": "address"},
          {"name": "makerAssetAmount", "type": "uint256"},
          {"name": "takerAssetAmount", "type": "uint256"},
          {"name": "makerFee", "type": "uint256"},
          {"name": "takerFee", "type": "uint256"},
          {"name": "expirationTimeSeconds", "type": "uint256"},
          {"name": "salt", "type": "uint256"},
          {"name": "makerAssetData", "type": "bytes"},
          {"name": "takerAssetData", "type": "bytes"},
          {"name": "makerFeeAssetData", "type": "bytes"},
          {"name": "takerFeeAssetData", "type": "bytes"},
        ]
      }
      const data = {
        "makerAddress": "0x1bbeb0a1a075d870bed8c21dfbe49a37015e4124",
        "takerAddress": "0x0000000000000000000000000000000000000000",
        "senderAddress": "0x0000000000000000000000000000000000000000",
        "feeRecipientAddress": "0x0000000000000000000000000000000000000000",
        "expirationTimeSeconds": "1641635545",
        "salt": "1",
        "makerAssetAmount": "1",
        "takerAssetAmount": "50000000000000000",
        "makerAssetData":
          "0x02571792000000000000000000000000a5f1ea7df861952863df2e8d1312f7305dabf2150000000000000000000000000000000000000000000000000000000000002b5b",
        "takerAssetData":
          "0xf47261b00000000000000000000000007ceb23fd6bc0add59e62ac25578270cff1b9f619",
        "takerFeeAssetData": "0x",
        "makerFeeAssetData": "0x",
        "takerFee": "0",
        "makerFee": "0"
      }
      const domain = {
        "name": "0x Protocol",
        "version": "3.0.0",
        "chainId": "137",
        "verifyingContract": "0xfede379e48c873c75f3cc0c81f7c784ad730a8f7"
      }
      return wallet._signTypedData(domain, types, data);
}

export const encodeBasicDataTypes = () => {
    const data = {
        "data": "test",
        "data1": "2",
        "data2": "3",
        "data3": Uint8Array.from(Buffer.from("c3f426ae", 'hex')),
        "data4": false,
        "data5": "0x5FF3cb18d8866541C66e4A346767a10480c4278D"
      }
      const types = {
        "Message": [
          {"name": "data", "type": "string"},
          {"name": "data1", "type": "int8"},
          {"name": "data2", "type": "uint8"},
          {"name": "data3", "type": "bytes4"},
          {"name": "data4", "type": "bool"},
          {"name": "data5", "type": "address"}
        ]
      }
    console.log(TypedDataEncoder.encode({},types, data))
}

export const allExamples = async (wallet: Wallet) => {
    encodeBasicDataTypes();
    console.log( await Promise.all([
        basicString(wallet),
        zeroX(wallet)
    ]))
}

// Elixir 1901 1ed3e98a2e703320fecf59a63faeb1d6c1a7cd12eb75b2eaf044728129fb9acb 740d6fd18b68ed77c79ebe7ea6ec04cce902dab68d1b607dfb0c7e3e36800319
// JS     1901 60b65550349ac7d938f53ce6675638066d55afa9f7dd6db452a10139fca6d0a2 740d6fd18b68ed77c79ebe7ea6ec04cce902dab68d1b607dfb0c7e3e36800319

// Elixir 7e33dcd1c313f278af470ff875b594004e88bb4235aade3c1ba7fd92cbce9ee69 c22ff5f21f0b81b113e63f7db6da94fedef11b2119b4088b89664fb9a3cb65800000000000000000000000000000000000000000000000000000000000000020000000000000000000000000000000000000000000000000000000000000003c3f426ae0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000005ff3cb18d8866541c66e4a346767a10480c4278d
// JS     a5e5852990c80a1edcc8fba975c38ee0ad99576701425478ed80c5f438f85ba59 c22ff5f21f0b81b113e63f7db6da94fedef11b2119b4088b89664fb9a3cb65800000000000000000000000000000000000000000000000000000000000000020000000000000000000000000000000000000000000000000000000000000003c3f426ae0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000005ff3cb18d8866541c66e4a346767a10480c4278d