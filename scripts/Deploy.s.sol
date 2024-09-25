// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {EthereumScript, PolygonScript, AvalancheScript, OptimismScript, ArbitrumScript, MetisScript, BaseScript, GnosisScript, ScrollScript, BNBScript} from 'solidity-utils/contracts/utils/ScriptUtils.sol';
import {GovV3Helpers} from 'aave-helpers/src/GovV3Helpers.sol';
import {AaveProtocolDataProvider} from 'aave-v3-origin/contracts/helpers/AaveProtocolDataProvider.sol';
import {PoolConfiguratorInstance} from 'aave-v3-origin/contracts/instances/PoolConfiguratorInstance.sol';
import {IPoolAddressesProvider} from 'aave-address-book/AaveV3.sol';
import {AaveV3Polygon} from 'aave-address-book/AaveV3Polygon.sol';
import {AaveV3Avalanche} from 'aave-address-book/AaveV3Avalanche.sol';
import {AaveV3Optimism} from 'aave-address-book/AaveV3Optimism.sol';
import {AaveV3Arbitrum} from 'aave-address-book/AaveV3Arbitrum.sol';
import {AaveV3Ethereum} from 'aave-address-book/AaveV3Ethereum.sol';
import {AaveV3BNB} from 'aave-address-book/AaveV3BNB.sol';
import {AaveV3Gnosis} from 'aave-address-book/AaveV3Gnosis.sol';
import {AaveV3Scroll} from 'aave-address-book/AaveV3Scroll.sol';
import {AaveV3Base} from 'aave-address-book/AaveV3Base.sol';
import {AaveV3Metis} from 'aave-address-book/AaveV3Metis.sol';
import {AaveV3EthereumLido} from 'aave-address-book/AaveV3EthereumLido.sol';
import {AaveV3EthereumEtherFi} from 'aave-address-book/AaveV3EthereumEtherFi.sol';

import {UpgradePayload} from '../src/contracts/UpgradePayload.sol';
import {PoolInstance3_2} from '../src/contracts/PoolInstance.sol';
import {L2PoolInstance3_2} from '../src/contracts/L2PoolInstance.sol';

library DeploymentLibrary {
  // rollups
  function _deployOptimism() internal returns (address) {
    UpgradePayload.ConstructorParams memory params;
    params.pool = AaveV3Optimism.POOL;
    params.poolConfigurator = AaveV3Optimism.POOL_CONFIGURATOR;
    params.poolAddressesProvider = AaveV3Optimism.POOL_ADDRESSES_PROVIDER;
    return _deployL2(params);
  }

  function _deployBase() internal returns (address) {
    UpgradePayload.ConstructorParams memory params;
    params.pool = AaveV3Base.POOL;
    params.poolConfigurator = AaveV3Base.POOL_CONFIGURATOR;
    params.poolAddressesProvider = AaveV3Base.POOL_ADDRESSES_PROVIDER;
    return _deployL2(params);
  }

  function _deployArbitrum() internal returns (address) {
    UpgradePayload.ConstructorParams memory params;
    params.pool = AaveV3Arbitrum.POOL;
    params.poolConfigurator = AaveV3Arbitrum.POOL_CONFIGURATOR;
    params.poolAddressesProvider = AaveV3Arbitrum.POOL_ADDRESSES_PROVIDER;
    return _deployL2(params);
  }

  function _deployScroll() internal returns (address) {
    UpgradePayload.ConstructorParams memory params;
    params.pool = AaveV3Scroll.POOL;
    params.poolConfigurator = AaveV3Scroll.POOL_CONFIGURATOR;
    params.poolAddressesProvider = AaveV3Scroll.POOL_ADDRESSES_PROVIDER;
    return _deployL2(params);
  }

  function _deployMetis() internal returns (address) {
    UpgradePayload.ConstructorParams memory params;
    params.pool = AaveV3Metis.POOL;
    params.poolConfigurator = AaveV3Metis.POOL_CONFIGURATOR;
    params.poolAddressesProvider = AaveV3Metis.POOL_ADDRESSES_PROVIDER;
    return _deployL2(params);
  }

  // L1s
  function _deployMainnet() internal returns (address) {
    UpgradePayload.ConstructorParams memory params;
    params.pool = AaveV3Ethereum.POOL;
    params.poolConfigurator = AaveV3Ethereum.POOL_CONFIGURATOR;
    params.poolAddressesProvider = AaveV3Ethereum.POOL_ADDRESSES_PROVIDER;
    return _deployL1(params);
  }

  function _deployMainnetLido() internal returns (address) {
    UpgradePayload.ConstructorParams memory params;
    params.pool = AaveV3EthereumLido.POOL;
    params.poolConfigurator = AaveV3EthereumLido.POOL_CONFIGURATOR;
    params.poolAddressesProvider = AaveV3EthereumLido.POOL_ADDRESSES_PROVIDER;
    return _deployL1(params);
  }

  function _deployMainnetEtherfi() internal returns (address) {
    UpgradePayload.ConstructorParams memory params;
    params.pool = AaveV3EthereumEtherFi.POOL;
    params.poolConfigurator = AaveV3EthereumEtherFi.POOL_CONFIGURATOR;
    params.poolAddressesProvider = AaveV3EthereumEtherFi.POOL_ADDRESSES_PROVIDER;
    return _deployL1(params);
  }

  function _deployGnosis() internal returns (address) {
    UpgradePayload.ConstructorParams memory params;
    params.pool = AaveV3Gnosis.POOL;
    params.poolConfigurator = AaveV3Gnosis.POOL_CONFIGURATOR;
    params.poolAddressesProvider = AaveV3Gnosis.POOL_ADDRESSES_PROVIDER;
    return _deployL1(params);
  }

  function _deployBNB() internal returns (address) {
    UpgradePayload.ConstructorParams memory params;
    params.pool = AaveV3BNB.POOL;
    params.poolConfigurator = AaveV3BNB.POOL_CONFIGURATOR;
    params.poolAddressesProvider = AaveV3BNB.POOL_ADDRESSES_PROVIDER;
    return _deployL1(params);
  }

  function _deployAvalanche() internal returns (address) {
    UpgradePayload.ConstructorParams memory params;
    params.pool = AaveV3Avalanche.POOL;
    params.poolConfigurator = AaveV3Avalanche.POOL_CONFIGURATOR;
    params.poolAddressesProvider = AaveV3Avalanche.POOL_ADDRESSES_PROVIDER;
    return _deployL1(params);
  }

  function _deployPolygon() internal returns (address) {
    UpgradePayload.ConstructorParams memory params;
    params.pool = AaveV3Polygon.POOL;
    params.poolConfigurator = AaveV3Polygon.POOL_CONFIGURATOR;
    params.poolAddressesProvider = AaveV3Polygon.POOL_ADDRESSES_PROVIDER;
    return _deployL1(params);
  }

  function _deployL2(UpgradePayload.ConstructorParams memory params) internal returns (address) {
    params.poolImpl = GovV3Helpers.deployDeterministic(
      type(L2PoolInstance3_2).creationCode,
      abi.encode(params.poolAddressesProvider)
    );
    return _deployPayload(params);
  }

  function _deployL1(UpgradePayload.ConstructorParams memory params) internal returns (address) {
    params.poolImpl = GovV3Helpers.deployDeterministic(
      type(PoolInstance3_2).creationCode,
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

contract Deploypolygon is PolygonScript {
  function run() external broadcast {
    DeploymentLibrary._deployPolygon();
  }
}
