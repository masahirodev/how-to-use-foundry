import * as fs from "fs";
import { ethers } from "ethers";

const packed1 = process.argv[2];
const packed2 = process.argv[3];
const length = 128;

const decoded_data = ethers.utils.defaultAbiCoder.decode(
  [`address[${length}]`],
  packed1
)[0];

const decoded_data2 = ethers.utils.defaultAbiCoder.decode(
  [`uint8[${length}]`],
  packed2
)[0];

const leaves = [];
for (let i = 0; i < length; ++i) {
  leaves.push({
    address: decoded_data[i],
    quantity: decoded_data2[i],
  });
}

const jsonData = JSON.stringify(leaves, null, " ");

const outputDirectory = "./data/";
if (!fs.existsSync(outputDirectory)) {
  fs.mkdirSync(outputDirectory);
}
fs.writeFileSync(outputDirectory + "createRandomLeaves.json", jsonData);

console.log(ethers.utils.defaultAbiCoder.encode(["uint256"], [1]));
