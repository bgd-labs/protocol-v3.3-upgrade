// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {UpgradeTest} from './UpgradeTest.t.sol';
import {DeploymentLibrary} from '../scripts/Deploy.s.sol';

contract PolygonTest is UpgradeTest('polygon', 61627144) {
  function _getPayload() internal virtual override returns (address) {
    return DeploymentLibrary._deployPolygon();
  }

  function test_stub() external {
    assertEq(true, true);
  }
}
