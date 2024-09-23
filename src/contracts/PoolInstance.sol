// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {PoolInstance} from 'aave-v3-origin/contracts/instances/PoolInstance.sol';
import {IPoolAddressesProvider, Errors} from 'aave-v3-origin/contracts/protocol/pool/Pool.sol';
import {CustomInitialize} from './CustomInitialize.sol';

/**
 * @notice Pool instance
 */
contract PoolInstanceRev5 is PoolInstance {
  constructor(IPoolAddressesProvider provider) PoolInstance(provider) {}

  function initialize(IPoolAddressesProvider provider) external virtual override initializer {
    require(provider == ADDRESSES_PROVIDER, Errors.INVALID_ADDRESSES_PROVIDER);
    CustomInitialize.initialize(_reservesCount, _reservesList, _reserves);
  }
}
