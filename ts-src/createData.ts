import * as fs from "fs";
import { ethers } from "ethers";

const a = 10;
const b = 8;

const encodedData = ethers.utils.defaultAbiCoder.encode(
  ["uint8", "uint8"],
  [a, b]
);

const outputDirectory = "data/";
if (!fs.existsSync(outputDirectory)) {
  fs.mkdirSync(outputDirectory);
}
fs.writeFileSync(outputDirectory + "data.txt", encodedData);
