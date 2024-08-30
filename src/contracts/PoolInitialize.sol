// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {DataTypes} from 'aave-v3-origin/contracts/protocol/libraries/types/DataTypes.sol';
import {EModeConfiguration} from 'aave-v3-origin/contracts/protocol/libraries/configuration/EModeConfiguration.sol';
import {ReserveConfiguration as ReserveConfigurationLegacy} from './lib/LegacyReserveConfiguration.sol';

library PoolInitialize {
  using EModeConfiguration for DataTypes.EModeCategory;
  using ReserveConfigurationLegacy for DataTypes.ReserveConfigurationMap;

  function initialize(
    uint256 reservesCount,
    mapping(uint256 => address) storage _reservesList,
    mapping(address => DataTypes.ReserveData) storage _reserves,
    mapping(uint8 => DataTypes.EModeCategory) storage _eModeCategories
  ) external {
    for (uint256 i = 0; i < reservesCount; i++) {
      address currentReserveAddress = _reservesList[i];
      DataTypes.ReserveData storage currentReserve = _reserves[currentReserveAddress];
      DataTypes.ReserveConfigurationMap memory currentConfiguration = currentReserve.configuration;

      uint256 eMode = currentConfiguration.getEModeCategory();
      if (eMode != 0) {
        DataTypes.EModeCategory memory currentEMode = _eModeCategories[uint8(eMode)];
        currentEMode.setCollateral(i, true);
        currentEMode.setBorrowable(i, true);
        currentConfiguration.setEModeCategory(0);
        // store new data
        _eModeCategories[uint8(eMode)] = currentEMode;
        // clear data
        currentReserve.configuration = currentConfiguration;
      }
    }
  }
}
