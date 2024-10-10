// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {UpgradeTest} from './UpgradeTest.t.sol';
import {DeploymentLibrary} from '../scripts/Deploy.s.sol';
import {Payloads} from './Payloads.sol';

contract MainnetLidoTest is UpgradeTest('mainnet', 20930840) {
  function _getPayload() internal virtual override returns (address) {
    return DeploymentLibrary._deployMainnetLido();
  }

  function _getDeployedPayload() internal virtual override returns (address) {
    return Payloads.LIDO;
  }

  function _getDeprecatedPDP() internal virtual override returns (address) {
    return address(0xa3206d66cF94AA1e93B21a9D8d409d6375309F4A);
  }
}
