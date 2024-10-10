// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {UpgradeTest} from './UpgradeTest.t.sol';
import {DeploymentLibrary} from '../scripts/Deploy.s.sol';
import {Payloads} from './Payloads.sol';

contract MetisTest is UpgradeTest('metis', 18678217) {
  function _getPayload() internal virtual override returns (address) {
    return DeploymentLibrary._deployMetis();
  }

  function _getDeployedPayload() internal virtual override returns (address) {
    return Payloads.METIS;
  }

  function _getDeprecatedPDP() internal virtual override returns (address) {
    return address(0xD554B5e13F796F4a65B6f607781C2dc3C46f9fa9);
  }
}
