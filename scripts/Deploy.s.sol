// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {GovV3Helpers} from 'aave-helpers/src/GovV3Helpers.sol';
import {AaveProtocolDataProvider} from 'aave-v3-origin/contracts/helpers/AaveProtocolDataProvider.sol';
import {PoolConfiguratorInstance} from 'aave-v3-origin/contracts/instances/PoolConfiguratorInstance.sol';
import {IPoolAddressesProvider} from 'aave-address-book/AaveV3.sol';
import {AaveV3Polygon} from 'aave-address-book/AaveV3Polygon.sol';

import {UpgradePayload} from '../src/contracts/UpgradePayload.sol';
import {PoolInstanceRev5} from '../src/contracts/PoolInstance.sol';

library DeploymentLibrary {
  function _deployPolygon() internal returns (address) {
    UpgradePayload.ConstructorParams memory params;
    params.pool = AaveV3Polygon.POOL;
    params.poolConfigurator = AaveV3Polygon.POOL_CONFIGURATOR;
    params.poolAddressesProvider = AaveV3Polygon.POOL_ADDRESSES_PROVIDER;
    return _deployL1(params);
  }

  // function _deployL2(DeployPoolImplementationParams memory params) internal returns (address) {
  //   address poolImpl = GovV3Helpers.deployDeterministic(
  //     type(L2PoolInstanceWithCustomInitialize).creationCode,
  //     abi.encode(params.poolAddressesProvider)
  //   );
  //   return
  //     _deployPayload(
  //       DeployPayloadParams({
  //         poolAddressesProvider: params.poolAddressesProvider,
  //         pool: params.pool,
  //         poolConfigurator: params.poolConfigurator,
  //         poolImpl: poolImpl,
  //         proofOfReserveExecutor: params.proofOfReserveExecutor
  //       })
  //     );
  // }

  function _deployL1(UpgradePayload.ConstructorParams memory params) internal returns (address) {
    params.poolImpl = GovV3Helpers.deployDeterministic(
      type(PoolInstanceRev5).creationCode,
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
