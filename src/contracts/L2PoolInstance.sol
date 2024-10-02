// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;
import {L2Pool, IPoolAddressesProvider} from 'aave-v3-origin/contracts/protocol/pool/L2Pool.sol';
import {PoolInstance3_2} from './PoolInstance.sol';

/**
 * @notice L2Pool instance
 */
contract L2PoolInstance3_2 is L2Pool, PoolInstance3_2 {
  constructor(IPoolAddressesProvider provider) PoolInstance3_2(provider) {}
}
