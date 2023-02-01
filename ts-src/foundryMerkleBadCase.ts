import { MerkleTree } from "merkletreejs";
import { ethers } from "ethers";
import { keccak256 } from "ethereum-cryptography/keccak";

export type inputDatasType = {
  address: string;
  quantity: number;
};

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

const hashleaves = leaves.map((x) =>
  ethers.utils.solidityKeccak256(
    ["address", "uint256"],
    [x.address, x.quantity]
  )
);

const tree = new MerkleTree(hashleaves, keccak256);
const proofs = hashleaves.map((leave) => tree.getHexProof(leave));

const root = tree.getHexRoot();

console.log(
  ethers.utils.defaultAbiCoder.encode(
    ["bytes32", "bytes32[][]", "bytes32[]"],
    [root, proofs, hashleaves]
  )
);
