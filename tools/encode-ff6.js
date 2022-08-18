#!/usr/bin/env node

const fs = require('fs');
const ROMEncoder = require('./romtools/rom-encoder');
const ROMMemoryMap = require('./romtools/memory-map');
const ROMRange = require('./romtools/range');
const ROMDataCodec = require('./romtools/data-codec');

// load the data file
const dataPath = process.argv[2];
const romDefinitionFile = fs.readFileSync(dataPath);
const romDefinition = JSON.parse(romDefinitionFile);

const encoder = new ROMEncoder(romDefinition);

encoder.encodeROM(romDefinition);

process.exit(0);
