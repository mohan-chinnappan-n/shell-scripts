import * as fs from 'fs';
import * as path from 'path';
import { Command } from 'commander';

function loadInclusiveMapping(filePath: string, delim: string): Record<string, string> {
  const inclusiveMapping: Record<string, string> = {};
  const fileContent = fs.readFileSync(filePath, 'utf8');
  const lines = fileContent.trim().split('\n');
  
  lines.forEach(line => {
    const [nonInclusive, inclusive] = line.trim().split(delim);
    inclusiveMapping[nonInclusive.toLowerCase()] = inclusive;
  });

  return inclusiveMapping;
}

function replaceNonInclusive(document: string, inclusiveMapping: Record<string, string>): string {
  const words = document.split(' ');
  for (let i = 0; i < words.length; i++) {
    const lowerWord = words[i].toLowerCase();
    if (lowerWord in inclusiveMapping) {
      words[i] = `[${words[i]}/${inclusiveMapping[lowerWord]}]`;
    }
  }
  return words.join(' ');
}

function checkNonInclusiveFile(filePath: string, inclusiveMapping: Record<string, string>): string {
  const sampleDocument = fs.readFileSync(filePath, 'utf8');
  const replacedDocument = replaceNonInclusive(sampleDocument, inclusiveMapping);
  return replacedDocument;
}

function main() {
  const program = new Command();
  program
    .version('1.0.0')
    .description('Check non-inclusive words in files within a folder and create backup files.')
    .requiredOption('--noninclusive <file>', 'Path to the non-inclusive words file, which contains lines in the format: non-inclusive, inclusive')
    .requiredOption('--folder <folder>', 'Path to the folder containing text files to check')
    .option('--ext <extensions>', 'File extensions to process (comma-separated)')
    .option('--delim <delimiter>', 'Field delimiter for the input data file (default: ",")', ',')
    .parse(process.argv);

  const nonInclusiveFilePath = program.noninclusive;
  const folderPath = program.folder;
  const delim = program.delim || ',';
  const extensions = program.ext ? program.ext.split(',') : [];

  const inclusiveMapping = loadInclusiveMapping(nonInclusiveFilePath, delim);
  let totalReplacements = 0;

  function processFile(filePath: string) {
    const fileExtension = path.extname(filePath).toLowerCase();
    if (extensions.includes(fileExtension.slice(1))) {
      const backupFilePath = filePath + '.bak';
      const replacedDocument = checkNonInclusiveFile(filePath, inclusiveMapping);
      fs.writeFileSync(backupFilePath, replacedDocument);
      totalReplacements += (replacedDocument.match(/\[/g) || []).length;
    }
  }

  function traverseDirectory(dirPath: string) {
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

main();

