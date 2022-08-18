// rom-decoder.js

const fs = require('fs');
const getDirName = require('path').dirname;
const isString = require('is-string');
const ROMDataCodec = require('./data-codec');
const ROMMemoryMap = require('./memory-map');
const ROMRange = require('./range');
const ROMTextCodec = require('./text-codec');
const hexString = require('./hex-string');

class ROMDecoder {

  constructor(definition) {

    // create a memory mapper
    const mapMode = definition.mode || ROMMemoryMap.MapMode.none;
    this.memoryMap = new ROMMemoryMap(mapMode);

    // create text codecs
    this.textCodec = {};
    for (let key in definition.textEncoding) {
      const encodingDef = definition.textEncoding[key];
      this.textCodec[key] = new ROMTextCodec(encodingDef, definition.charTable);
    }

    this.currentIndex = 0;
    this.indexStack = [];
  }

  decodeROM(data, definition) {
    // set the ROM file
    this.romData = data;

    definition.obj = {};
    for (let key in definition.assembly) {
      const objDefinition = definition.assembly[key];
      if (!objDefinition.file) continue;
      definition.obj[key] = this.decodeParentObject(objDefinition);
      definition.assembly[key].isDirty = false;
    }

    return definition;
  }

  decodeParentObject(definition) {

    // calculate the appropriate ROM range using the mapper
    const unmappedRange = new ROMRange(definition.range);
    const mappedRange = this.memoryMap.mapRange(unmappedRange);
    const asmSymbol = definition.asmSymbol;
    console.log(`${unmappedRange} ${asmSymbol} -> ${definition.file}`);

    // extract the array data
    const objData = this.romData.slice(mappedRange.begin, mappedRange.end + 1);

    // make a list of pointers
    let pointers = [];
    this.currentIndex = 0;

    if (definition.type !== 'array') {
      // single object
      pointers.push(0);

    } else if (definition.pointerTable) {

      // extract the pointer table
      const ptrDefinition = definition.pointerTable;
      const isMapped = ptrDefinition.isMapped;
      let ptrOffset = Number(ptrDefinition.offset);
      if (!isMapped) {
        // map pointer offset first, then add pointers
        ptrOffset = this.memoryMap.mapAddress(ptrOffset);
      }

      // extract the pointer table data
      let ptrRange = new ROMRange(ptrDefinition.range);
      ptrRange = this.memoryMap.mapRange(ptrRange);
      const ptrData = this.romData.subarray(ptrRange.begin, ptrRange.end + 1);
      const pointerSize = ptrDefinition.pointerSize || 2;

      for (let i = 0; i < (ptrData.length / pointerSize); i++) {
        let pointer = 0;
        pointer |= ptrData[i * pointerSize];
        pointer |= ptrData[i * pointerSize + 1] << 8;
        if (pointerSize > 2) {
          pointer |= ptrData[i * pointerSize + 2] << 16;
        }
        pointer += ptrOffset;
        if (isMapped) {
          // map pointer after adding to pointer offset
          pointer = this.memoryMap.mapAddress(pointer);
        }
        pointers.push(pointer - mappedRange.begin);
      }

    } else if (definition.itemRanges) {
      for (let i = 0; i < definition.arrayLength; i++) {
        const range = new ROMRange(definition.itemRanges[i]);
        const pointer = this.memoryMap.mapAddress(range.begin);
        pointers.push(pointer - mappedRange.begin);
      }

    } else if (definition.terminator !== undefined) {
      // terminated items
      const terminator = Number(definition.terminator);
      pointers.push(0);
      for (let p = 0; p < (objData.length - 1); p++) {
        if (objData[p] === terminator) {
          pointers.push(p + 1);
        }
      }

    } else if (definition.itemLength) {
      // fixed length items
      const length = definition.itemLength;
      for (let i = 0; i < definition.arrayLength; i++) {
        pointers.push(i * length);
      }
    }

    // remove duplicates and sort pointers
    const sortedPointers = [...new Set(pointers)].sort(function(a, b) {
      return a - b;
    });

    // create a list of pointer ranges (these may not correspond
    // with item ranges in some cases)
    let pointerRanges = {};
    for (let p = 0; p < sortedPointers.length; p++) {
      const begin = sortedPointers[p];
      let end = objData.length - 1;
      if (p !== (sortedPointers.length - 1)) {
        end = sortedPointers[p + 1] - 1;
      }
      pointerRanges[begin] = new ROMRange(begin, end);
    }

    const itemRanges = [];
    const labelOffsets = {};
    for (let i = 0; i < definition.arrayLength; i++) {
      const begin = pointers[i];
      if (definition.terminator !== undefined) {
        let end = begin;
        const terminator = Number(definition.terminator);
        while (end < objData.length) {
          if (objData[end] === terminator) break;
          end++;
        }
        const range = new ROMRange(begin, end);
        itemRanges.push(range);

      } else if (definition.isSequential) {
        let end = objData.length - 1;
        if (i !== definition.arrayLength - 1) {
          end = pointers[i + 1] - 1;
        }
        const range = new ROMRange(begin, end);
        itemRanges.push(range);

      } else {
        itemRanges.push(pointerRanges[begin]);
      }

      if (definition.type === 'array') {
        // add a label offset
        if (labelOffsets[begin]) {
          labelOffsets[begin].push(i);
        } else {
          labelOffsets[begin] = [i];
        }
      }
    }

    if (!fs.existsSync(definition.file)) {
      let asmString = '';
      asmString += '.list off\n';
      asmString += '\n';
      asmString += `.define ${asmSymbol}Size`;
      asmString += ` ${hexString(mappedRange.length, 4, '$')}\n`;
      if (definition.type === 'array') {
        asmString += `.define ${asmSymbol}ArrayLength`;
        asmString += ` ${itemRanges.length}\n`;
      }

      asmString += `\n${definition.asmSymbol}:\n`;

      for (let pointer of sortedPointers) {
        // skip if pointer is out of range
        if (pointer < 0 || pointer > objData.length) {
          continue;
        }

        const itemList = labelOffsets[pointer] || [];
        const range = pointerRanges[pointer];
        // print the label
        for (let i = 0; i < itemList.length; i++) {
          const indexString = hexString(itemList[i], 4, '').toLowerCase();
          asmString += `\n${definition.asmSymbol}_${indexString}:`;
        }

        // print the data
        const pointerData = objData.subarray(range.begin, range.end + 1);
        for (let b = 0; b < pointerData.length; b++) {
          if (b % 16 == 0) {
            asmString += '\n        .byte   ';
          } else {
            asmString += ',';
          }
          asmString += hexString(pointerData[b], 2, '$').toLowerCase();
        }
        asmString += '\n';
      }
      asmString += '\n.list on\n';

      const asmPath = definition.file;
      fs.mkdirSync(getDirName(asmPath), { recursive: true });
      fs.writeFileSync(asmPath, asmString);
    }

    if (definition.type === 'array') {
      // create each array item
      const array = [];
      for (let i = 0; i < itemRanges.length; i++) {
        const itemRange = itemRanges[i];
        const itemData = objData.slice(itemRange.begin, itemRange.end + 1);
        array[i] = this.decodeObject(itemData, definition.assembly);
        this.currentIndex++;
      }
      return array;
    } else {
      return this.decodeObject(objData, definition);
    }
  }

  decodeObject(data, definition) {

    // default definition is raw data
    definition = definition || { type: 'data' };

    // decode the data
    if (definition.format) {
      const dataCodec = new ROMDataCodec(definition.format);
      data = dataCodec.decode(data);
    }

    if (definition.type === 'text') {
      const encodingKey = definition.encoding;
      const textCodec = this.textCodec[encodingKey];
      const begin = definition.begin || 0;
      const textData = data.slice(begin);
      return textCodec.decode(textData);

    } else if (definition.type === 'assembly') {
      let obj = {};
      for (let key in definition.assembly) {
        const subDefinition = definition.assembly[key];

        // skip category names
        if (isString(subDefinition)) continue;

        // skip external properties
        if (subDefinition.external) continue;

        obj[key] = this.decodeObject(data, subDefinition);
      }

      return obj;

    } else if (definition.type === 'array') {
      return this.decodeArray(data, definition);

    } else if (definition.type === 'property') {
      return this.decodeProperty(data, definition);

    } else {
      return Buffer.from(data).toString('base64');
    }
  }

  decodeProperty(data, definition) {

    // calculate the index of the first bit
    let mask = Number(definition.mask) || 0xFF;
    let bitIndex = 0;
    let firstBit = 1;
    while (!(firstBit & mask)) {
      bitIndex++;
      firstBit <<= 1;
    }

    let value = 0;
    const begin = Number(definition.begin) || 0;
    const end = Math.min(begin + 4, data.length - 1);
    for (let i = end; i >= begin; i--) {
      value <<= 8;
      value |= data[i];
    }
    value = (value & mask) >> bitIndex;
    if (definition.bool) return (value !== 0);
    return value;
  }

  decodeArray(data, definition) {
    let array = [];
    this.indexStack.push(this.currentIndex);
    this.currentIndex = 0;

    if (definition.terminator === '\\0') {
      // null-terminated text
      if (!definition.assembly || !definition.assembly.encoding) {
        console.log('Invalid null-terminated text definition');
        return array;
      }
      const encodingKey = definition.assembly.encoding;
      const textCodec = this.textCodec[encodingKey];
      let begin = 0;
      while (begin < data.length) {
        const end = begin + textCodec.textLength(data.subarray(begin));
        const itemData = data.slice(begin, end);
        const itemObj = this.decodeObject(itemData, definition.assembly);
        this.currentIndex++;
        array.push(itemObj);
        begin = end;
      }

    } else if (definition.terminator !== undefined) {
      // terminated items
      const terminator = Number(definition.terminator);
      let begin = 0;
      let end = 0;
      while (end < data.length) {
        if (data[end] === terminator) {
          const itemData = data.slice(begin, end + 1);
          const itemObj = this.decodeObject(itemData, definition.assembly);
          this.currentIndex++;
          array.push(itemObj);
          begin = end + 1;
        }
        end++;
      }

      // data at end with no terminator
      if (begin !== end) {
        console.log(`Invalid terminated array item`);
      }

    } else if (definition.itemLength) {
      // fixed length items
      const length = definition.itemLength;
      let begin = 0;
      while (begin < data.length) {
        const itemData = data.slice(begin, begin + length);
        const itemObj = this.decodeObject(itemData, definition.assembly);
        this.currentIndex++;
        array.push(itemObj);
        begin += length;
      }

    } else {
      console.log('Invalid sub-array');
    }

    this.currentIndex = this.indexStack.pop();
    return array;
  }
}

module.exports = ROMDecoder;
