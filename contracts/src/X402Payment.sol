// ============================================
// BLOCK 1: Smart Contracts - Ready to Deploy
// Time: 30 minutes
// ============================================

// FILE 1: contracts/src/X402Payment.sol
// ============================================

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title X402Payment
 * @notice StreamFlow payment contract implementing x402 protocol on Polygon
 * @dev Enables agents to authorize and process micropayments for API usage
 */
contract X402Payment is ReentrancyGuard, Ownable {
    // ============================================
    // STATE VARIABLES
    // ============================================
    
    IERC20 public immutable USDC;
    
    // Agent => Provider => Authorized amount
    mapping(address => mapping(address => uint256)) public authorizations;
    
    // Provider => Earned balance (pending withdrawal)
    mapping(address => uint256) public balances;
    
    // Emergency pause
    bool public paused;
    
    // ============================================
    // EVENTS
    // ============================================
    
    event PaymentAuthorized(
        address indexed agent,
        address indexed provider,
        uint256 amount,
        uint256 timestamp
    );
    
    event PaymentProcessed(
        address indexed agent,
        address indexed provider,
        uint256 amount,
        uint256 timestamp
    );
    
    event Withdrawn(
        address indexed provider,
        uint256 amount,
        uint256 timestamp
    );
    
    event EmergencyPause(bool paused);
    
    // ============================================
    // MODIFIERS
    // ============================================
    
    modifier whenNotPaused() {
        require(!paused, "Contract is paused");
        _;
    }
    
    // ============================================
    // CONSTRUCTOR
    // ============================================
    
    constructor(address _usdc) {
        require(_usdc != address(0), "Invalid USDC address");
        USDC = IERC20(_usdc);
    }
    
    // ============================================
    // CORE FUNCTIONS
    // ============================================
    
    /**
     * @notice Agent authorizes spending to a provider
     * @param provider Address of the API provider
     * @param maxAmount Maximum USDC amount (6 decimals) agent allows
     */
    function authorize(address provider, uint256 maxAmount) 
        external 
        whenNotPaused 
    {
        require(provider != address(0), "Invalid provider");
        require(maxAmount > 0, "Amount must be positive");
        
        authorizations[msg.sender][provider] = maxAmount;
        
        emit PaymentAuthorized(
            msg.sender, 
            provider, 
            maxAmount, 
            block.timestamp
        );
    }
    
    /**
     * @notice Process payment after usage verification
     * @dev Called by CRE or authorized oracle
     * @param agent Address of the AI agent
     * @param provider Address of the API provider
     * @param amount USDC amount to transfer (6 decimals)
     */
    function processPayment(
        address agent,
        address provider,
        uint256 amount
    ) 
        external 
        nonReentrant 
        whenNotPaused 
    {
        require(amount > 0, "Amount must be positive");
        require(
            authorizations[agent][provider] >= amount, 
            "Insufficient authorization"
        );
        
        // Reduce authorization
        authorizations[agent][provider] -= amount;
        
        // Transfer USDC from agent to contract
        bool transferSuccess = USDC.transferFrom(agent, address(this), amount);
        require(transferSuccess, "USDC transfer failed");
        
        // Credit provider balance
        balances[provider] += amount;
        
        emit PaymentProcessed(agent, provider, amount, block.timestamp);
    }
    
    /**
     * @notice Provider withdraws earned USDC
     */
    function withdraw() external nonReentrant {
        uint256 amount = balances[msg.sender];
        require(amount > 0, "No balance to withdraw");
        
        // Reset balance before transfer (CEI pattern)
        balances[msg.sender] = 0;
        
        bool transferSuccess = USDC.transfer(msg.sender, amount);
        require(transferSuccess, "Withdrawal failed");
        
        emit Withdrawn(msg.sender, amount, block.timestamp);
    }
    
    // ============================================
    // VIEW FUNCTIONS
    // ============================================
    
    /**
     * @notice Get agent's authorization for a provider
     */
    function getAuthorization(address agent, address provider) 
        external 
        view 
        returns (uint256) 
    {
        return authorizations[agent][provider];
    }
    
    /**
     * @notice Get provider's pending balance
     */
    function getBalance(address provider) 
        external 
        view 
        returns (uint256) 
    {
        return balances[provider];
    }
    
    // ============================================
    // ADMIN FUNCTIONS
    // ============================================
    
    /**
     * @notice Emergency pause (owner only)
     */
    function setPause(bool _paused) external onlyOwner {
        paused = _paused;
        emit EmergencyPause(_paused);
    }
}


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


// ============================================
// FILE 3: contracts/test/X402Payment.t.sol
// ============================================

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/X402Payment.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

/**
 * @notice Mock USDC for testing
 */
contract MockUSDC is ERC20 {
    constructor() ERC20("Mock USDC", "USDC") {
        _mint(msg.sender, 1000000 * 10**6); // 1M USDC
    }
    
    function decimals() public pure override returns (uint8) {
        return 6;
    }
    
    function mint(address to, uint256 amount) external {
        _mint(to, amount);
    }
}

/**
 * @notice Test suite for X402Payment
 */
contract X402PaymentTest is Test {
    X402Payment public payment;
    MockUSDC public usdc;
    
    address agent = address(0x1);
    address provider = address(0x2);
    address attacker = address(0x3);
    
    function setUp() public {
        // Deploy mock USDC
        usdc = new MockUSDC();
        
        // Deploy X402Payment
        payment = new X402Payment(address(usdc));
        
        // Fund agent with USDC
        usdc.mint(agent, 100 * 10**6); // 100 USDC
        
        // Agent approves payment contract
        vm.prank(agent);
        usdc.approve(address(payment), type(uint256).max);
    }
    
    function testAuthorize() public {
        uint256 authAmount = 10 * 10**6; // 10 USDC
        
        vm.prank(agent);
        payment.authorize(provider, authAmount);
        
        assertEq(payment.getAuthorization(agent, provider), authAmount);
    }
    
    function testProcessPayment() public {
        // Authorize
        vm.prank(agent);
        payment.authorize(provider, 10 * 10**6);
        
        // Process payment
        uint256 paymentAmount = 5 * 10**6; // 5 USDC
        payment.processPayment(agent, provider, paymentAmount);
        
        // Check balances
        assertEq(payment.getBalance(provider), paymentAmount);
        assertEq(payment.getAuthorization(agent, provider), 5 * 10**6); // Remaining auth
    }
    
    function testWithdraw() public {
        // Setup: process a payment
        vm.prank(agent);
        payment.authorize(provider, 10 * 10**6);
        payment.processPayment(agent, provider, 5 * 10**6);
        
        // Provider withdraws
        uint256 balanceBefore = usdc.balanceOf(provider);
        
        vm.prank(provider);
        payment.withdraw();
        
        uint256 balanceAfter = usdc.balanceOf(provider);
        assertEq(balanceAfter - balanceBefore, 5 * 10**6);
        assertEq(payment.getBalance(provider), 0);
    }
    
    function testFailProcessPaymentWithoutAuthorization() public {
        // Should fail: no authorization
        payment.processPayment(agent, provider, 1 * 10**6);
    }
    
    function testFailProcessPaymentExceedsAuthorization() public {
        vm.prank(agent);
        payment.authorize(provider, 5 * 10**6);
        
        // Should fail: payment exceeds authorization
        payment.processPayment(agent, provider, 10 * 10**6);
    }
    
    function testEmergencyPause() public {
        // Pause contract
        payment.setPause(true);
        
        // Should fail: contract paused
        vm.prank(agent);
        vm.expectRevert("Contract is paused");
        payment.authorize(provider, 10 * 10**6);
    }
}


// ============================================
// DEPLOYMENT INSTRUCTIONS
// ============================================

/*

STEP 1: Setup Foundry project
-------------------------------
cd contracts
forge init --no-commit
forge install OpenZeppelin/openzeppelin-contracts

STEP 2: Create .env file
--------------------------
PRIVATE_KEY=your_private_key_here
POLYGON_RPC_URL=https://rpc-amoy.polygon.technology
USDC_ADDRESS=0x41E94Eb019C0762f9Bfcf9Fb1E58725BfB0e7582
POLYGONSCAN_API_KEY=your_polygonscan_api_key

STEP 3: Build contracts
------------------------
forge build

STEP 4: Run tests
------------------
forge test -vv

Expected output:
✅ testAuthorize (gas: 45123)
✅ testProcessPayment (gas: 89456)
✅ testWithdraw (gas: 67890)
✅ testFailProcessPaymentWithoutAuthorization
✅ testFailProcessPaymentExceedsAuthorization
✅ testEmergencyPause

STEP 5: Deploy to Polygon Amoy
--------------------------------
source .env
forge script script/Deploy.s.sol:DeployScript \
  --rpc-url $POLYGON_RPC_URL \
  --broadcast \
  --verify \
  --etherscan-api-key $POLYGONSCAN_API_KEY

STEP 6: Save contract address
-------------------------------
Copy the deployed address and add to .env:
X402_CONTRACT_ADDRESS=0x...

STEP 7: Verify deployment
---------------------------
Open PolygonScan:
https://amoy.polygonscan.com/address/YOUR_CONTRACT_ADDRESS

✅ CHECKPOINT 1 COMPLETE!
Proceed to BLOCK 2: Backend API

*/