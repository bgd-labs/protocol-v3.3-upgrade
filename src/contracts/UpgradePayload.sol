// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IPool} from 'aave-v3-origin/contracts/interfaces/IPool.sol';
import {IPoolAddressesProvider} from 'aave-v3-origin/contracts/interfaces/IPoolAddressesProvider.sol';
import {IPoolConfigurator} from 'aave-v3-origin/contracts/interfaces/IPoolConfigurator.sol';

contract UpgradePayload {
  struct ConstructorParams {
    address poolAddressesProvider;
    address pool;
    address poolConfigurator;
    address poolImpl;
    address poolConfiguratorImpl;
    address poolDataProvider;
  }

  IPoolAddressesProvider public immutable POOL_ADDRESSES_PROVIDER;
  IPool public immutable POOL;
  IPoolConfigurator public immutable CONFIGURATOR;
  address public immutable POOL_IMPL;
  address public immutable POOL_CONFIGURATOR_IMPL;
  address public immutable POOL_DATA_PROVIDER;

  constructor(ConstructorParams memory params) {
    POOL_ADDRESSES_PROVIDER = IPoolAddressesProvider(params.poolAddressesProvider);
    POOL = IPool(params.pool);
    CONFIGURATOR = IPoolConfigurator(params.poolConfigurator);
    POOL_IMPL = params.poolImpl;
    POOL_CONFIGURATOR_IMPL = params.poolConfiguratorImpl;
    POOL_DATA_PROVIDER = params.poolDataProvider;
  }

  function execute() external {
    POOL_ADDRESSES_PROVIDER.setPoolConfiguratorImpl(POOL_CONFIGURATOR_IMPL);
    POOL_ADDRESSES_PROVIDER.setPoolImpl(POOL_IMPL);
    POOL_ADDRESSES_PROVIDER.setPoolDataProvider(POOL_DATA_PROVIDER);
  }
}
