// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

uint256 constant NUMBER_OF_BRAINS = 50;

function encodeBrainNamespace(uint256 i) pure returns (bytes14) {
  return bytes14(keccak256(abi.encode("brain-ns-", i)));
}
