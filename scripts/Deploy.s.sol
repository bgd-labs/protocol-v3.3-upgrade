// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {EthereumScript, PolygonScript, AvalancheScript, OptimismScript, ArbitrumScript, MetisScript, BaseScript, GnosisScript, ScrollScript, BNBScript, LineaScript} from 'solidity-utils/contracts/utils/ScriptUtils.sol';
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
import {AaveV3Linea} from 'aave-address-book/AaveV3Linea.sol';

import {UpgradePayload} from '../src/contracts/UpgradePayload.sol';
import {PoolInstance} from 'aave-v3-origin/contracts/instances/PoolInstance.sol';
import {L2PoolInstance} from 'aave-v3-origin/contracts/instances/L2PoolInstance.sol';

library DeploymentLibrary {
  // rollups
  function _deployOptimism() internal returns (address) {
    UpgradePayload.ConstructorParams memory params;
    params.pool = AaveV3Optimism.POOL;
    params.poolAddressesProvider = AaveV3Optimism.POOL_ADDRESSES_PROVIDER;
    return _deployL2(params);
  }

  function _deployBase() internal returns (address) {
    UpgradePayload.ConstructorParams memory params;
    params.pool = AaveV3Base.POOL;
    params.poolAddressesProvider = AaveV3Base.POOL_ADDRESSES_PROVIDER;
    return _deployL2(params);
  }

  function _deployArbitrum() internal returns (address) {
    UpgradePayload.ConstructorParams memory params;
    params.pool = AaveV3Arbitrum.POOL;
    params.poolAddressesProvider = AaveV3Arbitrum.POOL_ADDRESSES_PROVIDER;
    return _deployL2(params);
  }

  function _deployScroll() internal returns (address) {
    UpgradePayload.ConstructorParams memory params;
    params.pool = AaveV3Scroll.POOL;
    params.poolAddressesProvider = AaveV3Scroll.POOL_ADDRESSES_PROVIDER;
    return _deployL2(params);
  }

  function _deployMetis() internal returns (address) {
    UpgradePayload.ConstructorParams memory params;
    params.pool = AaveV3Metis.POOL;
    params.poolAddressesProvider = AaveV3Metis.POOL_ADDRESSES_PROVIDER;
    return _deployL2(params);
  }

  // L1s
  function _deployMainnet() internal returns (address) {
    UpgradePayload.ConstructorParams memory params;
    params.pool = AaveV3Ethereum.POOL;
    params.poolAddressesProvider = AaveV3Ethereum.POOL_ADDRESSES_PROVIDER;
    return _deployL1(params);
  }

  function _deployMainnetLido() internal returns (address) {
    UpgradePayload.ConstructorParams memory params;
    params.pool = AaveV3EthereumLido.POOL;
    params.poolAddressesProvider = AaveV3EthereumLido.POOL_ADDRESSES_PROVIDER;
    return _deployL1(params);
  }

  function _deployMainnetEtherfi() internal returns (address) {
    UpgradePayload.ConstructorParams memory params;
    params.pool = AaveV3EthereumEtherFi.POOL;
    params.poolAddressesProvider = AaveV3EthereumEtherFi.POOL_ADDRESSES_PROVIDER;
    return _deployL1(params);
  }

  function _deployGnosis() internal returns (address) {
    UpgradePayload.ConstructorParams memory params;
    params.pool = AaveV3Gnosis.POOL;
    params.poolAddressesProvider = AaveV3Gnosis.POOL_ADDRESSES_PROVIDER;
    return _deployL1(params);
  }

  function _deployBNB() internal returns (address) {
    UpgradePayload.ConstructorParams memory params;
    params.pool = AaveV3BNB.POOL;
    params.poolAddressesProvider = AaveV3BNB.POOL_ADDRESSES_PROVIDER;
    return _deployL1(params);
  }

  function _deployAvalanche() internal returns (address) {
    UpgradePayload.ConstructorParams memory params;
    params.pool = AaveV3Avalanche.POOL;
    params.poolAddressesProvider = AaveV3Avalanche.POOL_ADDRESSES_PROVIDER;
    return _deployL1(params);
  }

  function _deployPolygon() internal returns (address) {
    UpgradePayload.ConstructorParams memory params;
    params.pool = AaveV3Polygon.POOL;
    params.poolAddressesProvider = AaveV3Polygon.POOL_ADDRESSES_PROVIDER;
    return _deployL1(params);
  }

  function _deployLinea() internal returns (address) {
    UpgradePayload.ConstructorParams memory params;
    params.pool = AaveV3Linea.POOL;
    params.poolAddressesProvider = AaveV3Linea.POOL_ADDRESSES_PROVIDER;
    return _deployL2(params);
  }

  function _deployL2(UpgradePayload.ConstructorParams memory params) internal returns (address) {
    params.poolImpl = GovV3Helpers.deployDeterministic(
      type(L2PoolInstance).creationCode,
      abi.encode(params.poolAddressesProvider)
    );
    L2PoolInstance(params.poolImpl).initialize(params.poolAddressesProvider);
    return _deployPayload(params);
  }

  function _deployL1(UpgradePayload.ConstructorParams memory params) internal returns (address) {
    params.poolImpl = GovV3Helpers.deployDeterministic(
      type(PoolInstance).creationCode,
      abi.encode(params.poolAddressesProvider)
    );
    PoolInstance(params.poolImpl).initialize(params.poolAddressesProvider);
    return _deployPayload(params);
  }

  function _deployPayload(
    UpgradePayload.ConstructorParams memory params
  ) private returns (address) {
    params.poolDataProvider = GovV3Helpers.deployDeterministic(
      type(AaveProtocolDataProvider).creationCode,
      abi.encode(params.poolAddressesProvider)
    );
    params.poolConfiguratorImpl = GovV3Helpers.deployDeterministic(
      type(PoolConfiguratorInstance).creationCode
    );
    // PoolConfiguratorInstance(params.poolConfiguratorImpl).initialize(params.poolAddressesProvider);
    return address(new UpgradePayload(params));
  }
}

contract Deploypolygon is PolygonScript {
  function run() external broadcast {
    DeploymentLibrary._deployPolygon();
  }
}

contract Deploygnosis is GnosisScript {
  function run() external broadcast {
    DeploymentLibrary._deployGnosis();
  }
}

contract Deployoptimism is OptimismScript {
  function run() external broadcast {
    DeploymentLibrary._deployOptimism();
  }
}

contract Deployarbitrum is ArbitrumScript {
  function run() external broadcast {
    DeploymentLibrary._deployArbitrum();
  }
}

contract Deployavalanche is AvalancheScript {
  function run() external broadcast {
    DeploymentLibrary._deployAvalanche();
  }
}

contract Deploybase is BaseScript {
  function run() external broadcast {
    DeploymentLibrary._deployBase();
  }
}

contract Deployscroll is ScrollScript {
  function run() external broadcast {
    DeploymentLibrary._deployScroll();
  }
}

contract Deploybnb is BNBScript {
  function run() external broadcast {
    DeploymentLibrary._deployBNB();
  }
}

// metis is broken
contract Deploymetis is MetisScript {
  function run() external broadcast {
    DeploymentLibrary._deployMetis();
  }
}

contract Deploymainnet is EthereumScript {
  function run() external broadcast {
    DeploymentLibrary._deployMainnet();
  }
}

contract Deploylido is EthereumScript {
  function run() external broadcast {
    DeploymentLibrary._deployMainnetLido();
  }
}

contract Deployetherfi is EthereumScript {
  function run() external broadcast {
    DeploymentLibrary._deployMainnetEtherfi();
  }
}

contract Deploylinea is LineaScript {
  function run() external broadcast {
    DeploymentLibrary._deployLinea();
  }
}
