// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.19;

import "forge-std/Test.sol";

abstract contract Fork is Test {
    function setupFork() public {
        string memory rpcUrl = vm.rpcUrl(vm.envString("FORK_RPC_URL"));
        vm.createSelectFork(rpcUrl);
    }

    function setupFork(uint256 select_block) public {
        vm.createSelectFork(vm.envString("FORK_RPC_URL"), select_block);
    }
}
