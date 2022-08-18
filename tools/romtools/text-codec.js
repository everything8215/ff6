const fs = require('fs');
const isString = require('is-string');
const isNumber = require('is-number');
const isArray = require('isarray');
const hexString = require('./hex-string');

class ROMTextCodec {
  constructor(definition, charTables) {

    this.encodingTable = {};
    this.decodingTable = [];

    if (!isArray(definition.charTable)) {
      console.log('Invalid text encoding');
      return;
    }
    for (let charTableKey of definition.charTable) {
      const charTable = charTables[charTableKey];
      if (!charTable) {
        console.log('Character table not found: ${charTableKey}');
        continue;
      }
      const keys = Object.keys(charTable.char);
      for (let c = 0; c < keys.length; c++) {
        const key = keys[c];
        const value = charTable.char[key];
        this.decodingTable[Number(key)] = value;
        this.encodingTable[value] = Number(key);
      }
    }
  }

  decode(data) {
    let text = '';
    let i = 0;
    let b1, b2, c;

    while (i < data.length) {
      c = null;
      b1 = data[i++];
      b2 = data[i++];
      if (b1) c = this.decodingTable[(b1 << 8) | b2];
      if (!c) {
        c = this.decodingTable[b1];
        i--;
      }

      if (!c) {
        // unknown character
        text += hexString(b1, 2, '\\x');
      } else if (c == '\\0') {
        // string terminator
        break;
      } else if (c.endsWith('[[')) {
        // 2-byte parameter
        text += c;
        b1 = data[i++] || 0;
        b2 = data[i++] || 0;
        text += hexString(b1 | (b2 << 8), 4);
        text += ']]';
      } else if (c.endsWith('[')) {
        // 1-byte parameter
        text += c;
        b1 = data[i++] || 0;
        text += hexString(b1, 2);
        text += ']';
      } else {
        // no parameter
        text += c;
      }
    }

    // remove padding from the end of the string
    while (text.endsWith('\\pad')) {
      text = text.substring(0, text.length - 4);
    }

    return text;
  }

  encode(text) {
    let data = [];
    let i = 0;
    const keys = Object.keys(this.encodingTable);

    while (i < text.length) {
      var remainingText = text.substring(i);
      var matches = keys.filter(function(s) {
        return remainingText.startsWith(s);
      });

      if (!matches.length && remainingText.startsWith('\\x')) {
        const parameter = `0${remainingText.substring(1, 4)}`;
        i += 4;
        const n = Number(parameter);
        if (!isNumber(n)) {
          console.log(`Invalid value: ${parameter}`);
        } else {
          data.push(n);
        }
        continue;

      } else if (!matches.length) {
        console.log(`Invalid character: ${remainingText[0]}`);
        i++;
        continue;
      }

      const match = matches.reduce(function (a, b) {
          return a.length > b.length ? a : b;
      });

      // end of string
      if (match === '\\0') break;

      let value = this.encodingTable[match];
      i += match.length;

      if (match.endsWith('[[')) {
        // 2-byte parameter
        let end = text.indexOf(']]', i);
        const parameter = text.substring(i, end);
        let n = Number(parameter);
        if (!isNumber(n) || n > 0xFFFF) {
          console.log(`Invalid parameter: ${parameter}`);
          n = 0;
          end = i;
        }
        i = end + 2;
        value <<= 16;
        value |= n;
      } else if (match.endsWith('[')) {
        // 1-byte parameter
        let end = text.indexOf(']', i);
        const parameter = text.substring(i, end);
        let n = Number(parameter);
        if (!isNumber(n) || n > 0xFF) {
          console.log(`Invalid parameter: ${parameter}`);
          n = 0;
          end = i;
        }
        i = end + 1;
        value <<= 8;
        value |= n;
      }

      if (value > 0xFF) {
        data.push(value >> 8);
        data.push(value & 0xFF);
      } else {
        data.push(value);
      }
    }

    const terminator = this.encodingTable['\\0'];
    if (isNumber(terminator) && data[data.length - 1] !== terminator) {
      data.push(terminator);
    }

    return Uint8Array.from(data);
  }

  textLength(data) {
      var i = 0;
      var b1, b2, c;

      while (i < data.length) {
          c = null;
          b1 = data[i++];
          b2 = data[i++];
          if (b1) c = this.decodingTable[(b1 << 8) | b2];
          if (!c) {
              c = this.decodingTable[b1];
              i--;
          }

          if (!c) {
              continue;
          } else if (c === '\\0') {
              break; // string terminator
          } else if (c.endsWith('[[')) {
              i += 2;
          } else if (c.endsWith('[')) {
              i++;
          }
      }

      return Math.min(i, data.length);
  }

  getPadValue() {
    return this.encodingTable['\\pad'] || 0;
  }
}

module.exports = ROMTextCodec;
