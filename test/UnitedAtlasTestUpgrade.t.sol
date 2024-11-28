// tests/UnitedAtlasTest.sol
// SPDX-License-Identifier: MIT
pragma solidity >=0.8.19;

import {UpdateUnitedAtlas} from "../script/UpdateUnitedAtlas.s.sol";
import {UnitedAtlas} from "../src/UpdateUnitedAtlas.sol";
import {Test, console} from "forge-std/Test.sol";
import {StdCheats} from "forge-std/StdCheats.sol";
import {Fork} from "./Utils/Fork.t.sol";
import {PROXY_ADMIN, PROXY_UANITED_ATLAS} from "script/const.sol";
import {ProxyAdmin} from "@openzeppelin/contracts/proxy/transparent/ProxyAdmin.sol";
import {ITransparentUpgradeableProxy} from "@openzeppelin/contracts/proxy/transparent/TransparentUpgradeableProxy.sol";

interface MintableToken {
    function mint(address, uint256) external;
}

/**
 * @title UnitedAtlasTest
 * @dev A test suite for the UnitedAtlas ERC20 token.
 */
contract UnitedAtlasTestUpgrade is StdCheats, Test, Fork {
    UnitedAtlas public unitedAtlas;

    /**
     * @dev Sets up the test environment by deploying the UnitedAtlas contract and
     * transferring tokens to Bob.
     */
    function setUp() public {
        setupFork();

        ProxyAdmin proxyAdmin = ProxyAdmin(PROXY_ADMIN);
        address implementation = address(new UnitedAtlas());
        ITransparentUpgradeableProxy proxy = ITransparentUpgradeableProxy(payable(PROXY_UANITED_ATLAS));

        vm.startPrank(0x5e88e3BF8FEa2aBB9c516Aae01aa2Fa726bF55ff);
        proxyAdmin.upgradeAndCall(proxy, implementation, "");
        vm.stopPrank();

        unitedAtlas = UnitedAtlas(PROXY_UANITED_ATLAS);
    }

    function test_up() external view {
        address currentOwner = unitedAtlas.owner();
        unitedAtlas.balanceOf(currentOwner);
        address deployerAddress = vm.addr(vm.envUint("PRIVATE_KEY"));
        console.log("Deployer Address:", deployerAddress);
    }

    function testOwnershipTransferAfterUpgrade(address newOwner) external {
        address currentOwner = unitedAtlas.owner();
        vm.deal(currentOwner, 1 ether);

        console.log("Current owner before transfer:", currentOwner);

        vm.startPrank(currentOwner);

        unitedAtlas.transferOwnership(newOwner);

        vm.stopPrank();

        address pendingOwner = unitedAtlas.pendingOwner();
        assertEq(pendingOwner, newOwner, "Pending owner should be newOwner");
        console.log("Pending owner after transferOwnership:", pendingOwner);

        vm.deal(newOwner, 1 ether);

        vm.startPrank(newOwner);

        unitedAtlas.acceptOwnership();

        vm.stopPrank();

        address updatedOwner = unitedAtlas.owner();
        assertEq(updatedOwner, newOwner, "Owner should be newOwner");
        console.log("Owner after acceptOwnership:", updatedOwner);
    }
}
