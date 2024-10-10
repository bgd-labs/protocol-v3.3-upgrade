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

/**
 * @title v3.2 upgrade, with getReserveData() patch
 * @author BGD Labs
 * @dev With the 3.2 going live, we became aware of some integrations that `hard-code` the pool data provider in a non upgreadable fashion.
 * Due to this behavior their contracts are broken and funds are potentially stuck.
 * This upgrade adds a deprecated stable debt token to the `getReserveData` response, so view methods no longer revert.
 */
contract UpgradePayload {
  using EModeConfiguration for DataTypes.EModeCategory;
  using ReserveConfigurationLegacy for DataTypes.ReserveConfigurationMap;

  struct ConstructorParams {
    IPoolAddressesProvider poolAddressesProvider;
    address poolImpl;
    address stableDebtToken;
  }

  IPoolAddressesProvider public immutable POOL_ADDRESSES_PROVIDER;
  address public immutable POOL_IMPL;
  address public immutable STABLE_DEBT_TOKEN;

  constructor(ConstructorParams memory params) {
    require(params.stableDebtToken != address(0), 'MOCK_TOKEN_MUST_BE_SET');
    POOL_ADDRESSES_PROVIDER = params.poolAddressesProvider;
    POOL_IMPL = params.poolImpl;
    STABLE_DEBT_TOKEN = params.stableDebtToken;
  }

  function execute() external {
    POOL_ADDRESSES_PROVIDER.setPoolImpl(POOL_IMPL);
    POOL_ADDRESSES_PROVIDER.setAddress(bytes32('MOCK_STABLE_DEBT'), STABLE_DEBT_TOKEN);
  }
}
