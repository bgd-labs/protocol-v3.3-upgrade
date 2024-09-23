// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {UpgradeTest} from './UpgradeTest.t.sol';
import {DeploymentLibrary} from '../scripts/Deploy.s.sol';

contract AvalancheTest is UpgradeTest('avalanche', 50894957) {
  function _getPayload() internal virtual override returns (address) {
    return DeploymentLibrary._deployAvalanche();
  }
}
