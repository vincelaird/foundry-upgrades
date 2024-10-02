# Upgradeable Box Contract

This project demonstrates the implementation of an upgradeable smart contract using the UUPS (Universal Upgradeable Proxy Standard) pattern. It includes a basic "Box" contract that can be upgraded from version 1 to version 2, along with deployment scripts and comprehensive tests.

## Project Structure

- `src/`: Contains the smart contract source files
  - `BoxV1.sol`: The initial version of the Box contract
  - `BoxV2.sol`: The upgraded version of the Box contract
- `script/`: Contains deployment and upgrade scripts
  - `DeployBox.s.sol`: Script to deploy BoxV1
  - `UpgradeBox.s.sol`: Script to upgrade from BoxV1 to BoxV2
- `test/`: Contains test files
  - `DeployAndUpgradeTest.t.sol`: Comprehensive tests for deployment and upgrades

## Features

- Upgradeable smart contract using UUPS pattern
- BoxV1 with basic functionality
- BoxV2 with additional features
- Deployment scripts for easy contract deployment
- Upgrade script to seamlessly upgrade from V1 to V2
- Comprehensive test suite

## Prerequisites

- [Foundry](https://book.getfoundry.sh/getting-started/installation.html)

## Installation

1. Clone the repository:
  ```
  git clone <repository-url>
  cd upgradeable-box-contract
  ```

2. Install dependencies:
  ```
  forge install
  ```

## Usage

### Compilation

Compile the contracts:
  ```
  forge build
  ```

### Testing

Run the test suite:
  ```
  forge test
  ```

For more verbose output:
  ```
  forge test --vvvv
  ```

### Deployment

To deploy BoxV1:
  ```
  forge script script/DeployBox.s.sol:DeployBox --rpc-url <your-rpc-url> --account <your-account-address>
  ```

To upgrade to BoxV2:
  ```
  forge script script/UpgradeBox.s.sol:UpgradeBox --rpc-url <your-rpc-url> --account <your-account-address>
  ```

## Contract Details

### BoxV1

solidity:src/BoxV1.sol
startLine: 9
endLine: 31

### BoxV2

solidity:src/BoxV2.sol
startLine: 7
endLine: 23

## Testing

The `DeployAndUpgradeTest.t.sol` file contains comprehensive tests for the deployment and upgrade process. It covers:

- Initial deployment of BoxV1
- Upgrading from BoxV1 to BoxV2
- State preservation during upgrades
- Unauthorized upgrade attempts

## Security Considerations

- The `_authorizeUpgrade` function in both BoxV1 and BoxV2 is currently empty. In a production environment, implement proper access control to restrict who can perform upgrades.
- Ensure that the upgrade process is thoroughly tested on a testnet before deploying to mainnet.
- Consider implementing a timelock mechanism for upgrades in production.

## License

This project is licensed under the MIT License.