
-include .env

.PHONY: all test clean deploy fund help install snapshot format anvil zktest

DEFAULT_ANVIL_KEY := 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80
SEPOLIA_RPC_URL := https://eth-sepolia.g.alchemy.com/v2/ZXm5pI0v-lpLywpHjxW33bIKWLrnH38j
TOKEN_ADDRESS := 0x5FbDB2315678afecb367f032d93F642f64180aa3

all: clean remove install update build

# Clean the repo
clean  :; forge clean

# Remove modules
remove :; rm -rf .gitmodules && rm -rf .git/modules/* && rm -rf lib && touch .gitmodules && git add . && git commit -m "modules"

install :; forge install cyfrin/foundry-devops@0.2.2 --no-commit && forge install foundry-rs/forge-std@v1.8.2 --no-commit && forge install openzeppelin/openzeppelin-contracts@v5.0.2 --no-commit

# Update Dependencies
update:; forge update

build:; forge build

test :; forge test 

snapshot :; forge snapshot

format :; forge fmt

anvil :; anvil -m 'test test test test test test test test test test test junk' --steps-tracing --block-time 1

NETWORK_ARGS := --rpc-url http://localhost:8545 --private-key $(DEFAULT_ANVIL_KEY) --broadcast

ifeq ($(findstring --network sepolia,$(ARGS)),--network sepolia)
	NETWORK_ARGS := --rpc-url $(SEPOLIA_RPC_URL) --private-key $(PRIVATE_KEY) --broadcast --verify --etherscan-api-key $(ETHERSCAN_API_KEY) -vvvv
endif

deployNFT:
	@forge script script/DeployWhaleNFT.s.sol:DeployWhaleNFT $(NETWORK_ARGS) --sig "run(address)" $(TOKEN_ADDRESS)

mintNFT:
	@forge script script/Interactions.s.sol:MintNFT ${NETWORK_ARGS}

deployToken:
	@forge script script/DeployHDRToken.s.sol:DeployToken $(NETWORK_ARGS)

mintToken:
	@forge script script/Interactions.s.sol:MintHDR ${NETWORK_ARGS}