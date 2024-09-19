// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import {L2Pool, IPoolAddressesProvider} from 'aave-v3-origin/contracts/protocol/pool/L2Pool.sol';
import {PoolInstanceRev5} from './PoolInstance.sol';

/**
 * @notice L2Pool instance
 */
contract L2PoolInstanceRev5 is L2Pool, PoolInstanceRev5 {
  constructor(IPoolAddressesProvider provider) PoolInstanceRev5(provider) {}
}
