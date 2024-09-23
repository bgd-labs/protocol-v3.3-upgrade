// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {DataTypes} from 'aave-v3-origin/contracts/protocol/libraries/types/DataTypes.sol';
import {IPool} from 'aave-v3-origin/contracts/interfaces/IPool.sol';
import {IPoolAddressesProvider} from 'aave-v3-origin/contracts/interfaces/IPoolAddressesProvider.sol';
import {IPoolConfigurator} from 'aave-v3-origin/contracts/interfaces/IPoolConfigurator.sol';
import {EModeConfiguration} from 'aave-v3-origin/contracts/protocol/libraries/configuration/EModeConfiguration.sol';
import {DefaultReserveInterestRateStrategyV2} from 'aave-v3-origin/contracts/misc/DefaultReserveInterestRateStrategyV2.sol';
import {IDefaultInterestRateStrategyV2} from 'aave-v3-origin/contracts/interfaces/IDefaultInterestRateStrategyV2.sol';
import {ReserveConfiguration as ReserveConfigurationLegacy} from './lib/LegacyReserveConfiguration.sol';

contract UpgradePayload {
  using EModeConfiguration for DataTypes.EModeCategory;
  using ReserveConfigurationLegacy for DataTypes.ReserveConfigurationMap;

  struct ConstructorParams {
    IPoolAddressesProvider poolAddressesProvider;
    IPool pool;
    IPoolConfigurator poolConfigurator;
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
    POOL_ADDRESSES_PROVIDER = params.poolAddressesProvider;
    POOL = params.pool;
    CONFIGURATOR = params.poolConfigurator;
    POOL_IMPL = params.poolImpl;
    POOL_CONFIGURATOR_IMPL = params.poolConfiguratorImpl;
    POOL_DATA_PROVIDER = params.poolDataProvider;
  }

  function execute() external {
    // delete and cache all eModes
    address[] memory reservesList = POOL.getReservesList();
    uint8[] memory eModeCache = new uint8[](reservesList.length);
    bytes[] memory cachedInterestRate = new bytes[](reservesList.length);
    for (uint256 i = 0; i < reservesList.length; i++) {
      DataTypes.ReserveDataLegacy memory reserveData = POOL.getReserveData(reservesList[i]);
      DataTypes.ReserveConfigurationMap memory currentConfiguration = reserveData.configuration;

      cachedInterestRate[i] = abi.encode(
        IDefaultInterestRateStrategyV2(reserveData.interestRateStrategyAddress)
          .getInterestRateDataBps(reservesList[i])
      );

      uint8 eMode = uint8(currentConfiguration.getEModeCategory());
      if (eMode != 0) {
        eModeCache[i] = eMode;
      }
    }
    // upgrade to v3.2.0
    POOL_ADDRESSES_PROVIDER.setPoolConfiguratorImpl(POOL_CONFIGURATOR_IMPL);
    POOL_ADDRESSES_PROVIDER.setPoolImpl(POOL_IMPL);
    POOL_ADDRESSES_PROVIDER.setPoolDataProvider(POOL_DATA_PROVIDER);
    DefaultReserveInterestRateStrategyV2 strategy = new DefaultReserveInterestRateStrategyV2(
      address(POOL_ADDRESSES_PROVIDER)
    );
    for (uint256 i = 0; i < reservesList.length; i++) {
      // set all eModes
      if (eModeCache[i] != 0) {
        CONFIGURATOR.setAssetCollateralInEMode(reservesList[i], eModeCache[i], true);
        CONFIGURATOR.setAssetBorrowableInEMode(reservesList[i], eModeCache[i], true);
      }
      // set all irs
      CONFIGURATOR.setReserveInterestRateStrategyAddress(
        reservesList[i],
        address(strategy),
        cachedInterestRate[i]
      );
    }
  }
}
