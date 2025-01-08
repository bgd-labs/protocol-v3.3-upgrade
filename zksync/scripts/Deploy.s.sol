// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {ZkSyncScript} from 'solidity-utils/contracts/utils/ScriptUtils.sol';
import {AaveProtocolDataProvider} from 'aave-v3-origin/contracts/helpers/AaveProtocolDataProvider.sol';
import {PoolConfiguratorInstance} from 'aave-v3-origin/contracts/instances/PoolConfiguratorInstance.sol';
import {IPoolAddressesProvider} from 'aave-address-book/AaveV3.sol';
import {AaveV3ZkSync} from 'aave-address-book/AaveV3ZkSync.sol';

import {UpgradePayload} from '../../src/contracts/UpgradePayload.sol';
import {PoolInstance} from 'aave-v3-origin/contracts/instances/PoolInstance.sol';

library DeploymentLibrary {
  function _deployZKSync() internal returns (address) {
    UpgradePayload.ConstructorParams memory params;
    params.pool = AaveV3ZkSync.POOL;
    params.poolAddressesProvider = AaveV3ZkSync.POOL_ADDRESSES_PROVIDER;
    return _deployL1(params);
  }

  function _deployL1(UpgradePayload.ConstructorParams memory params) internal returns (address) {
    params.poolImpl = address(new PoolInstance{salt: 'v1'}(params.poolAddressesProvider));
    PoolInstance(params.poolImpl).initialize(params.poolAddressesProvider);
    return _deployPayload(params);
  }

  function _deployPayload(
    UpgradePayload.ConstructorParams memory params
  ) private returns (address) {
    params.poolConfiguratorImpl = address(new PoolConfiguratorInstance{salt: 'v1'}());
    params.poolDataProvider = address(
      new AaveProtocolDataProvider{salt: 'v1'}(params.poolAddressesProvider)
    );
    return address(new UpgradePayload(params));
  }
}

contract Deployzksync is ZkSyncScript {
  function run() external broadcast {
    DeploymentLibrary._deployZKSync();
  }
}
