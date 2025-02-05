# include .env file and export its env vars
# (-include to ignore error if it does not exist)
-include .env

# deps
update:; forge update

# Build & test
build  :; forge build --sizes
test   :; forge test -vvv

# Utilities
download :; cast etherscan-source --chain ${chain} -d src/etherscan/${chain}_${address} ${address}
git-diff :
	@mkdir -p diffs
	@npx prettier ${before} ${after} --write
	@git diff --no-index --diff-algorithm=patience --ignore-space-at-eol ${before} ${after} | \
	awk 'BEGIN { in_diff_block = 0; skip_block = 0; buffer = "" } \
		/^diff --git/ { \
			if (in_diff_block && skip_block == 0) { printf "%s", buffer } \
			in_diff_block = 1; skip_block = 0; buffer = $$0 "\n" \
		} \
		/similarity index 100%/ { skip_block = 1 } \
		{ if (in_diff_block && !/^diff --git/) { buffer = buffer $$0 "\n" } } \
		END { if (in_diff_block && skip_block == 0) { printf "%s", buffer } }' > diffs/${out}.diff
#  --resume --verify --etherscan-api-key ${ETHERSCAN_API_KEY_ARBITRUM}
deploy :;
	FOUNDRY_PROFILE=${chain} forge script scripts/Deploy.s.sol:Deploylido --rpc-url ${chain} --ledger --mnemonic-indexes ${MNEMONIC_INDEX} --sender ${LEDGER_SENDER} --slow --broadcast --verify --etherscan-api-key ${ETHERSCAN_API_KEY_MAINNET}

deploy-zk :; FOUNDRY_PROFILE=zksync forge script zksync/scripts/Deploy.s.sol:Deployzksync --zksync --system-mode=true --rpc-url zksync --private-key ${PRIVATE_KEY} --sender ${SENDER} --verify --slow --broadcast
