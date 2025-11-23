# StreamFlow: Autonomous API Marketplace for AI Agents

> **The First x402 Implementation on Polygon** — Enabling AI agents to autonomously discover and pay for APIs using Coinbase's x402 protocol on Polygon's payment-optimized infrastructure.

[![ETH Global](https://img.shields.io/badge/ETH%20Global-Hackathon-blue)](https://ethglobal.com)
[![Polygon](https://img.shields.io/badge/Polygon-Native-8247E5)](https://polygon.technology/)
[![Chainlink](https://img.shields.io/badge/Chainlink-CRE-375BD2)](https://chain.link/)
[![Coinbase](https://img.shields.io/badge/Coinbase-CDP-0052FF)](https://coinbase.com/cloud)
[![License](https://img.shields.io/badge/license-MIT-green)](LICENSE)

---

## 🎯 One-Liner

**"Stripe for AI Agents on Polygon — where autonomous agents pay per API call using x402 micropayments, settled in USDC on the world's leading payments blockchain."**

---

## 📋 Table of Contents

- [Executive Summary](#executive-summary)
- [Why Polygon + x402?](#why-polygon--x402)
- [User Personas](#user-personas)
- [Core Features](#core-features)
- [Technical Architecture](#technical-architecture)
- [System Flow](#system-flow)
- [Quick Start](#quick-start)
- [Project Structure](#project-structure)
- [Judging Criteria Alignment](#judging-criteria-alignment)
- [Demo](#demo)
- [Contributing](#contributing)

---

## 🎯 Executive Summary

### The Problem

AI agents are the future of software, but they're stuck in Web2 payment rails:
- 🚫 Can't manage API keys or credit cards
- 💸 Fixed subscriptions waste money on variable usage
- 🏢 Centralized platforms take 30% cuts
- 🔍 No way to autonomously discover services

**Market Gap**: The AI agent economy needs decentralized, usage-based payment infrastructure.

---

### Our Solution

**StreamFlow** implements Coinbase's **x402 payment protocol on Polygon**, enabling:

✅ **Agent-to-Agent Commerce**: Zero human intervention  
✅ **Pay-Per-Token Pricing**: As low as $0.00001/token  
✅ **Decentralized Verification**: Chainlink CRE prevents fraud  
✅ **Open Marketplace**: Any API provider can monetize  
✅ **Polygon Settlement**: Leverage $3.6B stablecoin liquidity

---

### Key Innovation

> "StreamFlow proves x402 is a truly open protocol by implementing it on Polygon, demonstrating how Coinbase's payment standard can enable the AI agent economy across any EVM chain while leveraging Polygon's payment-optimized infrastructure."

**Technical Achievement:**
- First x402 marketplace implementation
- First x402 deployment on Polygon
- First AI agent payment system with CRE verification

---

## 🌟 Why Polygon + x402?

### The Perfect Match

| Requirement | Polygon Solution | x402 Solution |
|------------|------------------|---------------|
| **High Transaction Volume** | 5,000 TPS (Rio upgrade) | HTTP-native (no blockchain bloat) |
| **Low Costs** | ~$0.005/tx | Micropayments viable |
| **Stablecoin Liquidity** | $3.6B USDC/USDT | Native USDC support |
| **Agent-Friendly** | Fast finality (5 sec) | No API keys required |
| **Payment Leader** | Stripe, Mastercard partners | Open payment standard |

**Result**: AI agents can make thousands of micro-payments daily at costs lower than traditional payment processors.

---

## 👥 User Personas

### Persona 1: "Maya" - The Agent Builder

**Profile**: Founder building autonomous customer service agents

**Current Pain**:
- Agents need to consume multiple LLM APIs
- OpenAI charges $20/month even if agents use $2
- Can't switch providers without rewriting code

**StreamFlow Solution**:
```python
# Agent automatically selects cheapest provider
cheapest_api = await marketplace.query(model_type="general")
response = await agent.call_api(cheapest_api, prompt="...")
# Pays $0.0045 (150 tokens × $0.00003) instead of $20/month
```

**Impact**: 98% cost reduction through usage-based pricing

---

### Persona 2: "Raj" - The AI API Provider

**Profile**: ML engineer with fine-tuned legal analysis model

**Current Pain**:
- Can't compete with OpenAI's distribution
- Stripe takes 2.9% + $0.30 per transaction
- Model sits idle 80% of the time

**StreamFlow Solution**:
```solidity
// Register API in marketplace
marketplace.registerService(
    endpoint="https://legal-ai.com/api",
    pricePerToken=0.00005 * 1e6  // $0.00005 USDC
);
// Earn $0.005 per request, settled instantly on Polygon
```

**Impact**: Earn from 1,000 micro-transactions vs 5 enterprise customers

---

## ⚡ Core Features

### 1. x402 Protocol on Polygon

**What**: HTTP-native payment protocol adapted for Polygon's ecosystem

**How It Works**:
```http
POST /api/v1/generate HTTP/1.1
Host: api.streamflow.xyz
Content-Type: application/json
X-Payment-Auth: polygon-0x742d35Cc...

HTTP/1.1 402 Payment Required
X-Payment-Required: 0.003 USDC
X-Payment-Address: 0x742d35Cc6634C0532925a3b844Bc454e4438f44e

[Agent pays via CDP wallet]

HTTP/1.1 200 OK
Content-Type: application/json
X-Tokens-Used: 150
X-Cost-USDC: 0.0045

{"text": "Quantum computing uses..."}
```

**Innovation**: First x402 implementation showing protocol extensibility beyond Base

---

### 2. CDP Server Wallets for Agents

**What**: Production-grade wallets with <200ms signing latency

**Agent Onboarding**:
```typescript
import { Coinbase } from "@coinbase/coinbase-sdk";

// Create wallet on Polygon (zero human steps)
const wallet = await Coinbase.createWallet({
  networkId: "polygon-amoy"
});

// Set spending policy
await wallet.setPolicy({
  maxAmountPerTx: "10_000000", // 10 USDC
  allowedRecipients: [providerAddress]
});
```

**Why Not Regular Wallets?**
- No seed phrases to manage
- Sub-200ms transaction signing
- Built-in policy controls
- 99.9% uptime SLA

---

### 3. Chainlink CRE Verification

**What**: Off-chain computation that prevents usage fraud

**The Problem**: How do you trust API providers report accurate usage?

**The Solution**:
```
1. API logs usage: "Agent_123 used 150 tokens"
2. CRE polls logs from multiple nodes (decentralized)
3. CRE calculates: 150 × $0.00003 = $0.0045 USDC
4. CRE triggers Polygon settlement with proof
5. Only verified payments settle on-chain
```

**Gas Savings**: $0.001 (CRE) vs $0.05+ (on-chain verification)

---

### 4. The Graph Analytics

**What**: Real-time dashboards querying Polygon events

**Provider Dashboard**:
```graphql
query ProviderRevenue {
  providerStats(id: "0x742d35Cc...") {
    totalRevenue
    totalTokensServed
    uniqueAgents
    revenueByDay {
      date
      amount
    }
  }
}
```

**Agent Dashboard**:
- Spending by provider
- Cost per request trends
- Savings vs subscriptions

---

### 5. Open API Marketplace

**What**: Permissionless registry on Polygon

**Any Provider Can**:
1. Deploy their API endpoint
2. Register in smart contract ($0.005 gas)
3. Start earning USDC in minutes

**Any Agent Can**:
1. Query The Graph for services
2. Authorize spending once
3. Pay per actual usage

**Network Effect**: More providers → Better prices → More agents → More providers

---

## 🏗️ Technical Architecture

### Tech Stack (All Polygon-Native)

| Layer | Technology | Purpose |
|-------|-----------|---------|
| **Settlement** | Polygon PoS (Amoy) | All payments settle here |
| **Payment Protocol** | x402 (Custom) | HTTP-native authorization |
| **Agent Wallets** | CDP Server Wallets | Sub-200ms signing |
| **Off-chain Compute** | Chainlink CRE | Usage verification |
| **Backend** | Python FastAPI | Marketplace + routing |
| **Mock Services** | Python | 2 LLM endpoints (demo) |
| **Indexing** | The Graph | Real-time queries |
| **Frontend** | React + ethers.js | Provider/agent dashboards |
| **Agent Framework** | AgentKit (Python) | Autonomous logic |

---

## 📐 System Flow

```
┌─────────────────────────────────────────────────────────────┐
│                 STREAMFLOW ON POLYGON                        │
└─────────────────────────────────────────────────────────────┘

1. AGENT CREATION (CDP Server Wallets)
   ↓
   Wallet created on Polygon in <3 seconds
   Pre-funded with USDC from faucet

2. SERVICE DISCOVERY (The Graph)
   ↓
   Agent queries: "What LLMs are available?"
   Graph returns: GeneralGPT ($0.00003/token), LegalAI ($0.00005/token)

3. AUTHORIZATION (x402 on Polygon)
   ↓
   Agent approves $10 USDC spending to GeneralGPT provider
   Transaction settles on Polygon (~5 seconds)

4. API CALL (HTTP + x402 Headers)
   ↓
   POST /api/v1/generate
   Headers: X-Payment-Auth, X-Agent-Address
   Body: {"prompt": "Explain quantum computing"}

5. USAGE LOGGING (FastAPI Middleware)
   ↓
   API processes request → logs 150 tokens used
   Returns response + cost breakdown

6. VERIFICATION (Chainlink CRE)
   ↓
   CRE polls usage logs (every 30s)
   Multi-node consensus: "150 tokens confirmed"
   Calculates: 150 × $0.00003 = $0.0045 USDC

7. SETTLEMENT (Polygon Smart Contract)
   ↓
   CRE triggers: x402Contract.processPayment(agent, provider, 0.0045)
   USDC transfers on Polygon
   Event emitted: PaymentProcessed

8. ANALYTICS (The Graph)
   ↓
   Subgraph indexes PaymentProcessed event
   Dashboard updates in real-time
   Provider sees: +$0.0045 revenue
   Agent sees: -$0.0045 spent

9. WITHDRAWAL (Provider Action)
   ↓
   Provider calls: x402Contract.withdraw()
   USDC sent to provider's CDP wallet on Polygon
```

**Every step happens on Polygon** ✅

---

## 🚀 Quick Start

### Prerequisites

```bash
node --version    # v18+
python --version  # 3.10+
forge --version   # Foundry for Solidity
gh --version      # GitHub CLI
```

### Installation

```bash
# Clone repository
git clone https://github.com/yourusername/streamflow.git
cd streamflow

# Install dependencies
npm install
pip install -r requirements.txt

# Configure environment
cp .env.example .env
# Add your API keys:
# - CDP_API_KEY_NAME
# - CDP_API_KEY_SECRET
# - POLYGON_RPC_URL (https://rpc-amoy.polygon.technology)
# - GRAPH_API_KEY
```

### Deploy Contracts (Polygon Amoy)

```bash
cd contracts
forge build
forge script script/Deploy.s.sol:DeployScript \
  --rpc-url $POLYGON_RPC_URL \
  --broadcast \
  --verify
```

### Start Backend

```bash
cd backend
uvicorn main:app --reload --port 8000
```

### Start Frontend

```bash
cd frontend
npm start
```

### Test the Flow

```bash
# Terminal 1: Backend running
# Terminal 2: Run agent test
cd tests
python test_agent_flow.py
```

---

## 📁 Project Structure

```
streamflow/
├── contracts/              # Solidity smart contracts
│   ├── src/
│   │   ├── X402Payment.sol        # Main payment contract
│   │   ├── ServiceRegistry.sol    # API marketplace
│   │   └── interfaces/
│   │       └── IX402.sol          # x402 interface
│   ├── test/              # Foundry tests
│   └── script/            # Deployment scripts
│
├── cre-workflows/         # Chainlink CRE (TypeScript)
│   ├── src/
│   │   ├── usage-monitor.ts       # Polls API usage
│   │   ├── billing-calculator.ts  # Computes costs
│   │   └── settlement-trigger.ts  # Triggers Polygon tx
│   └── test/
│
├── backend/               # Python FastAPI
│   ├── main.py           # Marketplace API
│   ├── services/
│   │   ├── general_gpt.py        # Mock LLM 1
│   │   └── legal_ai.py           # Mock LLM 2
│   ├── middleware/
│   │   └── x402_auth.py          # Payment validation
│   └── tests/
│
├── subgraph/             # The Graph indexing
│   ├── schema.graphql    # Entity definitions
│   ├── subgraph.yaml     # Configuration
│   └── src/
│       └── mapping.ts    # Event handlers
│
├── frontend/             # React dashboard
│   ├── src/
│   │   ├── pages/
│   │   │   ├── ProviderDashboard.tsx
│   │   │   └── AgentDashboard.tsx
│   │   └── components/
│   │       ├── WalletConnect.tsx
│   │       └── PaymentHistory.tsx
│   └── public/
│
├── scripts/              # Utility scripts
│   ├── fund-wallets.ts   # USDC faucet helper
│   └── deploy-all.sh     # One-command deployment
│
└── docs/                 # Documentation
    ├── ARCHITECTURE.md
    ├── API.md
    └── DEPLOYMENT.md
```

---

## 🏆 Judging Criteria Alignment

### Polygon Prize ✅

**Category 1: x402 + AI/Agentic Application**
- ✅ x402 protocol deployed on Polygon
- ✅ AI agents autonomously consume APIs
- ✅ All settlements on Polygon network
- ✅ High transaction volume potential

**Category 2: x402 Protocol Expansion**
- ✅ Adapts x402 for Polygon ecosystem
- ✅ Shows protocol extensibility beyond Base
- ✅ Custom facilitator logic for Polygon's stablecoin infrastructure

**Category 3: Payment Flows**
- ✅ Merchant application (API providers)
- ✅ Payment processing middleware
- ✅ Brings transaction count up (agent-driven volume)

**Why We Win**: First x402 implementation on Polygon proving the protocol works across any EVM chain

---

### Coinbase Prize ✅

**Core Requirements**:
- ✅ CDP Server Wallets (agents + providers)
- ✅ x402 protocol implementation
- ✅ AgentKit integration (Python SDK)

**Bonus Points**:
- ✅ Using 3+ CDP products
- ✅ Novel x402 use case (marketplace)
- ✅ High-quality implementation
- ✅ Demonstrates protocol extensibility

**Why We Win**: Proves x402 is a truly open standard by implementing on non-Base chain

---

### Chainlink Prize ✅

**Core Functionality**:
- ✅ CRE workflows for off-chain computation
- ✅ Decentralized usage verification
- ✅ Novel integration (CRE + x402)

**Why We Win**: First project combining CRE with x402 payments

---

### The Graph Prize ✅

**Requirements**:
- ✅ Real-time analytics dashboards
- ✅ Complex queries (revenue aggregation)
- ✅ Essential to UX (service discovery)

**Why We Win**: Subgraph enables the entire marketplace discovery mechanism

---

## 🎬 Demo (5 Minutes)

### Live Demo Flow

**1. Provider Registration (30s)**
```bash
# Connect CDP wallet
# Register "LegalAI" at $0.00005/token
# Show Polygon transaction: polygonscan.com/tx/0x...
```

**2. Agent Discovery (30s)**
```graphql
# Query The Graph
{ apiServices { endpoint, pricePerToken } }
# Agent selects cheapest option
```

**3. Automated Payment (1 min)**
```python
# Agent authorizes $10 USDC
# Makes API call → 402 response → pays → 200 response
# CRE settles on Polygon
# Show transaction on PolygonScan
```

**4. Analytics Dashboard (1 min)**
```
Provider view: +$0.0045 revenue (real-time)
Agent view: Cost comparison (saved 40%)
```

**5. Impact Slide (30s)**
- First x402 on Polygon
- 98% cheaper than Stripe
- Unlocks $X trillion agent economy

---

## 🤝 Contributing

We welcome contributions! See [CONTRIBUTING.md](CONTRIBUTING.md)

### Development Workflow
```bash
git checkout -b feature/amazing-feature
git commit -m 'Add amazing feature'
git push origin feature/amazing-feature
```

---

## 📜 License

MIT License - see [LICENSE](LICENSE)

---

## 🔗 Links

- **Demo**: [streamflow-demo.vercel.app](https://streamflow-demo.vercel.app) (coming soon)
- **Contracts**: [Polygon Amoy Explorer](https://amoy.polygonscan.com)
- **Subgraph**: [The Graph Studio](https://thegraph.com/studio)
- **Twitter**: [@StreamFlowAI](https://twitter.com/StreamFlowAI)

---

## 🙏 Acknowledgments

Built with:
- [Polygon](https://polygon.technology/) - Payment-optimized blockchain
- [Coinbase CDP](https://coinbase.com/cloud) - Server Wallets & x402 protocol
- [Chainlink](https://chain.link/) - CRE off-chain compute
- [The Graph](https://thegraph.com/) - Decentralized indexing

Special thanks to ETH Global and all DevRel teams!

---

<div align="center">
  <strong>Built at ETH Global 2025 🚀</strong>
  <br />
  <em>The first x402 implementation on Polygon</em>
  <br />
  <em>Empowering the autonomous agent economy</em>
</div>