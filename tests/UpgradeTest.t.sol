// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import 'forge-std/Test.sol';

abstract contract UpgradeTest is Test {
  string public NETWORK;
  uint256 public immutable BLOCK_NUMBER;

  constructor(string memory network, uint256 blocknumber) {
    NETWORK = network;
    BLOCK_NUMBER = blocknumber;
  }

  function setUp() public {
    vm.createSelectFork(vm.rpcUrl(NETWORK), BLOCK_NUMBER);
  }

  function _getPayload() internal virtual returns (address);
}
