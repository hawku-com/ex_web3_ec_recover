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