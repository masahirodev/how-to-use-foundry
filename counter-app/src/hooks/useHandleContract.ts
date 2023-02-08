import { Contract, ethers } from "ethers";
import { useState } from "react";
import { Inputs } from "../App";
import Abi from "../utils/Counter.json";
import { address, localhost, PRIVATE_KEY } from "../utils/anvil";

export const useHandleContract = (inputs: Inputs) => {
  const [data, setData] = useState<number>();

  const provider = new ethers.providers.JsonRpcProvider(localhost);
  const wallet = new ethers.Wallet(PRIVATE_KEY, provider);

  const readContract = async (target: string, arg: number[]) => {
    const contract = new Contract(address, Abi.abi, provider);
    try {
      const value = await contract[target](...arg);
      setData(Number(value));
    } catch (error) {}
  };

  const writeContract = async (target: string, arg: number[]) => {
    const contract = new Contract(address, Abi.abi, wallet);
    try {
      const tx = await contract[target](...arg);
      const receipt = await tx.wait();
      console.log(receipt);
    } catch (error) {
    } finally {
      await readContract("number", []);
    }
  };

  const read = async () => {
    await readContract("number", []);
  };

  const setNumber = async () => {
    await writeContract("setNumber", [inputs.a]);
  };

  const increment = async () => {
    await writeContract("increment", []);
  };

  const decrement = async () => {
    await writeContract("decrement", []);
  };

  const add = async () => {
    await readContract("add", [inputs.a, inputs.b]);
  };

  const setAdd = async () => {
    await writeContract("setAdd", [inputs.a, inputs.b]);
  };

  return [
    data,
    {
      read,
      setNumber,
      increment,
      decrement,
      add,
      setAdd,
    },
  ] as const;
};
