#!/usr/bin/env node

const fs = require('fs');
const hexString = require('./romtools/hex-string');

function calcSum(data) {
  let sum = 0;
  for (let i = 0; i < data.length; i++) sum += data[i];
  return sum & 0xFFFF;
}

function mirrorSum(data, mask) {
  mask = mask || 0x800000;
  while (!(data.length & mask)) mask >>= 1;

  const part1 = calcSum(data.slice(0, mask));
  let part2 = 0;

  let nextLength = data.length - mask;
  if (nextLength) {
    part2 = mirrorSum(data.slice(mask), nextLength, mask >> 1);

    while (nextLength < mask) {
      nextLength += nextLength;
      part2 += part2;
    }
  }
  return (part1 + part2) & 0xFFFF;
}

// load the ROM file
const romPath = process.argv[2];
const romBuffer = fs.readFileSync(romPath);
const romData = new Uint8Array(romBuffer);

// calculate the SNES checksum
const checksum = mirrorSum(romData);
const checksumInverse = checksum ^ 0xFFFF;

console.log(`SNES Checksum: ${hexString(checksum, 4)}`);

// set the checksum in the SNES header and write to the ROM file
romData[0xFFDC] = checksumInverse & 0xFF;
romData[0xFFDD] = checksumInverse >> 8;
romData[0xFFDE] = checksum & 0xFF;
romData[0xFFDF] = checksum >> 8;

fs.writeFileSync(romPath, romData);

process.exit(0);
