// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {DataTypes} from 'aave-v3-origin/contracts/protocol/libraries/types/DataTypes.sol';
import {IPool} from 'aave-v3-origin/contracts/interfaces/IPool.sol';
import {IPoolAddressesProvider} from 'aave-v3-origin/contracts/interfaces/IPoolAddressesProvider.sol';
import {IPoolConfigurator} from 'aave-v3-origin/contracts/interfaces/IPoolConfigurator.sol';
import {DefaultReserveInterestRateStrategyV2} from 'aave-v3-origin/contracts/misc/DefaultReserveInterestRateStrategyV2.sol';
import {IDefaultInterestRateStrategyV2} from 'aave-v3-origin/contracts/interfaces/IDefaultInterestRateStrategyV2.sol';

/**
 * @title v3.2 upgrade, with getReserveData() patch
 * @author BGD Labs
 * @dev With the 3.2 going live, we became aware of some integrations that `hard-code` the pool data provider in a non upgreadable fashion.
 * Due to this behavior their contracts are broken and funds are potentially stuck.
 * This upgrade adds a deprecated stable debt token to the `getReserveData` response, so view methods no longer revert.
 */
contract UpgradePayload {
  struct ConstructorParams {
    IPoolAddressesProvider poolAddressesProvider;
    IPool pool;
    address poolImpl;
    address poolDataProvider;
  }

  IPoolAddressesProvider public immutable POOL_ADDRESSES_PROVIDER;
  IPool public immutable POOL;
  address public immutable POOL_IMPL;
  address public immutable POOL_DATA_PROVIDER;

  constructor(ConstructorParams memory params) {
    POOL_ADDRESSES_PROVIDER = params.poolAddressesProvider;
    POOL = params.pool;
    POOL_IMPL = params.poolImpl;
    POOL_DATA_PROVIDER = params.poolDataProvider;
  }

  function execute() external {
    address[] memory reservesList = POOL.getReservesList();
    POOL_ADDRESSES_PROVIDER.setPoolImpl(POOL_IMPL);
    POOL_ADDRESSES_PROVIDER.setPoolDataProvider(POOL_DATA_PROVIDER);
    for (uint256 i = 0; i < reservesList.length; i++) {
      // as deficit is reusing old storage we ensure the storage is empty
      require(POOL.getReserveDeficit(reservesList[0]) == 0, 'STORAGE_MUST_BE_CLEAN');
    }
  }
}
