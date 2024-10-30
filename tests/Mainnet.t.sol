// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {UpgradeTest, IERC20} from './UpgradeTest.t.sol';
import {DeploymentLibrary} from '../scripts/Deploy.s.sol';
import {Payloads} from './Payloads.sol';
import {IPool} from 'aave-v3-origin/contracts/interfaces/IPool.sol';
import {IPriceOracleGetter} from 'aave-v3-origin/contracts/interfaces/IPriceOracleGetter.sol';
import {IERC20Detailed} from 'aave-v3-origin/contracts/dependencies/openzeppelin/contracts/IERC20Detailed.sol';
import {OwnableUpgradeable} from 'openzeppelin-contracts-upgradeable/contracts/access/OwnableUpgradeable.sol';
import {AaveV3Ethereum, AaveV3EthereumAssets} from 'aave-address-book/AaveV3Ethereum.sol';
import {AaveSafetyModule} from 'aave-address-book/AaveSafetyModule.sol';

interface VGHO {
  function getBalanceFromInterest(address user) external view returns (uint256);

  function rebalanceUserDiscountPercent(address user) external;
}

contract MainnetTest is UpgradeTest('mainnet', 20930840) {
  // address holding excess funds for borrowing etc
  address whale = makeAddr('whale');
  // liquidator
  address liquidator = makeAddr('liquidator');
  // address getting liquidated
  address borrower = makeAddr('borrower');

  function _getPayload() internal virtual override returns (address) {
    return DeploymentLibrary._deployMainnet();
  }

  function _getDeployedPayload() internal virtual override returns (address) {
    return Payloads.PROTO;
  }

  // test stub
  function test_yourTest() external {
    this.test_execution();
  }

  function _borrowAndLiquidateGHOAmount(
    IPool pool,
    address collateralAsset,
    address borrowAsset,
    uint256 borrowAmount
  ) internal {
    // supply some stkAAVE
    // deal(AaveSafetyModule.STK_AAVE, borrower, 1000 ether);
    VGHO(AaveV3EthereumAssets.GHO_V_TOKEN).rebalanceUserDiscountPercent(borrower);
    address oracle = pool.ADDRESSES_PROVIDER().getPriceOracle();

    // supply some minimal collateral to allow borrowing
    vm.startPrank(borrower);
    uint256 supplyAmount = (10 ** IERC20Detailed(collateralAsset).decimals()) /
      IPriceOracleGetter(oracle).getAssetPrice(collateralAsset) +
      1;
    deal(collateralAsset, borrower, supplyAmount);
    require(collateralAsset != borrowAsset);
    IERC20(collateralAsset).approve(address(pool), supplyAmount);
    pool.supply(collateralAsset, supplyAmount, borrower, 0);

    // set the oracle price of the borrow asset to 0
    vm.mockCall(
      oracle,
      abi.encodeWithSelector(IPriceOracleGetter.getAssetPrice.selector, address(borrowAsset)),
      abi.encode(0)
    );
    // borrow the full emount of the asset
    pool.borrow(borrowAsset, borrowAmount, 2, 0, borrower);
    // revert the oracle price
    vm.clearMockedCalls();
    vm.stopPrank();

    vm.warp(block.timestamp + 100 days);

    vm.startPrank(liquidator);
    deal(borrowAsset, liquidator, borrowAmount);
    IERC20(borrowAsset).approve(address(pool), type(uint256).max);
    pool.liquidationCall(collateralAsset, borrowAsset, borrower, type(uint256).max, false);
  }
}
