// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import {GovV3Helpers} from 'aave-helpers/src/GovV3Helpers.sol';
import {AaveProtocolDataProvider} from 'aave-v3-origin/contracts/helpers/AaveProtocolDataProvider.sol';
import {PoolConfiguratorInstance} from 'aave-v3-origin/contracts/instances/PoolConfiguratorInstance.sol';

library DeploymentLibrary {
  function _deployPolygon() internal returns (address) {
    return _deployPayload();
  }

  function _deployPayload() internal returns (address) {
    // address poolConfiguratorImpl = GovV3Helpers.deployDeterministic(
    //   type(PoolConfiguratorInstance).creationCode
    // );
    // address poolDataProvider = GovV3Helpers.deployDeterministic(
    //   type(AaveProtocolDataProvider).creationCode,
    //   abi.encode(params.poolAddressesProvider)
    // );
    return address(0);
  }
}
