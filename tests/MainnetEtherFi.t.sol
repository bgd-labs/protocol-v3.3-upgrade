// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {UpgradeTest} from './UpgradeTest.t.sol';
import {DeploymentLibrary} from '../scripts/Deploy.s.sol';
import {Payloads} from './Payloads.sol';

contract MainnetEtherfiTest is UpgradeTest('mainnet', 20930840) {
  function _getPayload() internal virtual override returns (address) {
    return DeploymentLibrary._deployMainnetEtherfi();
  }

  function _getDeployedPayload() internal virtual override returns (address) {
    return Payloads.ETHERFI;
  }

  function _getDeprecatedPDP() internal virtual override returns (address) {
    return address(0x8Cb4b66f7B13F2Ae4D3c91338fC007dbF8C14208);
  }
}
