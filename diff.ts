import {execSync} from 'child_process';
import {readdir, readdirSync, readFileSync, statSync, unlinkSync} from 'fs';
import path from 'path';
import {Hex, getAddress, slice} from 'viem';

function bytes32ToAddress(bytes32: Hex) {
  return getAddress(slice(bytes32, 12, 32));
}

// Set the target directory
const directoryPath = path.join(__dirname, 'reports'); // Change 'your-folder' to your target folder
const erc1967ImplSlot = '0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc';

// diff all the networks
// readdir(directoryPath, (err, files) => {
//   if (err) {
//     return console.error('Unable to scan directory:', err);
//   }

//   // Filter files ending with '_after'
//   const filteredFiles = files.filter((file) => file.endsWith('_after.json'));

//   for (const file of filteredFiles) {
//     const contentBefore = JSON.parse(
//       readFileSync(`${directoryPath}/${file.replace('_after', '_before')}`, {encoding: 'utf8'})
//     );
//     const contentAfter = JSON.parse(readFileSync(`${directoryPath}/${file}`, {encoding: 'utf8'}));
//     // diff slots that are not pure implementation slots (e.g. things on addresses provider)
//     execSync(
//       `npx @bgd-labs/cli codeDiff --address1 ${contentBefore.poolConfig.protocolDataProvider} --chainId1 ${contentBefore.chainId} --address2 ${contentAfter.poolConfig.protocolDataProvider} --chainId2 ${contentAfter.chainId} -o file`
//     );

//     for (const contract of Object.keys(contentAfter.raw)) {
//       const implSlot = contentAfter.raw[contract].stateDiff[erc1967ImplSlot];
//       if (implSlot) {
//         execSync(
//           `npx @bgd-labs/cli codeDiff --address1 ${bytes32ToAddress(
//             implSlot.previousValue
//           )} --chainId1 ${contentBefore.chainId} --address2 ${bytes32ToAddress(
//             implSlot.newValue
//           )} --chainId2 ${contentAfter.chainId} -o file`
//         );
//       }
//     }
//   }
// });

// now as the diffing is done, let's remove duplicates and generate a report
// Function to read files recursively
function getFiles(dir, fileList: {path: string; name: string; content: string}[] = []) {
  const files = readdirSync(dir);

  files.forEach((file) => {
    const filePath = path.join(dir, file);
    if (statSync(filePath).isDirectory()) {
      getFiles(filePath, fileList);
    } else {
      fileList.push({
        path: filePath,
        name: file,
        content: readFileSync(filePath, {encoding: 'utf8'}),
      });
    }
  });

  return fileList;
}

// Get all files including subdirectories
const allFiles = getFiles(path.join(__dirname, 'diffs', 'code'));
const uniqueArray = allFiles
  .sort((a, b) => {
    const extractNumber = (str) => {
      const match = str.match(/\/diffs\/code\/(\d+)\//);
      return match ? parseInt(match[1], 10) : Infinity;
    };

    return extractNumber(a.path) - extractNumber(b.path);
  })
  .filter((obj, index, self) => index === self.findIndex((o) => o.content === obj.content));

for (const file of allFiles) {
  const isUnique = uniqueArray.find((uniq) => uniq.path === file.path);
  if (!isUnique) unlinkSync(file.path);
}
