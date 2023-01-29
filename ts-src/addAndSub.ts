import { ethers } from "ethers";

const a = Number(process.argv[2]);
const b = Number(process.argv[3]);

const add = a + b;
const sub = a - b;

console.log(
  ethers.utils.defaultAbiCoder.encode(["uint256", "uint256"], [add, sub])
);
