export const abi = [
  {
    type: "function",
    name: "setTargetWord",
    stateMutability: "nonpayable",
    inputs: [{ name: "_word", type: "bytes32" }],
    outputs: [],
  },
  {
    type: "function",
    name: "startGame",
    stateMutability: "nonpayable",
    inputs: [{ name: "player", type: "address" }],
    outputs: [],
  },
  {
    type: "function",
    name: "tryGuess",
    stateMutability: "nonpayable",
    inputs: [
      { name: "player", type: "address" },
      { name: "_guess", type: "bytes32" },
    ],
    outputs: [],
  },
  {
    type: "function",
    name: "getGuesses",
    stateMutability: "view",
    inputs: [{ name: "player", type: "address" }],
    outputs: [{ name: "", type: "bytes32[]" }],
  },
  {
    type: "function",
    name: "getTries",
    stateMutability: "view",
    inputs: [{ name: "player", type: "address" }],
    outputs: [{ name: "", type: "uint8" }],
  },
] as const;
