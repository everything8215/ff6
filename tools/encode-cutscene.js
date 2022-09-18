#!/usr/bin/env node

const fs = require('fs');
const getDirName = require('path').dirname;
const ROMDataCodec = require('./romtools/data-codec');

const langSuffix = process.argv[2] || 'jp';

const cutsceneProgramPath = `cutscene/data/cutscene_${langSuffix}.bin`;
const cutsceneEncodedPath = `cutscene/data/cutscene_${langSuffix}.lz`;

const cutsceneProgramFile = fs.readFileSync(cutsceneProgramPath);

const codec = new ROMDataCodec('ff6-lzss');
const encodedData = codec.encode(cutsceneProgramFile);

fs.mkdirSync(getDirName(cutsceneEncodedPath), { recursive: true });
fs.writeFileSync(cutsceneEncodedPath, encodedData);

process.exit(0);
