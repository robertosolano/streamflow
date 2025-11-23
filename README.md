# StreamFlow: Autonomous API Marketplace for AI Agents

> **Stripe for AI Agents** — A decentralized marketplace where autonomous agents discover and pay for APIs per-inference using x402 micropayments on Polygon.

[![ETH Global](https://img.shields.io/badge/ETH%20Global-Hackathon-blue)](https://ethglobal.com)
[![Polygon](https://img.shields.io/badge/Polygon-Amoy%20Testnet-8247E5)](https://polygon.technology/)
[![Chainlink](https://img.shields.io/badge/Chainlink-CRE-375BD2)](https://chain.link/)
[![License](https://img.shields.io/badge/license-MIT-green)](LICENSE)

---

## 📋 Table of Contents

- [Executive Summary](#executive-summary)
- [The Problem](#the-problem)
- [Our Solution](#our-solution)
- [User Personas](#user-personas)
- [Core Features](#core-features)
- [Technical Architecture](#technical-architecture)
- [System Architecture](#system-architecture-diagram)
- [Mock Services](#mock-llm-services)
- [User Flows](#user-flows)
- [Non-Functional Requirements](#non-functional-requirements)
- [Out of Scope](#out-of-scope-post-hackathon)
- [Risk Assessment](#risk-assessment)
- [Judging Criteria](#judging-criteria-alignment)
- [Demo Script](#demo-script)
- [Getting Started](#getting-started)
- [Contributing](#contributing)

---

## 🎯 Executive Summary

### Vision
Create the first decentralized marketplace where AI agents autonomously discover, consume, and pay for API services with zero human intervention using usage-based micropayments.

### Problem
The AI agent economy is bottlenecked by Web2 payment infrastructure:
- 🚫 Agents can't manage API keys or credit cards
- 💸 Fixed subscriptions waste money on variable usage
- 🏢 Centralized platforms take 30% cuts
- 🔍 No standardized way for agents to discover services

### Solution
StreamFlow combines **x402 protocol**, **Chainlink CRE**, and **Polygon** to enable:
- ✅ Agent-to-agent commerce without human intervention
- ✅ Pay-per-token pricing (e.g., $0.00001/token)
- ✅ Decentralized usage verification
- ✅ Open marketplace for any API provider

### Success Metrics

| Metric | Target |
|--------|--------|
| Transaction Latency | < 5 seconds |
| Gas Cost per Payment | < $0.01 USD |
| Provider Registration | < 5 minutes |
| Agent Onboarding | Zero human steps |

---

## 🔥 The Problem

AI agents are the future of software, but they're stuck in Web2 payment rails:

1. **Payment Friction**: Agents can't autonomously sign up for API keys or manage credit cards
2. **Cost Unpredictability**: Fixed OpenAI subscriptions waste money; agents have variable usage
3. **Vendor Lock-in**: Hard to switch between providers (Anthropic, Cohere, local models)
4. **Distribution Bottleneck**: Specialized AI models can't reach agent developers
5. **High CAC**: API providers need sales teams to onboard each customer

**Market Opportunity**: The AI agent economy is projected to be worth trillions, but lacks the payment infrastructure to function autonomously.

---

## 💡 Our Solution

### The StreamFlow Approach

```
TRADITIONAL MODEL                  STREAMFLOW MODEL
────────────────                   ────────────────
💳 $50/month fixed                 💰 $2.40 actual usage
🔒 Single provider                 🌐 10+ providers
👤 Human API key mgmt              🤖 Autonomous discovery
📊 No usage visibility             📈 Real-time analytics
```

### How It Works

1. **Discover**: Agent queries The Graph for available APIs (LLMs, data services)
2. **Authorize**: One-time x402 spending approval (no recurring charges)
3. **Consume**: Agent calls API with automatic micropayment per token
4. **Verify**: Chainlink CRE validates actual usage off-chain
5. **Settle**: Polygon processes instant USDC payment to provider

---

## 👥 User Personas

### Persona 1: "Maya" - The Agent Builder (Demand Side)

**Profile:**
- Founder of AI automation startup building autonomous agents
- Needs agents to consume various LLM services without manual intervention

**Pain Points:**
- Agents can't manage API keys or credit cards
- Fixed subscriptions waste money on variable usage
- Managing 10+ agents across multiple providers is complex

**Job-to-be-Done:**
> "I want my customer service agent to automatically use GPT-4 for complex queries and a cheaper model for simple ones, reducing costs by 40%."

**Success Metric**: Cost per agent task drops 40% through dynamic provider selection

---

### Persona 2: "Raj" - The AI API Provider (Supply Side)

**Profile:**
- ML engineer with a fine-tuned LLM (e.g., legal document analysis)
- Struggling to monetize against OpenAI's brand recognition

**Pain Points:**
- Can't compete on distribution with big players
- Stripe integration requires KYC, chargebacks, subscription overhead
- Model sits idle 80% of the time

**Job-to-be-Done:**
> "I want agents to discover my legal-specialized LLM and pay per token, so I earn revenue without managing subscriptions."

**Success Metric**: Monthly revenue from 1,000 micro-transactions beats previous 5-customer enterprise model

---

### Market Dynamics (Two-Sided Marketplace)

```
SUPPLY SIDE                     STREAMFLOW              DEMAND SIDE
───────────                     ──────────              ───────────

Specialized LLMs    ←─────→    Marketplace    ←─────→  Autonomous Agents
Fine-tuned Models              Discovery               Multi-Agent Systems  
Local Hosting                  x402 Payments           AI Workflows
Niche APIs                     Metering                Research Bots
                               Analytics               Customer Service
```

**Network Effects:**
- More providers → Better selection → More agents
- More agents → Higher revenue → More providers

---

## ⚡ Core Features

### 4.1 API Marketplace Registry

**Description**: On-chain registry of available services

**Key Capabilities:**
- Providers register with pricing and capability metadata
- Agents query via GraphQL (The Graph)
- Filter by price, model type, latency
- Reputation system (future)

**Smart Contract Structure:**
```solidity
struct APIService {
    address provider;
    string endpoint;
    uint256 pricePerToken; // in USDC (6 decimals)
    string modelType; // "gpt-4", "llama-2", "custom"
    bool isActive;
}
```

---

### 4.2 Pay-Per-Inference Engine

**Description**: Core payment flow integrating x402 + CRE

**Payment Flow:**
```
1. Agent → API: POST /inference + x402 auth header
2. API → CRE: Request pre-authorization check
3. API → Agent: Inference response + token count
4. CRE → Polygon: settleBill(tokenCount * pricePerToken)
5. Provider receives USDC instantly
```

**Key Innovation**: No gas costs for monitoring; only settlement transactions hit the blockchain.

---

### 4.3 Chainlink CRE Integration

**Description**: Decentralized usage verification preventing fraud

**Workflows (TypeScript):**

**A. Usage Monitor**
- Polls API usage logs every 30 seconds
- Aggregates by agent address + provider
- Validates against on-chain pre-authorizations

**B. Billing Calculator**
- `totalCost = tokenCount * pricePerToken`
- Applies volume discounts (future)
- Generates cryptographically signed transaction

**C. Settlement Trigger**
- Calls x402 contract with CRE attestation
- Prevents disputes through multi-node verification

---

### 4.4 x402 Smart Contract

**Description**: HTTP-native payment protocol implementation

**Key Functions:**
```solidity
// Agent pre-authorizes spending limit
function authorize(address provider, uint256 maxAmount) external;

// CRE triggers settlement after usage
function processPayment(
    address agent,
    address provider, 
    uint256 amount,
    bytes calldata creProof
) external onlyCRE;

// Provider withdraws earnings
function withdraw() external;
```

**Security Features:**
- Rate limiting per agent
- Maximum per-transaction caps
- Emergency pause mechanism
- Fraud detection hooks

---

### 4.5 The Graph Analytics

**Description**: Real-time usage and revenue dashboards

**Subgraph Schema:**
```graphql
type Payment @entity {
  id: ID!
  agent: Bytes!
  provider: Bytes!
  amount: BigInt!
  tokenCount: BigInt!
  timestamp: BigInt!
  apiService: String!
}

type ProviderStats @entity {
  id: ID!
  totalRevenue: BigInt!
  totalTokensServed: BigInt!
  uniqueAgents: Int!
}
```

**Dashboard Views:**
- **Provider**: Revenue/day, top-consuming agents, token efficiency
- **Agent**: Spend/day, provider comparison, cost predictions

---

## 🏗️ Technical Architecture

### Tech Stack

| Layer | Technology | Justification |
|-------|-----------|---------------|
| **Frontend** | React + ethers.js | Fast prototyping, Web3 standard |
| **Marketplace API** | Python FastAPI | Auto-generated OpenAPI docs |
| **Mock LLM Services** | Python (2 endpoints) | Easy text processing simulation |
| **CRE Workflows** | TypeScript | Native CRE support, typed Web3 |
| **Smart Contracts** | Solidity 0.8.20 | x402 compatibility |
| **Blockchain** | Polygon Amoy (testnet) | Low gas, fast finality |
| **Indexing** | The Graph (Subgraph Studio) | Real-time queries |
| **Wallets** | CDP Server Wallets | Agent-friendly, no seed phrases |

---

## 📐 System Architecture Diagram

```
┌─────────────────────────────────────────────────────────────┐
│                    AGENT LAYER (Consumers)                   │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐      │
│  │ Research Bot │  │ Customer AI  │  │ Analyst Bot  │      │
│  └──────┬───────┘  └──────┬───────┘  └──────┬───────┘      │
└─────────┼──────────────────┼──────────────────┼─────────────┘
          │                  │                  │
          └──────────────────┼──────────────────┘
                             │ (HTTP + x402 headers)
          ┌──────────────────▼──────────────────┐
          │   API MARKETPLACE (FastAPI)         │
          │  - Service Discovery                │
          │  - Request Routing                  │
          │  - Usage Logging                    │
          └──────────┬─────────────┬────────────┘
                     │             │
          ┌──────────▼──────┐  ┌──▼─────────────┐
          │ Mock LLM 1      │  │ Mock LLM 2     │
          │ (GPT-4 style)   │  │ (Legal spec.)  │
          │ $0.00003/token  │  │ $0.00005/token │
          └─────────────────┘  └────────────────┘
                     │
          ┌──────────▼────────────────────────────┐
          │   CHAINLINK CRE (Workflows)           │
          │  ┌────────────┐  ┌─────────────────┐ │
          │  │  Monitor   │→ │ Bill Calculator │ │
          │  └────────────┘  └────────┬────────┘ │
          │                           │           │
          │                  ┌────────▼────────┐  │
          │                  │ Settle Trigger  │  │
          │                  └────────┬────────┘  │
          └───────────────────────────┼───────────┘
                                      │ (signed tx)
          ┌───────────────────────────▼───────────┐
          │   POLYGON AMOY (Settlement)           │
          │  ┌─────────────────────────────────┐  │
          │  │  x402 Smart Contract            │  │
          │  │  - authorize()                  │  │
          │  │  - processPayment()             │  │
          │  │  - withdraw()                   │  │
          │  └─────────────┬───────────────────┘  │
          │                │ (emits events)       │
          └────────────────┼──────────────────────┘
                           │
          ┌────────────────▼──────────────────────┐
          │   THE GRAPH (Indexing)                │
          │  - PaymentSettled events              │
          │  - Provider revenue aggregation       │
          │  - Agent spending analytics           │
          └───────────────────────────────────────┘
```

---

## 🧪 Mock LLM Services

### Service 1: "General GPT"
- **Model Type**: Generic text generation
- **Pricing**: $0.00003/token (~$0.03 per 1K tokens)
- **Endpoint**: `POST /api/v1/generate`
- **Response Time**: 2-3 seconds

### Service 2: "LegalAI Specialist"
- **Model Type**: Legal document analysis
- **Pricing**: $0.00005/token (premium for specialization)
- **Endpoint**: `POST /api/v1/legal/analyze`
- **Response Time**: 3-4 seconds

**Note**: Both use mocked responses (not real LLMs) to demonstrate payment flow without GPU infrastructure costs.

---

## 🔄 User Flows

### Flow 1: Provider Onboarding (Raj)

```
1. Connect wallet (CDP Wallet)
2. Navigate to "Register API" page
3. Input:
   - API endpoint URL
   - Price per token (USDC)
   - Model description
4. Approve transaction (~$0.01 gas)
5. API appears in marketplace within 30 seconds
```

---

### Flow 2: Agent Consumption (Maya's Bot)

```python
# 1. Agent queries marketplace
services = graph_client.query("""
  {
    apiServices(where: {modelType: "general"}) {
      provider
      endpoint
      pricePerToken
    }
  }
""")

# 2. Select cheapest option
cheapest = min(services, key=lambda x: x['pricePerToken'])

# 3. Authorize spending (one-time per provider)
x402_contract.authorize(
    provider_address=cheapest['provider'],
    max_amount=10_000000  # 10 USDC
)

# 4. Make inference request
response = requests.post(
    cheapest['endpoint'],
    headers={
        "x-payment-auth": generate_x402_token(),
        "x-agent-address": agent_wallet.address
    },
    json={"prompt": "Explain quantum computing"}
)

# 5. Receive response with cost breakdown
{
  "text": "Quantum computing uses qubits...",
  "tokens_used": 150,
  "cost_usdc": "0.0045"
}

# 6. CRE workflow (background):
#    - Polls usage log
#    - Calculates: 150 * 0.00003 = 0.0045 USDC
#    - Calls processPayment()
#    - Settlement completes in ~5 seconds
```

---

## ⚙️ Non-Functional Requirements

### Performance
- **API Response Time**: < 5 seconds (95th percentile)
- **Payment Settlement**: < 10 seconds (CRE + Polygon)
- **Marketplace Query**: < 500ms (The Graph)

### Scalability
- Support 100 concurrent agent requests (hackathon)
- Handle 1,000 transactions/day (demo)
- Design for 100K TPS (production roadmap)

### Security
- x402 authorization replay protection
- CRE multi-node verification (3+ nodes)
- Rate limiting: 100 requests/minute per agent
- Emergency pause function in contracts

---

## 🚫 Out of Scope (Post-Hackathon)

- ❌ Real LLM hosting (using mocks for demo)
- ❌ Fraud detection ML models
- ❌ Provider reputation system
- ❌ Batch payment optimization
- ❌ Privacy features (zkProofs for usage)
- ❌ Multi-chain support (Base, Optimism)
- ❌ Agent SDK (Python/TypeScript libraries)
- ❌ Mobile app

---

## ⚠️ Risk Assessment

| Risk | Impact | Mitigation |
|------|--------|-----------|
| CRE testnet downtime | High | Fallback: manual settlement button |
| x402 spec changes | Medium | Lock to specific repo commit |
| The Graph indexing delays | Low | Show "pending" state in UI |
| Gas price spike | Low | Use gasless transactions (relayer) |
| CDP wallet rate limits | Medium | Implement request queuing |

---

## 🏆 Judging Criteria Alignment

### Polygon Prize
✅ **Innovative x402 use case**: First agentic marketplace  
✅ **High transaction potential**: Every agent call = payment  
✅ **Not gambling/DeFi**: Pure utility (API payments)  
✅ **Merchant utility**: Enables new monetization models

### Coinbase Prize
✅ **CDP Server Wallets**: Agents use autonomous wallets  
✅ **x402 integration**: Core payment mechanism  
✅ **Multiple products**: Wallets + x402 + potential Trade API  
✅ **High-quality implementation**: Production-ready architecture

### Chainlink Prize
✅ **CRE core functionality**: Off-chain usage verification  
✅ **Novel use case**: First CRE + x402 integration  
✅ **Production-ready**: Scalable, secure design  
✅ **Real-world problem**: Solves AI agent payment bottleneck

### The Graph Prize
✅ **Real-time analytics**: Provider/agent dashboards  
✅ **Complex queries**: Revenue aggregation, usage trends  
✅ **Essential to UX**: Discovery + transparency  
✅ **Novel schema**: Multi-entity relationships

---

## 🎬 Demo Script (5 Minutes)

**Minute 1: Problem** (30s)
- "AI agents can't autonomously pay for APIs"
- Show broken flow: Agent → Manual API key → Human payment

**Minute 2: Solution** (30s)
- Show architecture diagram
- Explain 4 layers: Agent → CRE → x402 → The Graph

**Minutes 3-4: Live Demo** (2 min)
1. Register new API as provider (20s)
2. Run agent consuming API (30s)
3. Show payment settlement on PolygonScan (20s)
4. Display analytics dashboard (30s)
5. Cost comparison: $50/month subscription vs $2.40 actual usage (20s)

**Minute 5: Impact** (1 min)
- "This unlocks the trillion-dollar agent economy"
- Show network effects: More providers → More agents → More providers
- Call to action: "Try it at streamflow.xyz"

---

## 🚀 Getting Started

### Prerequisites
```bash
# Node.js 18+
node --version

# Python 3.10+
python --version

# Foundry (for Solidity)
forge --version

# Graph CLI
graph --version
```

### Installation

```bash
# Clone repository
git clone https://github.com/yourusername/streamflow.git
cd streamflow

# Install dependencies
npm install
pip install -r requirements.txt

# Set up environment
cp .env.example .env
# Edit .env with your API keys
```

### Quick Start

```bash
# Terminal 1: Start local blockchain
npx hardhat node

# Terminal 2: Deploy contracts
npm run deploy:local

# Terminal 3: Start marketplace API
cd backend && uvicorn main:app --reload

# Terminal 4: Start frontend
cd frontend && npm start
```

### Testing

```bash
# Smart contract tests
npm run test:contracts

# Backend tests
pytest backend/tests/

# Integration tests
npm run test:e2e
```

---

## 📁 Project Structure

```
streamflow/
├── contracts/              # Solidity smart contracts
│   ├── x402Payment.sol    # Main payment contract
│   ├── ServiceRegistry.sol # API marketplace registry
│   └── test/              # Contract tests
├── cre-workflows/         # Chainlink CRE TypeScript
│   ├── usage-monitor.ts
│   ├── billing-calculator.ts
│   └── settlement-trigger.ts
├── backend/               # Python FastAPI
│   ├── main.py           # Marketplace API
│   ├── services/         # Mock LLM endpoints
│   └── middleware/       # x402 validation
├── subgraph/             # The Graph indexing
│   ├── schema.graphql
│   └── mappings/
├── frontend/             # React dashboard
│   ├── src/
│   │   ├── pages/
│   │   └── components/
│   └── public/
├── scripts/              # Deployment scripts
└── docs/                 # Additional documentation
```

---

## 🤝 Contributing

We welcome contributions! Please see [CONTRIBUTING.md](CONTRIBUTING.md) for details.

### Development Workflow
1. Fork the repository
2. Create feature branch (`git checkout -b feature/amazing-feature`)
3. Commit changes (`git commit -m 'Add amazing feature'`)
4. Push to branch (`git push origin feature/amazing-feature`)
5. Open Pull Request

---

## 📜 License

This project is licensed under the MIT License - see [LICENSE](LICENSE) file.

---

## 🔗 Links

- **Live Demo**: [streamflow.xyz](https://streamflow.xyz) (coming soon)
- **Documentation**: [docs.streamflow.xyz](https://docs.streamflow.xyz)
- **Twitter**: [@StreamFlowAI](https://twitter.com/StreamFlowAI)
- **Discord**: [Join our community](https://discord.gg/streamflow)

---

## 🙏 Acknowledgments

Built with amazing tools from:
- [Polygon](https://polygon.technology/) - Scalable blockchain infrastructure
- [Coinbase](https://www.coinbase.com/cloud) - CDP Wallets & x402 protocol
- [Chainlink](https://chain.link/) - CRE decentralized computation
- [The Graph](https://thegraph.com/) - Blockchain indexing

Special thanks to ETH Global and all the DevRel teams for their support!

---

## 📧 Contact

**Team StreamFlow**
- Email: team@streamflow.xyz
- Telegram: @streamflow_support

---

<div align="center">
  <strong>Built at ETH Global 2025 🚀</strong>
  <br />
  <em>Empowering the autonomous agent economy, one inference at a time.</em>
</div>