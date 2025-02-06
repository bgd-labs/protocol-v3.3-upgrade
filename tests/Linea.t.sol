// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {ProtocolV3TestBase, IPool, IPoolDataProvider, IPoolAddressesProvider, IERC20} from 'aave-helpers/src/ProtocolV3TestBase.sol';
import {GovV3Helpers} from 'aave-helpers/src/GovV3Helpers.sol';
import {UpgradeTest} from './UpgradeTest.t.sol';
import {DeploymentLibrary} from '../scripts/Deploy.s.sol';
import {Payloads} from './Payloads.sol';
import {UpgradePayload} from '../src/contracts/UpgradePayload.sol';

contract LineaTest is UpgradeTest('linea', 15493477) {
  function _getPayload() internal virtual override returns (address) {
    return DeploymentLibrary._deployLinea();
  }

  function _getDeployedPayload() internal virtual override returns (address) {
    return Payloads.LINEA;
  }

  function test_diff() external virtual override {
    GovV3Helpers.executePayload(vm, 3);
    UpgradePayload payload = UpgradePayload(_getTestPayload());
    IPoolAddressesProvider addressesProvider = payload.POOL_ADDRESSES_PROVIDER();
    IPool pool = IPool(addressesProvider.getPool());
    defaultTest(
      string(abi.encodePacked(vm.toString(block.chainid), '_', vm.toString(address(pool)))),
      pool,
      address(payload)
    );
  }
}
