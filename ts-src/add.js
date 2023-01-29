"use strict";
exports.__esModule = true;
var ethers_1 = require("ethers");
var a = Number(process.argv[2]);
var b = Number(process.argv[3]);
var c = a + b;
console.log(ethers_1.ethers.utils.defaultAbiCoder.encode(["uint256"], [c]));
