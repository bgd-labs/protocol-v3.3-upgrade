// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {UpgradeTest} from './UpgradeTest.t.sol';
import {DeploymentLibrary} from '../scripts/Deploy.s.sol';
import {Payloads} from './Payloads.sol';

contract BaseTest is UpgradeTest('base', 20859276) {
  function _getPayload() internal virtual override returns (address) {
    return DeploymentLibrary._deployBase();
  }

  function _getDeployedPayload() internal virtual override returns (address) {
    return Payloads.BASE;
  }

  function _getDeprecatedPDP() internal virtual override returns (address) {
    return address(0x793177a6Cf520C7fE5B2E45660EBB48132184BBC);
  }
}
