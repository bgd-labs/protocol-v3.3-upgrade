// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import {WrappedTokenGatewayV3} from 'aave-v3-origin/contracts/helpers/WrappedTokenGatewayV3.sol';

import 'forge-std/Test.sol';
import {ProtocolV3TestBase, IPool, IPoolDataProvider, IPoolAddressesProvider, IERC20} from 'aave-helpers/src/ProtocolV3TestBase.sol';
import {UpgradePayload} from '../src/contracts/UpgradePayload.sol';

abstract contract UpgradeTest is ProtocolV3TestBase {
  string public NETWORK;
  uint256 public immutable BLOCK_NUMBER;

  constructor(string memory network, uint256 blocknumber) {
    NETWORK = network;
    BLOCK_NUMBER = blocknumber;
  }

  function setUp() public {
    vm.createSelectFork(vm.rpcUrl(NETWORK), BLOCK_NUMBER);
  }

  function test_execution() public virtual {
    UpgradePayload payload = UpgradePayload(_getTestPayload());
    executePayload(vm, address(payload));
  }

  function test_diff() external virtual {
    UpgradePayload payload = UpgradePayload(_getTestPayload());
    IPoolAddressesProvider addressesProvider = payload.POOL_ADDRESSES_PROVIDER();
    IPool pool = IPool(addressesProvider.getPool());
    defaultTest(
      string(abi.encodePacked(vm.toString(block.chainid), '_', vm.toString(address(pool)))),
      pool,
      address(payload)
    );
  }

  function test_ensureDeployed() external {
    require(_getDeployedPayload() != address(0));
  }

  /**
   *
   */
  function _getTestPayload() internal returns (address) {
    address deployed = _getDeployedPayload();
    if (deployed == address(0)) return _getPayload();
    return deployed;
  }

  function _getPayload() internal virtual returns (address);

  function _getDeployedPayload() internal virtual returns (address);
}
