// contracts/UnitedAtlas.sol
// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

// Import necessary components from OpenZeppelin for creating an upgradable ERC20 token with burnable functionality.
import "@openzeppelin/contracts-upgradeable/token/ERC20/extensions/ERC20BurnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/access/Ownable2StepUpgradeable.sol";

/**
 * @title UnitedAtlas
 * @dev Implementation of the UnitedAtlas ERC20 token with upgradable and burnable features.
 * This contract initializes the token with the name "UnitedAtlas" and symbol "UAT",
 * and sets an initial supply of 8 billion tokens, considering 18 decimal places.
 * The burnable functionality allows token holders to destroy their tokens, reducing the total supply,
 * and potentially increasing the value of the remaining tokens.
 * The contract is also designed to be upgradable, ensuring that it can incorporate future improvements without
 * the need for a new deployment. Ownership functionalities are managed via the OpenZeppelin Ownable module,
 * providing controlled access to privileged actions.
 */
contract UnitedAtlas is Initializable, Ownable2StepUpgradeable, ERC20Upgradeable, ERC20BurnableUpgradeable {
    uint256 public constant INITIAL_SUPPLY = 8_000_000_000 ether;

    /**
     * @custom:oz-upgrades-unsafe-allow constructor
     */
    constructor() {
        // Disable initializers to prevent unauthorized initialization
        _disableInitializers();
    }

    /**
     * @dev Initializes the contract, setting the initial supply and the owner.
     * @param owner The address that will own the contract and initially receive all tokens.
     */
    function initialize(address owner) public virtual initializer {
        __Ownable_init(owner);
        __ERC20_init("UnitedAtlas", "UAT");
        _mint(owner, INITIAL_SUPPLY);
    }
}
