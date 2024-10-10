// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import 'forge-std/Test.sol';
import {ProtocolV3TestBase, IPool, IPoolDataProvider, IPoolAddressesProvider} from 'aave-helpers/zksync/src/ProtocolV3TestBase.sol';
import {UpgradePayload} from '../../src/contracts/UpgradePayload.sol';

abstract contract UpgradeTest is ProtocolV3TestBase {
  string public NETWORK;
  uint256 public immutable BLOCK_NUMBER;

  constructor(string memory network, uint256 blocknumber) {
    NETWORK = network;
    BLOCK_NUMBER = blocknumber;
  }

  function setUp() public override {
    vm.createSelectFork(vm.rpcUrl(NETWORK), BLOCK_NUMBER);
    super.setUp();
  }

  function test_execution() external {
    UpgradePayload payload = UpgradePayload(_getTestPayload());
    executePayload(vm, address(payload));
  }

  function test_outdatedPdp() external {
    UpgradePayload payload = UpgradePayload(_getTestPayload());
    IPoolAddressesProvider addressesProvider = UpgradePayload(payload).POOL_ADDRESSES_PROVIDER();
    IPool pool = IPool(addressesProvider.getPool());
    address[] memory reserves = pool.getReservesList();
    for (uint256 i = 0; i < reserves.length; i++) {
      IPoolDataProvider pdp = IPoolDataProvider(_getDeprecatedPDP());
      vm.expectRevert();
      pdp.getReserveData(reserves[i]);
      vm.expectRevert();
      pdp.getTotalDebt(reserves[i]);
      vm.expectRevert();
      pdp.getUserReserveData(reserves[i], address(0));
    }
    executePayload(vm, address(payload));
    for (uint256 i = 0; i < reserves.length; i++) {
      IPoolDataProvider pdp = IPoolDataProvider(_getDeprecatedPDP());
      pdp.getReserveData(reserves[i]);
      pdp.getTotalDebt(reserves[i]);
      pdp.getUserReserveData(reserves[i], address(0));
    }
  }

  function test_diff() external {
    UpgradePayload payload = UpgradePayload(_getTestPayload());
    IPoolAddressesProvider addressesProvider = UpgradePayload(payload).POOL_ADDRESSES_PROVIDER();
    IPool pool = IPool(addressesProvider.getPool());
    defaultTest(
      string(abi.encodePacked(vm.toString(block.chainid), '_', vm.toString(address(pool)))),
      pool,
      address(payload)
    );
  }

  function _getTestPayload() internal returns (address) {
    return _getDeployedPayload();
  }

  function _getPayload() internal virtual returns (address);

  function _getDeployedPayload() internal virtual returns (address);

  function _getDeprecatedPDP() internal virtual returns (address);
}
