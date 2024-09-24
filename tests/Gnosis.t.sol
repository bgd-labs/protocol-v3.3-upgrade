// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {UpgradeTest} from './UpgradeTest.t.sol';
import {DeploymentLibrary} from '../scripts/Deploy.s.sol';

contract GnosisTest is UpgradeTest('gnosis', 36163976) {
  function _getPayload() internal virtual override returns (address) {
    return DeploymentLibrary._deployGnosis();
  }
}
