// contracts/DeployUnitedAtlas.sol
// SPDX-License-Identifier: MIT
pragma solidity >=0.8.20;

import {Script} from "forge-std/Script.sol";
import {UnitedAtlas} from "../src/UnitedAtlas.sol";
import {console} from "forge-std/console.sol";
import {Upgrades} from "openzeppelin-foundry-upgrades/Upgrades.sol";
import {UnsafeUpgrades} from "openzeppelin-foundry-upgrades/Upgrades.sol";

/**
 * @title DeployUnitedAtlas
 * @dev A script for deploying the UnitedAtlas ERC20 token.
 */
contract DeployUnitedAtlas is Script {
    uint256 public DEFAULT_ANVIL_PRIVATE_KEY = 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80;
    address public DEFAULT_OWNER_ADDRESS = makeAddr("owner");
    uint256 public deployerKey;
    address public ownerAddress;

    /**
     * @dev Runs the script to deploy the UnitedAtlas ERC20 token.
     * @return The deployed UnitedAtlas contract.
     */
    function run() external returns (address) {
        if (block.chainid == 31337) {
            deployerKey = DEFAULT_ANVIL_PRIVATE_KEY;
            ownerAddress = DEFAULT_OWNER_ADDRESS;
        } else {
            deployerKey = vm.envUint("PRIVATE_KEY");
            ownerAddress = vm.envAddress("OWNER_ADDRESS");
        }
        vm.startBroadcast(deployerKey);


        address implementation = address(new UnitedAtlas());
        address proxy = UnsafeUpgrades.deployTransparentProxy(
            implementation, ownerAddress, abi.encodeCall(UnitedAtlas.initialize, (ownerAddress))
        );


        vm.stopBroadcast();
        return proxy;
    }
}
