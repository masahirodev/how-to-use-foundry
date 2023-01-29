import { ethers } from "ethers";

const a = Number(process.argv[2]);
const b = Number(process.argv[3]);

const c = a + b;

console.log(ethers.utils.defaultAbiCoder.encode(["uint256"], [c]));
