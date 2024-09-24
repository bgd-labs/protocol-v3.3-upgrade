// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {UpgradeTest} from './UpgradeTest.t.sol';
import {DeploymentLibrary} from '../scripts/Deploy.s.sol';

contract ArbitrumTest is UpgradeTest('arbitrum', 256839319) {
  function _getPayload() internal virtual override returns (address) {
    return DeploymentLibrary._deployArbitrum();
  }
}
