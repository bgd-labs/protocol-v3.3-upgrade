// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import 'forge-std/Test.sol';
import {TestnetProcedures} from 'aave-v3-origin-tests/utils/TestnetProcedures.sol';
import {UpgradePayload} from '../src/contracts/UpgradePayload.sol';
import {DeploymentLibrary} from '../scripts/Deploy.s.sol';

/**
 * @dev This is a test template starting with a fresh version of aave v3.3.
 * Check https://github.com/bgd-labs/aave-v3-origin-private/blob/v3.3.0/tests/utils/TestnetProcedures.sol#L50 to familiarize with the environment.
 * run via: `forge test --mc PureTestTemplate`
 */
contract PureTestTemplate is TestnetProcedures {
  function setUp() external {
    initTestEnvironment();
  }

  function test_template() external {
    // ..
    // contracts.poolProxy.supply(tokenList.wbtc, 1e8, bob, 0);
    // ..
  }
}
