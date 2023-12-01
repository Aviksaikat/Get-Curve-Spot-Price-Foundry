// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;

import {Test} from "forge-std/Test.sol";
import "forge-std/console.sol";
import {CurveSpotPrice} from "src/CurveSpotPrice.s.sol";
import "src/interfaces/IMetaPoolRegistry.sol";

import "src/interfaces/IMetaPoolRegistry.sol";
import "src/interfaces/ICurvePool.sol";

contract GetPrice is Test {
    CurveSpotPrice public spotPriceContract;
    uint256 mainnetFork;
    string MAINNET_RPC_URL = vm.envString("WEB3_INFURA_RPC");

    address immutable metaPoolRegistryContractAddress = 0xF98B45FA17DE75FB1aD0e7aFD971b0ca00e379fC;
    address immutable DAI_ADDRESS = 0x6B175474E89094C44Da98b954EedeAC495271d0F;
    address immutable USDC_ADDRESS = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;

    address public sender = address(1337);

    address public poolAddress;

    IMetaPoolRegistry private metaPoolRegistryContract;
    ICurvePool private poolContract;

    function setUp() public {
        mainnetFork = vm.createFork(MAINNET_RPC_URL);
        // spotPriceContract = new CurveSpotPrice(metaPoolRegistryContractAddress);
    }

    function _curveMetaPool(address pool, address tokenIn, address tokenOut, uint256 amount) public returns (uint256) {
        int128 i = 0;
        int128 j = 0;
        uint128 coinIdx = 0;
        poolContract = ICurvePool(pool);

        while (i == i) {
            address coin = poolContract.coins(coinIdx);

            if (coin == tokenIn) {
                i = int128(coinIdx);
            } else if (coin == tokenOut) {
                j = int128(coinIdx);
            }

            if (i != j) {
                break;
            }
            coinIdx++;
        }
        uint256 amountsOut = poolContract.get_dy(i, j, amount);

        return amountsOut;
    }

    function getSpotPrice(address registryAddress, address[] memory tokens, uint256 realAmountIn)
        public
        returns (uint256)
    {
        metaPoolRegistryContract = IMetaPoolRegistry(registryAddress);

        poolAddress = metaPoolRegistryContract.find_pool_for_coins(tokens[0], tokens[1]);

        require(poolAddress != address(0), "No pools found");

        console.log("Pool Found %s", address(poolAddress));

        uint256 amountsOut = _curveMetaPool(poolAddress, tokens[0], tokens[1], realAmountIn);

        return amountsOut;
    }

    function testGetSpotPrice() public {
        vm.selectFork(mainnetFork);
        vm.startPrank(sender);

        // 1 ETH
        uint256 amount = 1e18;

        address[] memory tokens = new address[](2);
        tokens[0] = DAI_ADDRESS;
        tokens[1] = USDC_ADDRESS;

        uint256 amountsOut = getSpotPrice(metaPoolRegistryContractAddress, tokens, amount);

        console.log(amountsOut);

        assertGt(amountsOut, 0, "Spot price should be greater than 0");
    }
}
