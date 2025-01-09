# Aave v3.3 upgrade

This repository contains contracts to upgrade existing instances of Aave protocol from v3.2.0 to v3.3.0.

<br>

## Dependencies

- Foundry, [how-to install](https://book.getfoundry.sh/getting-started/installation) (we recommend also update to the last version with `foundryup`).
- ZkSync Foundry, [how-to install](https://foundry-book.zksync.io/getting-started/installation) (we recommend also update to the last version with `foundryup-zksync`).

## Setup

```sh
cp .env.example .env # you need to setup functional rpcs
forge install

# optional, to install prettier
yarn install
```

## Tests

Command run test for all networks expect zkSync: `forge test`

Command to run test for zkSync: `FOUNDRY_PROFILE=zksync forge test --zksync`

There are two test templates available:

- [PureTestTemplate.t.sol](./tests/PureTestTemplate.t.sol) which creates a instance of the v3.3 protocol on a pure anvil
- [UpgradeTestTemplate.t.sol](./tests/UpgradeTestTemplate.t.sol) which upgrades a existing protocol instance from 3.2 to 3.3

<br>

### Upgrade payload

The payload for the upgrade does the following:

- Upgrades the `PoolConfigurator` implementation.
- Upgrades the `Pool` implementation.
- Connects the new `PoolDataProvider` to the `PoolAddressesProvider`.

<br>

### Misc

Additionally, there are new versions of some periphery-contracts that might be deployed alongside the proposal, namely:

- `WrappedTokenGatewayV3`
- `ParaswapAdapters`
- `StataTokenFactory`

It's important to note that these contracts are:

- not part of the upgrade payload.
- they don't need to be upgraded, the old versions are perfectly operational.

Using the newer versions will result in slightly lower gas usage on certain operations.

## License

Copyright © 2024, BGD Labs.

This repository is [BUSL-1.1-licensed](./LICENSE).
