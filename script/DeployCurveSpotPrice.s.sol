// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;

// import {Test} from "forge-std/Test.sol";
import {Script} from "forge-std/Script.sol";
import {CurveSpotPrice} from "src/CurveSpotPrice.s.sol";
import "forge-std/console.sol";

contract DeployCurveSpotPrice is Script {
    // CurveSpotPrice public spotPriceContract;
    address immutable metaPoolRegistryContractAddress = 0xF98B45FA17DE75FB1aD0e7aFD971b0ca00e379fC;

    function run() external returns (CurveSpotPrice) {
        vm.startBroadcast();
        CurveSpotPrice spotPriceContract = new CurveSpotPrice(metaPoolRegistryContractAddress);
        console.log("Spot Price Contract deployed to: %s", address(spotPriceContract));
        vm.stopBroadcast();

        return spotPriceContract;
    }
}
