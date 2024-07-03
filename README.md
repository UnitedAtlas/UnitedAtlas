# UAT ERC20 for the UnitedTravel Project

## Dependencies
- Foundry: [https://getfoundry.sh](https://getfoundry.sh)
- Foundry rs : `forge install foundry-rs/forge-std@v1.9.1 --no-commit`
- OpenZeppelin `forge install OpenZeppelin/openzeppelin-contracts-upgradeable@v5.0.2 --no-commit`
- OpenZeppelin Foundry Upgrades `forge install OpenZeppelin/openzeppelin-foundry-upgrades@v0.3.1 --no-commit`


## Setup Dev Environment
1. Install dependencies: `forge install --shallow`
2. Copy `.env.example` to `.env` and fill in the required values.

## Run Tests
1. Set `.env` variables `FOUNDRY_ETH_RPC_URL` and `ETHERSCAN_API_KEY` to `polygon`.
2. Run tests: `forge test`

## Deploy Contracts

1. Deploy the ERC20 contract:
   ```sh
   forge script script/DeployUnitedAtlas.s.sol:DeployUnitedAtlas --rpc-url=$(POLYGON_RPC_URL) --broadcast --verify --optimize
