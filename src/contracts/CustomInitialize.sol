// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import {DataTypes} from 'aave-v3-origin/contracts/protocol/pool/Pool.sol';
import {IERC20} from 'aave-v3-origin/contracts/dependencies/openzeppelin/contracts/IERC20.sol';
import {SafeCast} from 'aave-v3-origin/contracts/dependencies/openzeppelin/contracts/SafeCast.sol';
import {WadRayMath} from 'aave-v3-origin/contracts/protocol/libraries/math/WadRayMath.sol';
import {MathUtils} from 'aave-v3-origin/contracts/protocol/libraries/math/MathUtils.sol';
import {ReserveConfiguration} from 'aave-v3-origin/contracts/protocol/libraries/configuration/ReserveConfiguration.sol';
import {ReserveLogic} from 'aave-v3-origin/contracts/protocol/libraries/logic/ReserveLogic.sol';

library CustomInitialize {
  using ReserveLogic for DataTypes.ReserveCache;
  using ReserveLogic for DataTypes.ReserveData;
  using ReserveConfiguration for DataTypes.ReserveConfigurationMap;

  function initialize(
    uint256 reservesCount,
    mapping(uint256 => address) storage _reservesList,
    mapping(address => DataTypes.ReserveData) storage _reserves
  ) internal {
    for (uint256 i = 0; i < reservesCount; i++) {
      address currentReserveAddress = _reservesList[i];
      DataTypes.ReserveData storage currentReserve = _reserves[currentReserveAddress];
      currentReserve.__deprecatedStableDebtTokenAddress = address(0);
      require(currentReserve.__deprecatedStableBorrowRate == 0);
    }
  }
}
