#!/usr/bin/env node

const fs = require('fs');
const CRC32 = require('crc-32');
const ROMDataCodec = require('./romtools/data-codec');
const ROMDecoder = require('./romtools/rom-decoder');
const ROMRange = require('./romtools/range');
const hexString = require('./romtools/hex-string');

const romInfoListFF4 = {
  0x45EF5AC8: {
    name: 'Final Fantasy VI 1.0 (J)',
    ripPath: 'vanilla/ff6-jp-rip.json',
    dataPath: 'ff6-jp-data.json'
  },
  0xA27F1C7A: {
    name: 'Final Fantasy III 1.0 (U)',
    ripPath: 'vanilla/ff6-en-rip.json',
    dataPath: 'ff6-en-data.json'
  },
  0xC0FA0464: {
    name: 'Final Fantasy III 1.1 (U)',
    ripPath: 'vanilla/ff6-en-rip.json',
    dataPath: 'ff6-en-data.json'
  }
}

// search the vanilla directory for valid ROM files
const files = fs.readdirSync('vanilla');

let foundOneROM = false;
for (let filename of files) {
  const filePath = `vanilla/${filename}`;
  if (fs.statSync(filePath).isDirectory()) continue;

  const fileBuf = fs.readFileSync(filePath);
  const crc32 = CRC32.buf(fileBuf) >>> 0;
  const romInfo = romInfoListFF4[crc32];
  if (!romInfo) continue;

  console.log(`Found ROM: ${romInfo.name}`);
  console.log(`File: ${filePath}`);

  // load the definition file
  const ripDefinitionFile = fs.readFileSync(romInfo.ripPath);
  const ripDefinition = JSON.parse(ripDefinitionFile);

  const decoder = new ROMDecoder(ripDefinition);

  // load the ROM file
  const romData = new Uint8Array(fs.readFileSync(filePath));
  const romObj = decoder.decodeROM(romData, ripDefinition);
  romObj.crc32 = hexString(crc32, 8);

  fs.writeFileSync(romInfo.dataPath, JSON.stringify(romObj, null, 2));
  foundOneROM = true;
}

if (!foundOneROM) {
  console.log('No valid ROM files found!\nPlease copy your valid FF6 ROM ' +
      'file(s) into the "vanilla" directory.\nIf your ROM has a header, ' +
      'please remove it first.');
}

process.exit(0);
