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

### Diffs

The repository contains [code-diffs](./diffs/code) for all the targeted networks.
The diffs were created by diffing the verified implementations etherscan code against new implementations etherscan code.
Once the diff is created the script deletes all duplicates, so eventually what is left is the differences between the different instances.
As expected:

- the diff on [mainnet](./diffs/code/1) reflects the changes from the [v3.3.0 branch](https://github.com/aave-dao/aave-v3-origin/pull/87).
- the diff on [optimism](./diffs/code/2) reflects the changes from the [v3.3.0 branch](https://github.com/aave-dao/aave-v3-origin/pull/87) but for a `L2Pool`.
  In addition, the diff on [`Pool`](./diffs/code/10/0x7A7eF57479123f26DB6a0e3EFbF8A3562EDD65BE_0x7f775bb7af2e7E09D5Dc9506c95516159a5cA0D0/Pool.sol.patch) is slightly different, be cause the Pool instance comments were slightly outdated.
- the diff on [metis](./diffs/code/1088) is limited again to a [changed license](./diffs/code/1088/0x4816b2C2895f97fB918f1aE7Da403750a0eE372e_0xE5e48Ad1F9D1A894188b483DcF91f4FaD6AbA43b/PoolConfiguratorInstance.sol.patch).
- all other instances have **no** diff at all, or a diff that is limited to the `settings`, which describes some differences in comparison to the previous deployment process (e.g. usage of bytecodehash, remappings etc)but does not result in different code.

## License

Copyright © 2024, BGD Labs.

This repository is [BUSL-1.1-licensed](./LICENSE).
