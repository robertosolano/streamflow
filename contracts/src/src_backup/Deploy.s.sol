// ============================================
// FILE 2: contracts/script/Deploy.s.sol
// ============================================

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/X402Payment.sol";

contract DeployScript is Script {
    function run() external {
        // Load environment variables
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address usdcAddress = vm.envAddress("USDC_ADDRESS");
        
        console.log("Deploying to Polygon Amoy...");
        console.log("Deployer:", vm.addr(deployerPrivateKey));
        console.log("USDC Address:", usdcAddress);
        
        vm.startBroadcast(deployerPrivateKey);
        
        // Deploy X402Payment
        X402Payment payment = new X402Payment(usdcAddress);
        
        console.log("====================================");
        console.log("X402Payment deployed at:", address(payment));
        console.log("====================================");
        console.log("Save this address to your .env:");
        console.log("X402_CONTRACT_ADDRESS=", address(payment));
        console.log("====================================");
        
        vm.stopBroadcast();
        
        // Verify on PolygonScan
        console.log("\nTo verify on PolygonScan:");
        console.log("forge verify-contract", address(payment), "X402Payment");
        console.log("  --chain polygon-amoy");
        console.log("  --constructor-args $(cast abi-encode \"constructor(address)\" ", usdcAddress, ")");
    }
}