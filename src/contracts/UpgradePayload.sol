// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {DataTypes} from 'aave-v3-origin/contracts/protocol/libraries/types/DataTypes.sol';
import {IPool} from 'aave-v3-origin/contracts/interfaces/IPool.sol';
import {IPoolAddressesProvider} from 'aave-v3-origin/contracts/interfaces/IPoolAddressesProvider.sol';
import {IPoolConfigurator} from 'aave-v3-origin/contracts/interfaces/IPoolConfigurator.sol';
import {EModeConfiguration} from 'aave-v3-origin/contracts/protocol/libraries/configuration/EModeConfiguration.sol';
import {ReserveConfiguration as ReserveConfigurationLegacy} from './lib/LegacyReserveConfiguration.sol';

contract UpgradePayload {
  using EModeConfiguration for DataTypes.EModeCategory;
  using ReserveConfigurationLegacy for DataTypes.ReserveConfigurationMap;

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
    // delete and cache all eModes
    address[] memory reservesList = POOL.getReservesList();
    uint256[] memory eModeCache = new uint256[](reservesList.length);
    for (uint256 i = 0; i < reservesList.length; i++) {
      DataTypes.ReserveDataLegacy memory currentReserve = POOL.getReserveData(reservesList[i]);
      DataTypes.ReserveConfigurationMap memory currentConfiguration = currentReserve.configuration;

      uint256 eMode = currentConfiguration.getEModeCategory();
      if (eMode != 0) {
        eModeCache[i] = eMode;
        CONFIGURATOR.setAssetEModeCategory(reservesList[i], 0);
      }
    }
    // upgrade to v3.2.0
    POOL_ADDRESSES_PROVIDER.setPoolConfiguratorImpl(POOL_CONFIGURATOR_IMPL);
    POOL_ADDRESSES_PROVIDER.setPoolImpl(POOL_IMPL);
    POOL_ADDRESSES_PROVIDER.setPoolDataProvider(POOL_DATA_PROVIDER);
    // set all eModes
    for (uint256 i = 0; i < reservesList.length; i++) {
      if (eModeCache[i] != 0) {
        CONFIGURATOR.setAssetCollateralInEMode(reservesList[i], eModeCache[i], true);
        CONFIGURATOR.setAssetBorrowableInEMode(reservesList[i], eModeCache[i], true);
      }
    }
  }
}
