import {execSync} from 'child_process';
import {readdir, readFileSync} from 'fs';
import path from 'path';

// Set the target directory
const directoryPath = path.join(__dirname, 'reports'); // Change 'your-folder' to your target folder

// Read all files from the directory
readdir(directoryPath, (err, files) => {
  if (err) {
    return console.error('Unable to scan directory:', err);
  }

  // Filter files ending with '_after'
  const filteredFiles = files.filter((file) => file.endsWith('_after.json'));

  for (const file of filteredFiles) {
    const contentBefore = JSON.parse(
      readFileSync(`${directoryPath}/${file.replace('_after', '_before')}`, {encoding: 'utf8'})
    );
    const contentAfter = JSON.parse(readFileSync(`${directoryPath}/${file}`, {encoding: 'utf8'}));
    // diff slots that are not pure implementation slots (e.g. things on addresses provider)
    execSync(
      `npx @bgd-labs/cli codeDiff --address1 ${contentBefore.poolConfig.protocolDataProvider} --chainId1 ${contentBefore.chainId} --address2 ${contentAfter.poolConfig.protocolDataProvider} --chainId2 ${contentAfter.chainId} -o file`
    );
  }
});
