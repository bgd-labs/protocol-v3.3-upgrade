import before from './reports/137_0x794a61358D6845594F94dc1DB02A252b5b4814aD_before.json';
import after from './reports/137_0x794a61358D6845594F94dc1DB02A252b5b4814aD_after.json';
import {execSync} from 'child_process';

function download(contractName: string, config, id) {
  const outPath = `reports/${config.chainId}_${contractName}_${id}`;
  const command = `cast etherscan-source --chain ${config.chainId} -d ${outPath} ${config.poolConfig[contractName]}`;
  execSync(command);
  return outPath;
}

function diff(contractName: string) {
  const beforePath = download(contractName, before, 'before');
  const afterPath = download(contractName, after, 'after');
  const command = `make git-diff before=${beforePath} after=${afterPath} out=${before.chainId}_${contractName}_diff`;
  execSync(command);
}

async function main() {
  diff('poolConfiguratorImpl');
  diff('poolImpl');
  diff('protocolDataProvider');
}

main();
