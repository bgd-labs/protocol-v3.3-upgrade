// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {UpgradeTest} from './UpgradeTest.t.sol';
import {DeploymentLibrary} from '../scripts/Deploy.s.sol';
import {Payloads} from './Payloads.sol';

contract MainnetTest is UpgradeTest('mainnet', 20930840) {
  function _getPayload() internal virtual override returns (address) {
    return DeploymentLibrary._deployMainnet();
  }

  function _getDeployedPayload() internal virtual override returns (address) {
    return Payloads.PROTO;
  }

  function _getDeprecatedPDP() internal virtual override returns (address) {
    return address(0x20e074F62EcBD8BC5E38211adCb6103006113A22);
  }
}
