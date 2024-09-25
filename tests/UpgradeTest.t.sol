// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import 'forge-std/Test.sol';
import {ProtocolV3TestBase, IPool} from 'aave-helpers/src/ProtocolV3TestBase.sol';
import {UpgradePayload} from '../src/contracts/UpgradePayload.sol';

abstract contract UpgradeTest is ProtocolV3TestBase {
  string public NETWORK;
  uint256 public immutable BLOCK_NUMBER;
  UpgradePayload public payload;

  constructor(string memory network, uint256 blocknumber) {
    NETWORK = network;
    BLOCK_NUMBER = blocknumber;
  }

  function setUp() public {
    vm.createSelectFork(vm.rpcUrl(NETWORK), BLOCK_NUMBER);
    payload = UpgradePayload(_getPayload());
  }

  function test_default() external {
    IPool pool = payload.POOL();
    defaultTest(
      string(abi.encodePacked(vm.toString(block.chainid), '_', vm.toString(address(pool)))),
      pool,
      address(payload)
    );
  }

  function test_deployed() external {
    UpgradePayload deployed = UpgradePayload(_getDeployedPayload());
    require(address(deployed) != address(0), 'PAYLOAD_NOT_YET_DEPLOYED');
    IPool pool = deployed.POOL();
    defaultTest(
      string(abi.encodePacked(vm.toString(block.chainid), '_', vm.toString(address(pool)))),
      pool,
      address(deployed)
    );
  }

  function _getPayload() internal virtual returns (address);

  function _getDeployedPayload() internal virtual returns (address) {
    return address(0);
  }
}
