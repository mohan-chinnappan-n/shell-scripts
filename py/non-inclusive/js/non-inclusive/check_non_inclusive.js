const fs = require('fs');
const path = require('path');
const { program } = require('commander');

function loadInclusiveMapping(filePath, delim) {
  console.log(filePath);
  const inclusiveMapping = {};
  const fileContent = fs.readFileSync(filePath, 'utf8');
  const lines = fileContent.trim().split('\n');
  
  lines.forEach(line => {
    const [nonInclusive, inclusive] = line.trim().split(delim);
    inclusiveMapping[nonInclusive.toLowerCase()] = inclusive;
  });

  return inclusiveMapping;
}

function replaceNonInclusive(document, inclusiveMapping) {
  const words = document.split(' ');
  for (let i = 0; i < words.length; i++) {
    const lowerWord = words[i].toLowerCase();
    if (lowerWord in inclusiveMapping) {
      words[i] = `[${words[i]}/${inclusiveMapping[lowerWord]}]`;
    }
  }
  return words.join(' ');
}

function checkNonInclusiveFile(filePath, inclusiveMapping) {
  const sampleDocument = fs.readFileSync(filePath, 'utf8');
  const replacedDocument = replaceNonInclusive(sampleDocument, inclusiveMapping);
  return replacedDocument;
}

function main() {
  program
    .version('1.0.0')
    .description('Check non-inclusive words in files within a folder and create backup files.')
    .requiredOption('--noninclusive <file>', 'Path to the non-inclusive words file, which contains lines in the format: non-inclusive, inclusive')
    .requiredOption('--folder <folder>', 'Path to the folder containing text files to check')
    .option('--ext <extensions>', 'File extensions to process (comma-separated)', "txt,cls")
    .option('--delim <delimiter>', 'Field delimiter for the input data file (default: ",")', ',')
    .parse(process.argv);

  const options = program.opts();
  const nonInclusiveFilePath = options.noninclusive;
  const folderPath = options.folder;
  const delim = options.delim;
  const extensions = options.ext || ['cls','txt'];

  const inclusiveMapping = loadInclusiveMapping(nonInclusiveFilePath, delim);
  let totalReplacements = 0;

  function processFile(filePath) {
    const fileExtension = path.extname(filePath).toLowerCase();
    if (extensions.includes(fileExtension.slice(1))) {
      const backupFilePath = filePath + '.bak';
      const replacedDocument = checkNonInclusiveFile(filePath, inclusiveMapping);
      fs.writeFileSync(backupFilePath, replacedDocument);
      totalReplacements += (replacedDocument.match(/\[/g) || []).length;
    }
  }

  function traverseDirectory(dirPath) {
    const files = fs.readdirSync(dirPath);
    files.forEach(file => {
      const filePath = path.join(dirPath, file);
      const stats = fs.statSync(filePath);
      if (stats.isFile()) {
        processFile(filePath);
      } else if (stats.isDirectory()) {
        traverseDirectory(filePath);
      }
    });
  }

  traverseDirectory(folderPath);

  console.log(`Total replacements made: ${totalReplacements}`);
}

function list(val) {
  return val.split(',');
}

main();

