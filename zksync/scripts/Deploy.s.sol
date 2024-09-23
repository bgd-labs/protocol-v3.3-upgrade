// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {GovV3Helpers} from 'aave-helpers/src/GovV3Helpers.sol';
import {AaveProtocolDataProvider} from 'aave-v3-origin/contracts/helpers/AaveProtocolDataProvider.sol';
import {PoolConfiguratorInstance} from 'aave-v3-origin/contracts/instances/PoolConfiguratorInstance.sol';
import {IPoolAddressesProvider} from 'aave-address-book/AaveV3.sol';
import {AaveV3ZkSync} from 'aave-address-book/AaveV3ZkSync.sol';

import {UpgradePayload} from '../../src/contracts/UpgradePayload.sol';
import {PoolInstance3_2} from '../../src/contracts/PoolInstance.sol';
import {L2PoolInstance3_2} from '../../src/contracts/L2PoolInstance.sol';

library DeploymentLibrary {
  // rollups
  function _deployZKSync() internal returns (address) {
    UpgradePayload.ConstructorParams memory params;
    params.pool = AaveV3ZkSync.POOL;
    params.poolConfigurator = AaveV3ZkSync.POOL_CONFIGURATOR;
    params.poolAddressesProvider = AaveV3ZkSync.POOL_ADDRESSES_PROVIDER;
    return _deployL2(params);
  }

  function _deployL2(UpgradePayload.ConstructorParams memory params) internal returns (address) {
    params.poolImpl = GovV3Helpers.deployDeterministic(
      type(L2PoolInstance3_2).creationCode,
      abi.encode(params.poolAddressesProvider)
    );
    return _deployPayload(params);
  }

  function _deployPayload(
    UpgradePayload.ConstructorParams memory params
  ) private returns (address) {
    params.poolConfiguratorImpl = GovV3Helpers.deployDeterministic(
      type(PoolConfiguratorInstance).creationCode
    );
    params.poolDataProvider = GovV3Helpers.deployDeterministic(
      type(AaveProtocolDataProvider).creationCode,
      abi.encode(params.poolAddressesProvider)
    );
    return address(new UpgradePayload(params));
  }
}
