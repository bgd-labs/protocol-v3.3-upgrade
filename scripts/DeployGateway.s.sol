// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import {Script, EthereumScript, PolygonScript, AvalancheScript, OptimismScript, ArbitrumScript, MetisScript, BaseScript, GnosisScript, ScrollScript, BNBScript, LineaScript} from 'solidity-utils/contracts/utils/ScriptUtils.sol';
import {WrappedTokenGatewayV3} from 'aave-v3-origin/contracts/helpers/WrappedTokenGatewayV3.sol';

import {AaveV3Polygon, AaveV3PolygonAssets} from 'aave-address-book/AaveV3Polygon.sol';
import {GovernanceV3Polygon} from 'aave-address-book/GovernanceV3Polygon.sol';

import {AaveV3Avalanche, AaveV3AvalancheAssets} from 'aave-address-book/AaveV3Avalanche.sol';
import {GovernanceV3Avalanche} from 'aave-address-book/GovernanceV3Avalanche.sol';

import {AaveV3Optimism, AaveV3OptimismAssets} from 'aave-address-book/AaveV3Optimism.sol';
import {GovernanceV3Optimism} from 'aave-address-book/GovernanceV3Optimism.sol';

import {AaveV3Arbitrum, AaveV3ArbitrumAssets} from 'aave-address-book/AaveV3Arbitrum.sol';
import {GovernanceV3Arbitrum} from 'aave-address-book/GovernanceV3Arbitrum.sol';

import {AaveV3Ethereum, AaveV3EthereumAssets} from 'aave-address-book/AaveV3Ethereum.sol';
import {GovernanceV3Ethereum} from 'aave-address-book/GovernanceV3Ethereum.sol';

import {AaveV3BNB, AaveV3BNBAssets} from 'aave-address-book/AaveV3BNB.sol';
import {GovernanceV3BNB} from 'aave-address-book/GovernanceV3BNB.sol';

import {AaveV3Gnosis, AaveV3GnosisAssets} from 'aave-address-book/AaveV3Gnosis.sol';
import {GovernanceV3Gnosis} from 'aave-address-book/GovernanceV3Gnosis.sol';

import {AaveV3Scroll, AaveV3ScrollAssets} from 'aave-address-book/AaveV3Scroll.sol';
import {GovernanceV3Scroll} from 'aave-address-book/GovernanceV3Scroll.sol';

import {AaveV3Base, AaveV3BaseAssets} from 'aave-address-book/AaveV3Base.sol';
import {GovernanceV3Base} from 'aave-address-book/GovernanceV3Base.sol';

import {AaveV3Metis, AaveV3MetisAssets} from 'aave-address-book/AaveV3Metis.sol';
import {GovernanceV3Metis} from 'aave-address-book/GovernanceV3Metis.sol';

import {AaveV3Linea, AaveV3LineaAssets} from 'aave-address-book/AaveV3Linea.sol';
import {GovernanceV3Linea} from 'aave-address-book/GovernanceV3Linea.sol';

import {AaveV3EthereumLido, AaveV3EthereumLidoAssets} from 'aave-address-book/AaveV3EthereumLido.sol';
import {AaveV3EthereumEtherFi, AaveV3EthereumEtherFiAssets} from 'aave-address-book/AaveV3EthereumEtherFi.sol';

library DeploymentLibrary {
  // rollups
  function _deployOptimism() internal returns (WrappedTokenGatewayV3) {
    return
      new WrappedTokenGatewayV3(
        AaveV3OptimismAssets.WETH_UNDERLYING,
        GovernanceV3Optimism.EXECUTOR_LVL_1,
        AaveV3Optimism.POOL
      );
  }

  function _deployBase() internal returns (WrappedTokenGatewayV3) {
    return
      new WrappedTokenGatewayV3(
        AaveV3BaseAssets.WETH_UNDERLYING,
        GovernanceV3Base.EXECUTOR_LVL_1,
        AaveV3Base.POOL
      );
  }

  function _deployArbitrum() internal returns (WrappedTokenGatewayV3) {
    return
      new WrappedTokenGatewayV3(
        AaveV3ArbitrumAssets.WETH_UNDERLYING,
        GovernanceV3Arbitrum.EXECUTOR_LVL_1,
        AaveV3Arbitrum.POOL
      );
  }

  function _deployScroll() internal returns (WrappedTokenGatewayV3) {
    return
      new WrappedTokenGatewayV3(
        AaveV3ScrollAssets.WETH_UNDERLYING,
        GovernanceV3Scroll.EXECUTOR_LVL_1,
        AaveV3Scroll.POOL
      );
  }

  function _deployMetis() internal returns (WrappedTokenGatewayV3) {
    return
      new WrappedTokenGatewayV3(
        AaveV3MetisAssets.WETH_UNDERLYING,
        GovernanceV3Metis.EXECUTOR_LVL_1,
        AaveV3Metis.POOL
      );
  }

  // L1s
  function _deployMainnet() internal returns (WrappedTokenGatewayV3) {
    return
      new WrappedTokenGatewayV3(
        AaveV3EthereumAssets.WETH_UNDERLYING,
        GovernanceV3Ethereum.EXECUTOR_LVL_1,
        AaveV3Ethereum.POOL
      );
  }

  function _deployMainnetLido() internal returns (WrappedTokenGatewayV3) {
    return
      new WrappedTokenGatewayV3(
        AaveV3EthereumLidoAssets.WETH_UNDERLYING,
        GovernanceV3Ethereum.EXECUTOR_LVL_1,
        AaveV3EthereumLido.POOL
      );
  }

  function _deployMainnetEtherfi() internal returns (WrappedTokenGatewayV3) {
    return
      new WrappedTokenGatewayV3(
        AaveV3EthereumLidoAssets.WETH_UNDERLYING,
        GovernanceV3Ethereum.EXECUTOR_LVL_1,
        AaveV3EthereumEtherFi.POOL
      );
  }

  function _deployGnosis() internal returns (WrappedTokenGatewayV3) {
    return
      new WrappedTokenGatewayV3(
        AaveV3GnosisAssets.WETH_UNDERLYING,
        GovernanceV3Gnosis.EXECUTOR_LVL_1,
        AaveV3Gnosis.POOL
      );
  }

  function _deployBNB() internal returns (WrappedTokenGatewayV3) {
    return
      new WrappedTokenGatewayV3(
        AaveV3BNBAssets.WBNB_UNDERLYING,
        GovernanceV3BNB.EXECUTOR_LVL_1,
        AaveV3BNB.POOL
      );
  }

  function _deployAvalanche() internal returns (WrappedTokenGatewayV3) {
    return
      new WrappedTokenGatewayV3(
        AaveV3AvalancheAssets.WAVAX_UNDERLYING,
        GovernanceV3Avalanche.EXECUTOR_LVL_1,
        AaveV3Avalanche.POOL
      );
  }

  function _deployPolygon() internal returns (WrappedTokenGatewayV3) {
    return
      new WrappedTokenGatewayV3(
        AaveV3PolygonAssets.WPOL_UNDERLYING,
        GovernanceV3Polygon.EXECUTOR_LVL_1,
        AaveV3Polygon.POOL
      );
  }

  function _deployLinea() internal returns (WrappedTokenGatewayV3) {
    return
      new WrappedTokenGatewayV3(
        AaveV3LineaAssets.WETH_UNDERLYING,
        GovernanceV3Linea.EXECUTOR_LVL_1,
        AaveV3Linea.POOL
      );
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
    DeploymentLibrary._deployMainnetEtherfi();
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
