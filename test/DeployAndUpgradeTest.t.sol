// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test} from "forge-std/Test.sol";
import {DeployBox} from "../script/DeployBox.s.sol";
import {UpgradeBox} from "../script/UpgradeBox.s.sol";
import {BoxV1} from "../src/BoxV1.sol";
import {BoxV2} from "../src/BoxV2.sol";

/// @title Deploy and Upgrade Test for Box Contract
/// @notice This contract contains tests for deploying and upgrading the Box contract
/// @dev Uses Foundry's Test contract for testing functionality
contract DeployAndUpgradeTest is Test {
    DeployBox public deployer;
    UpgradeBox public upgrader;
    address public OWNER = makeAddr("owner");

    address public proxy;

    /// @notice Set up the test environment
    /// @dev Deploys the initial BoxV1 contract and sets up the upgrader
    function setUp() public {
        deployer = new DeployBox();
        upgrader = new UpgradeBox();
        proxy = deployer.run(); // Deploys BoxV1 and returns the proxy address
    }

    /// @notice Test that the proxy starts as BoxV1
    /// @dev Attempts to call a BoxV2 function, which should revert
    function testProxyStartsAsBoxV1() public {
        vm.expectRevert();
        BoxV2(proxy).setNumber(7);
    }

    /// @notice Test the upgrade process from BoxV1 to BoxV2
    /// @dev Upgrades the contract and checks if new functionality is available
    function testUpgrades() public {
        BoxV2 box2 = new BoxV2();

        upgrader.upgradeBox(proxy, address(box2));

        uint256 expectedValue = 2;
        assertEq(expectedValue, BoxV2(proxy).version());

        BoxV2(proxy).setNumber(7);
        assertEq(7, BoxV2(proxy).getNumber());
    }

    /// @notice Test the upgrade process using the UpgradeBox script
    /// @dev Deploys BoxV1, upgrades to BoxV2, and tests new functionality
    function testUpgradeBoxScript() public {
        // Deploy BoxV1 first
        address proxyAddress = deployer.run();

        // Now upgrade to BoxV2
        UpgradeBox upgradeScript = new UpgradeBox();
        address upgradedProxyAddress = upgradeScript.run(proxyAddress);

        // Check if the upgrade was successful
        BoxV2 upgradedBox = BoxV2(upgradedProxyAddress);
        assertEq(upgradedBox.version(), 2, "Upgrade to V2 failed");

        // Test new functionality
        upgradedBox.setNumber(42);
        assertEq(upgradedBox.getNumber(), 42, "New functionality not working");
    }

    /// @notice Test the initialization of BoxV1
    /// @dev Checks if the owner is set correctly and initial state is as expected
    function testBoxV1Initialize() public {
        BoxV1 box = new BoxV1();

        // Call initialize with a specific address
        address expectedOwner = address(this);
        vm.prank(expectedOwner);
        box.initialize();

        // Assert that the owner is set correctly
        assertEq(
            box.owner(),
            expectedOwner,
            "Owner should be set to the caller of initialize"
        );

        // Assert that the version is correct
        assertEq(box.version(), 1, "Version should be 1 for BoxV1");

        // Assert that the initial number is 0
        assertEq(box.getNumber(), 0, "Initial number should be 0");
    }

    /// @notice Test unauthorized upgrade attempts
    /// @dev Tries to upgrade directly through the implementation contract, which should fail
    function testUnauthorizedUpgrade() public {
        // Create a new implementation contract
        BoxV2 newImplementation = new BoxV2();

        // Attempt to upgrade directly through the implementation contract
        vm.expectRevert();
        BoxV1(address(newImplementation)).upgradeToAndCall(
            address(newImplementation),
            ""
        );
    }

    /// @notice Test state preservation during upgrade
    /// @dev Upgrades from BoxV1 to BoxV2 and checks if the state is preserved
    function testStatePreservationDuringUpgrade() public {
        // Deploy BoxV1
        address proxyAddress = deployer.run();
        BoxV1 boxV1 = BoxV1(payable(proxyAddress));

        // Initialize BoxV1 with a number
        boxV1.initialize();
        uint256 initialNumber = boxV1.getNumber();

        // Upgrade to BoxV2
        BoxV2 newImplementation = new BoxV2();
        upgrader.upgradeBox(proxyAddress, address(newImplementation));

        // Check if the state is preserved
        BoxV2 boxV2 = BoxV2(payable(proxyAddress));
        assertEq(
            boxV2.getNumber(),
            initialNumber,
            "Number should be preserved after upgrade"
        );

        // Test new functionality
        boxV2.setNumber(42);
        assertEq(
            boxV2.getNumber(),
            42,
            "New functionality should work after upgrade"
        );
    }
}
