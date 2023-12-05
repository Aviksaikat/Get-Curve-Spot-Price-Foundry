// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;

import {Test} from "forge-std/Test.sol";
import "forge-std/console.sol";
import {CurveSpotPrice} from "src/CurveSpotPrice.s.sol";
import "src/interfaces/IMetaPoolRegistry.sol";
import {DeployCurveSpotPrice} from "script/DeployCurveSpotPrice.s.sol";

contract GetPrice is Test {
    CurveSpotPrice public spotPriceContract;
    uint256 mainnetFork;

    // address immutable metaPoolRegistryContractAddress = 0xF98B45FA17DE75FB1aD0e7aFD971b0ca00e379fC;
    address immutable DAI_ADDRESS = 0x6B175474E89094C44Da98b954EedeAC495271d0F;
    address immutable USDC_ADDRESS = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;

    address public sender = address(1337);

    //* deploy our CurveSpotPrice contract
    function setUp() external {
        mainnetFork = vm.createSelectFork("mainnet");

        DeployCurveSpotPrice deploySpotPrice = new DeployCurveSpotPrice();
        spotPriceContract = deploySpotPrice.run();
    }

    function testGetSpotPrice() public {
        vm.startPrank(sender);

        // 1 ETH
        uint256 amount = 1e18;

        address[] memory tokens = new address[](2);
        tokens[0] = DAI_ADDRESS;
        tokens[1] = USDC_ADDRESS;

        // console.log("Tokens: ", tokens);

        uint256 amountsOut = spotPriceContract.getSpotPrice(tokens, amount);
        console.log(amountsOut);

        assertGt(amountsOut, 0, "Spot price should be greater than 0");
    }
}
