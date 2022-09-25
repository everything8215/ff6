#!/usr/bin/env node

const fs = require('fs');
const getDirName = require('path').dirname;
const ROMDataCodec = require('./romtools/data-codec');

const srcPath = process.argv[2];
const destPath = process.argv[3];

const srcData = fs.readFileSync(srcPath);
const codec = new ROMDataCodec('ff6-lzss');
const encodedData = codec.encode(srcData);

fs.mkdirSync(getDirName(destPath), { recursive: true });
fs.writeFileSync(destPath, encodedData);

process.exit(0);
