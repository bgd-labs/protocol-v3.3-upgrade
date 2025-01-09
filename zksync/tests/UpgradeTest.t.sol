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

  // skipping test as no the implementations are not yet deployed, so code diffing does not workq
  function test_diff() external {
    vm.skip(true);
    UpgradePayload payload = UpgradePayload(_getTestPayload());
    IPoolAddressesProvider addressesProvider = UpgradePayload(payload).POOL_ADDRESSES_PROVIDER();
    IPool pool = IPool(addressesProvider.getPool());
    defaultTest(
      string(abi.encodePacked(vm.toString(block.chainid), '_', vm.toString(address(pool)))),
      pool,
      address(payload)
    );
  }

  // skipping test as no payloads are deployed yet
  function test_ensureDeployed() external {
    vm.skip(true);
    require(_getDeployedPayload() != address(0));
  }

  function _getTestPayload() internal returns (address) {
    address deployed = _getDeployedPayload();
    if (deployed == address(0)) return _getPayload();
    return deployed;
  }

  function _getPayload() internal virtual returns (address);

  function _getDeployedPayload() internal virtual returns (address);
}
