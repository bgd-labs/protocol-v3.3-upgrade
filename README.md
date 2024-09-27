# Aave v3.2 upgrade

This repository contains contracts to upgrade existing instances of Aave protocol from v3.1.0 to v3.2.0.

<br>

## Dependencies

- Foundry, [how-to install](https://book.getfoundry.sh/getting-started/installation) (we recommend also update to the last version with `foundryup`).
- ZkSync Foundry, [how-to install](https://foundry-book.zksync.io/getting-started/installation) (we recommend also update to the last version with `foundryup-zksync`).

## Setup

```sh
cp .env.example .env
forge install

# optional, to install prettier
yarn install
```

## Tests

Command run test for all networks expect zkSync: `forge test`

Command to run test for zkSync: `FOUNDRY_PROFILE=zksync forge test --zksync`


<br>

## Specification

### [PoolInstance3_2](./src/contracts/PoolInstance.sol)

Extends `PoolInstance` contract, and includes custom initialization for the stable debt off-boarding.

The logic of the custom initialization is:
```
  currentReserve.__deprecatedStableDebtTokenAddress = address(0);
```

This makes sure that the `__deprecatedStableDebtTokenAddress` points to `address(0)` and also the `__deprecatedStableBorrowRate` is `0`

For L2s instances, an additional [L2PoolInstance3_2](./src/contracts/L2PoolInstance.sol) is included, introducing the `L2PoolInstance` contract in the inheritance chain.

<br>

### Upgrade payload

The payload for the upgrade does the following:

- Upgrades the `PoolConfigurator` implementation.
- Upgrades the `Pool` implementation.
- Connects the new `PoolDataProvider` to the `PoolAddressesProvider`.
- Deploys new InterestRateStrategy contract and updates interest rates from the previous strategy contract and sets them on the new one.
- Migrates all assets currently in eMode to be both borrowable & collateral in eMode

<br>


## License

Copyright © 2024, BGD Labs.

This repository is [MIT-licensed](./LICENSE).
