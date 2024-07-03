// tests/UnitedAtlasTest.sol
// SPDX-License-Identifier: MIT
pragma solidity >=0.8.19;

import {DeployUnitedAtlas} from "../script/DeployUnitedAtlas.s.sol";
import {UnitedAtlas} from "../src/UnitedAtlas.sol";
import {Test, console} from "forge-std/Test.sol";
import {StdCheats} from "forge-std/StdCheats.sol";

interface MintableToken {
    function mint(address, uint256) external;
}

/**
 * @title UnitedAtlasTest
 * @dev A test suite for the UnitedAtlas ERC20 token.
 */
contract UnitedAtlasTest is StdCheats, Test {
    uint256 BOB_STARTING_AMOUNT = 100 ether;

    UnitedAtlas public unitedAtlas;
    DeployUnitedAtlas public deployer;
    address public deployerAddress;
    address bob;
    address alice;

    /**
     * @dev Sets up the test environment by deploying the UnitedAtlas contract and
     * transferring tokens to Bob.
     */
    function setUp() public {
        deployer = new DeployUnitedAtlas();
        unitedAtlas = UnitedAtlas(deployer.run());

        bob = makeAddr("bob");
        alice = makeAddr("alice");

        deployerAddress = deployer.ownerAddress();
        vm.prank(deployerAddress);
        unitedAtlas.transfer(bob, BOB_STARTING_AMOUNT);
    }

    /**
     * @dev Tests that the initial supply of tokens is correct.
     */
    function testInitialSupply() public view  {
        assertEq(unitedAtlas.totalSupply(), unitedAtlas.INITIAL_SUPPLY());
    }

    /**
     * @dev Tests that users cannot mint tokens.
     */
    function testUsersCantMint() public {
        vm.expectRevert();
        MintableToken(address(unitedAtlas)).mint(address(this), 1);
    }

    /**
     * @dev Tests that allowances work correctly.
     */
    function testAllowances() public {
        uint256 initialAllowance = 1000;

        // Alice approves Bob to spend tokens on her behalf
        vm.prank(bob);
        unitedAtlas.approve(alice, initialAllowance);
        uint256 transferAmount = 500;

        vm.prank(alice);
        unitedAtlas.transferFrom(bob, alice, transferAmount);
        assertEq(unitedAtlas.balanceOf(alice), transferAmount);
        assertEq(unitedAtlas.balanceOf(bob), BOB_STARTING_AMOUNT - transferAmount);
    }

    /**
     * @dev Tests that users can burn their own tokens.
     */
    function testSelfBurn() public {
        uint256 burnAmount = 10 ether;
        vm.prank(bob);
        unitedAtlas.burn(burnAmount);
        assertEq(unitedAtlas.balanceOf(bob), BOB_STARTING_AMOUNT - burnAmount);
    }

    /**
     * @dev Tests that users cannot burn tokens they do not own.
     */
    function testUnauthorizedBurn() public {
        uint256 burnAmount = 10 ether;
        vm.expectRevert();
        vm.prank(alice);
        unitedAtlas.burn(burnAmount);
    }

    /**
     * @dev Tests burning tokens via allowance.
     */
    function testBurnViaAllowance() public {
        uint256 burnAmount = 10 ether;
        vm.prank(bob);
        unitedAtlas.approve(alice, burnAmount);
        vm.prank(alice);
        unitedAtlas.burnFrom(bob, burnAmount);
        assertEq(unitedAtlas.balanceOf(bob), BOB_STARTING_AMOUNT - burnAmount);
    }

}