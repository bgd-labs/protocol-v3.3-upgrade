// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IPool} from 'aave-v3-origin/contracts/interfaces/IPool.sol';
import {IPoolAddressesProvider} from 'aave-v3-origin/contracts/interfaces/IPoolAddressesProvider.sol';

/**
 * @title v3.3 upgrade
 * @author BGD Labs
 * @dev Upgrade payload to upgrade the Aave v3.2 to v3.3
 * This proposal:
 * - updates the pool implementation
 * - updates the pool configurator implementation
 * - sets a new pool data provider on the pool addresses provider
 * In addition as a sanity check it iterates all reserves and ensures that the storage is clean after the upgrade.
 */
contract UpgradePayload {
  struct ConstructorParams {
    IPoolAddressesProvider poolAddressesProvider;
    IPool pool;
    address poolImpl;
    address poolDataProvider;
    address poolConfiguratorImpl;
  }

  IPoolAddressesProvider public immutable POOL_ADDRESSES_PROVIDER;
  IPool public immutable POOL;
  address public immutable POOL_IMPL;
  address public immutable POOL_CONFIGURATOR_IMPL;
  address public immutable POOL_DATA_PROVIDER;

  constructor(ConstructorParams memory params) {
    POOL_ADDRESSES_PROVIDER = params.poolAddressesProvider;
    POOL = params.pool;
    POOL_IMPL = params.poolImpl;
    POOL_CONFIGURATOR_IMPL = params.poolConfiguratorImpl;
    POOL_DATA_PROVIDER = params.poolDataProvider;
  }

  function execute() external {
    address[] memory reservesList = POOL.getReservesList();
    POOL_ADDRESSES_PROVIDER.setPoolImpl(POOL_IMPL);
    POOL_ADDRESSES_PROVIDER.setPoolConfiguratorImpl(POOL_CONFIGURATOR_IMPL);
    POOL_ADDRESSES_PROVIDER.setPoolDataProvider(POOL_DATA_PROVIDER);
    for (uint256 i = 0; i < reservesList.length; i++) {
      // as deficit is reusing old storage we ensure the storage is empty
      require(POOL.getReserveDeficit(reservesList[i]) == 0, 'STORAGE_MUST_BE_CLEAN');
    }
  }
}
