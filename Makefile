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
		END { if (in_diff_block && skip_block == 0) { printf "%s", buffer } }' > diffs/${out}.md

deploy :
	forge script scripts/Deploy.s.sol:Deploy${chain} --rpc-url ${chain} --ledger --mnemonic-indexes ${MNEMONIC_INDEX} --sender ${LEDGER_SENDER} --verify --slow --broadcast
	npx catapulta-verify -b broadcast/Deploy.s.sol/${chainId}/run-latest.json
