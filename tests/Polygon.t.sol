// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {UpgradeTest} from './UpgradeTest.t.sol';
import {DeploymentLibrary} from '../scripts/Deploy.s.sol';
import {Payloads} from './Payloads.sol';

contract PolygonTest is UpgradeTest('polygon', 67532832) {
  function _getPayload() internal virtual override returns (address) {
    return DeploymentLibrary._deployPolygon();
  }

  function _getDeployedPayload() internal virtual override returns (address) {
    return Payloads.POLYGON;
  }
}
