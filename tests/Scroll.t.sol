// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {UpgradeTest} from './UpgradeTest.t.sol';
import {DeploymentLibrary} from '../scripts/Deploy.s.sol';
import {Payloads} from './Payloads.sol';

contract ScrollTest is UpgradeTest('scroll', 10018044) {
  function _getPayload() internal virtual override returns (address) {
    return DeploymentLibrary._deployScroll();
  }

  function _getDeployedPayload() internal virtual override returns (address) {
    return Payloads.SCROLL;
  }

  function _getDeprecatedPDP() internal virtual override returns (address) {
    return address(0xD9b61AC3a94584E7B5253F37Fe7500259D688a63);
  }
}
