import { Wallet, providers } from "ethers"
import { allExamples, basicString } from "./examples";
const devWallet = new Wallet("73c05f0c50ad607da9ce8dac4c39bead67f58cf52f3fcaf5e59befddb152ac74")
const referencePublicAddress = "0x5FF3cb18d8866541C66e4A346767a10480c4278D"



console.log(allExamples(devWallet))