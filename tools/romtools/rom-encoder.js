// encode-rom.js

const fs = require('fs');
const getDirName = require('path').dirname;
const isArray = require('isarray');
const ROMDataCodec = require('./data-codec');
const ROMRange = require('./range');
const ROMTextCodec = require('./text-codec');
const hexString = require('./hex-string');

class ROMEncoder {
  constructor(definition) {

    // create text codecs
    this.textCodec = {};
    for (let key in definition.textEncoding) {
      const encodingDef = definition.textEncoding[key];
      this.textCodec[key] = new ROMTextCodec(encodingDef, definition.charTable);
    }

    this.currentIndex = 0;
    this.indexStack = [];
  }

  encodeROM(definition) {
    for (let key in definition.assembly) {
      const objDefinition = definition.assembly[key];
      if (!objDefinition.file || !objDefinition.isDirty) continue;

      const obj = definition.obj[key];

      console.log(`Encoding ${objDefinition.asmSymbol}`);
      this.encodeParentObject(obj, objDefinition);
    }
  }

  encodeParentObject(obj, definition) {
    // const definition = this.dataMgr.getDefinition(key);
    // const obj = this.dataMgr.getObject(key);
    if (isArray(obj) ^ (definition.type === 'array')) {
      console.log(`Object/definition mismatch: ${definition.asmSymbol}`);
      return;
    }

    let objData;
    let pointers = [];
    this.currentIndex = 0;
    if (definition.type !== 'array') {
      // single object
      objData = this.encodeObject(obj, definition, null);
      pointers.push(0);

    } else if (definition.isSequential || (definition.terminator !== undefined)) {
      // sequential array items
      let totalLength = 0;
      let dataArray = [];
      for (let i = 0; i < obj.length; i++) {
        pointers.push(totalLength);
        const itemData = this.encodeObject(obj[i], definition.assembly, null);
        this.currentIndex++;
        dataArray.push(itemData);
        totalLength += itemData.length;
      }
      objData = new Uint8Array(totalLength);
      for (let i = 0; i < obj.length; i++) {
        objData.set(dataArray[i], pointers[i]);
      }

    } else if (definition.itemLength) {
      // fixed-length array items
      const length = definition.itemLength;
      let totalLength = length * obj.length;
      objData = new Uint8Array(totalLength);
      for (let i = 0; i < obj.length; i++) {
        const begin = i * length;
        pointers.push(begin);
        let itemData = new Uint8Array(length);
        itemData = this.encodeObject(obj[i], definition.assembly, itemData);
        this.currentIndex++;
        objData.set(itemData, begin);
      }

    } else {
      // shared array items
      objData = new Uint8Array(0);
      for (let i = 0; i < obj.length; i++) {
        const itemData = this.encodeObject(obj[i], definition.assembly, null);
        this.currentIndex++;
        let offset = findSubarray(objData, itemData);
        if (offset === -1) {
          // data not found
          offset = objData.length;
          const newData = new Uint8Array(offset + itemData.length);
          newData.set(objData);
          newData.set(itemData, offset);
          objData = newData;
        }
        pointers.push(offset);
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
    const asmSymbol = definition.asmSymbol;

    let asmString = '';
    asmString += '.list off\n';
    asmString += '\n';
    asmString += `.define ${asmSymbol}Size`;
    asmString += ` ${hexString(objData.length, 4, '$')}\n`;
    if (definition.arrayLength) {
      asmString += `.define ${asmSymbol}ArrayLength`;
      asmString += ` ${definition.arrayLength}\n`;
    }
    // if (definition.itemLength) {
    //   asmString += `.define ${asmSymbol}ItemLength`;
    //   asmString += ` ${definition.itemLength}\n`;
    // }

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

  encodeObject(obj, definition, data) {

    // default definition is raw data
    definition = definition || { type: 'data' };

    if (definition.type === 'text') {
      const encodingKey = definition.encoding;
      const textCodec = this.textCodec[encodingKey];
      const begin = definition.begin || 0;
      const textData = textCodec.encode(obj);
      if (data) {
        const padValue = textCodec.getPadValue();
        data.fill(padValue, begin);
        data.set(textData, begin);
      } else {
        data = textData;
      }

    } else if (definition.type === 'assembly') {
      for (let key in obj) {
        const subDefinition = definition.assembly[key];

        // skip invalid assemblies
        const index = this.currentIndex;
        const invalid = subDefinition.invalid;
        if (invalid && eval(invalid)) continue;

        data = this.encodeObject(obj[key], subDefinition, data);
      }

    } else if (definition.type === 'array') {
      data = this.encodeArray(obj, definition, data);

    } else if (definition.type === 'property') {
      data = this.encodeProperty(obj, definition, data);

    } else {
      data = new Uint8Array(Buffer.from(obj, 'base64'));
    }

    if (definition.format) {
      const dataCodec = new ROMDataCodec(definition.format);
      data = dataCodec.encode(data);
    }
    return data;
  }

  encodeProperty(obj, definition, data) {

    let value = obj;

    // modify the value if needed
    if (definition.bool) value = (value ? 1 : 0);

    // calculate the index of the first bit
    let mask = Number(definition.mask) || 0xFF;
    let bitIndex = 0;
    let firstBit = 1;
    while (!(firstBit & mask)) {
      bitIndex++;
      firstBit <<= 1;
    }

    // shift and mask the value
    value = (value << bitIndex) & mask;

    // find the beginning and end of this property
    const begin = Number(definition.begin) || 0;
    let end = begin;
    let byteMask = 0xFF;
    while (byteMask & mask) {
      byteMask <<= 8;
      end++;
    }

    // validate the data length
    if (!data) {
      data = new Uint8Array(end);
    } else if (end > data.length) {
      let newData = new Uint8Array(end);
      newData.set(data);
      data = newData;
    }

    // copy property value to data
    let unmask = (~mask) >>> 0;
    for (let i = begin; i < end; i++) {
        data[i] &= (unmask & 0xFF);
        data[i] |= (value & 0xFF);
        unmask >>= 8;
        value >>= 8;
    }

    return data;
  }

  encodeArray(obj, definition, data) {

    this.indexStack.push(this.currentIndex);
    this.currentIndex = 0;
    let pointers = [];
    if (definition.itemLength) {
      // fixed-length array items
      const length = definition.itemLength;
      let totalLength = length * obj.length;
      data = new Uint8Array(totalLength);
      for (let i = 0; i < obj.length; i++) {
        const begin = i * length;
        pointers.push(begin);
        let itemData = new Uint8Array(length);
        itemData = this.encodeObject(obj[i], definition.assembly, itemData);
        this.currentIndex++;
        data.set(itemData, begin);
      }

    } else {
      // sequential array items
      let totalLength = 0;
      let dataArray = [];
      for (let i = 0; i < obj.length; i++) {
        pointers.push(totalLength);
        const itemData = this.encodeObject(obj[i], definition.assembly, null);
        this.currentIndex++;
        dataArray.push(itemData);
        totalLength += itemData.length;
      }
      data = new Uint8Array(totalLength);
      for (let i = 0; i < obj.length; i++) {
        data.set(dataArray[i], pointers[i]);
      }
    }

    this.currentIndex = this.indexStack.pop();
    return data;
  }
}

function findSubarray(arr, subarr) {

  for (let i = 0; i < 1 + (arr.length - subarr.length); i++) {
    let found = true;
    for (let j = 0; j < subarr.length; j++) {
      if (arr[i + j] !== subarr[j]) {
        found = false;
        break;
      }
    }
    if (found) return i;
  }
  return -1;
}

module.exports = ROMEncoder;
