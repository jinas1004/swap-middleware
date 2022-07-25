const { keccak256 } = require("web3-utils");
const pair = require("./bytecode/pair.json");
const initHash = keccak256(`0x${pair.object}`);

console.log(initHash);
