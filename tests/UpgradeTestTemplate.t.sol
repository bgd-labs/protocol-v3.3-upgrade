// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import 'forge-std/Test.sol';
import {ProtocolV3TestBase, IPool, IPoolDataProvider, IPoolAddressesProvider, IERC20} from 'aave-helpers/src/ProtocolV3TestBase.sol';
import {UpgradePayload} from '../src/contracts/UpgradePayload.sol';
import {DeploymentLibrary} from '../scripts/Deploy.s.sol';

/**
 * @dev This is a test template which simulates an aave pool upgrade from v3.2 to v3.3.
 * `executePayload(vm, address(payload));` performs the upgrade to v3.3
 * run via: `forge test --mc UpgradeTestTemplate`
 */
contract UpgradeTestTemplate is ProtocolV3TestBase {
  string public NETWORK;
  uint256 public BLOCK_NUMBER;
  UpgradePayload payload;

  function setUp() public {
    // @dev can be adapted for any other aave 3.2 pool
    NETWORK = 'mainnet';
    BLOCK_NUMBER = 21585959;
    vm.createSelectFork(vm.rpcUrl(NETWORK), BLOCK_NUMBER);
    payload = UpgradePayload(DeploymentLibrary._deployMainnet());
  }

  function test_template() external {
    // ...
    executePayload(vm, address(payload));
    // ...
  }
}
