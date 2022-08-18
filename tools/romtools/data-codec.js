//
// data-codec.js
// created 12/29/2021
//

const GFX = require('./gfx');
const isArray = require('isarray');

class ROMDataCodec {

  constructor(format) {

    this.encodeList = [];
    this.decodedData = null;
    this.encodedData = null;

    if (isArray(format)) {
      // multi-format
      for (const formatStep of format) {
        this.encodeList.push(this.parseFormat(formatStep));
      }
    } else if (format) {
      // single format
      this.encodeList.push(this.parseFormat(format));
    }
    this.decodeList = this.encodeList.slice().reverse();
  }

  parseFormat(formatString) {

    const format = { raw: formatString };

    // parse the format name
    const nameMatch = formatString.match(/[^\(]+/);
    if (!nameMatch) return format;
    format.name = nameMatch[0];

    // get the encoding and decoding functions
    const codec = ROMDataCodec.Codec[format.name];
    if (!codec) return format;
    format.encode = codec.encode;
    format.decode = codec.decode;

    // parse arguments
    format.args = [];
    const argsMatch = formatString.match(/\((.*?)\)/);
    if (!argsMatch || argsMatch.length < 2) return format;
    const argsList = argsMatch[1].split(',');
    for (const arg of argsList) {
      format.args.push(Number(arg));
    }

    return format;
  }

  encode(data) {

    this.decodedData = data;
    this.encodedData = data;
    const dataObject = {};
    for (const format of this.encodeList) {
      if (!format.encode) continue;
      dataObject.src = this.encodedData;
      format.encode.apply(null, [dataObject].concat(format.args));
      this.encodedData = dataObject.dest;
    }
    return this.encodedData;
  }

  decode(data) {

    this.encodedData = data;
    this.decodedData = data;
    const dataObject = {};
    for (const [i, format] of this.decodeList.entries()) {
      if (!format.encode) continue;
      dataObject.src = this.decodedData;
      format.decode.apply(null, [dataObject].concat(format.args));
      this.decodedData = dataObject.dest;
      if (i === 0) {
        // get trimmed encoded data
        this.encodedData = dataObject.src;
      }
    }
    return this.decodedData;
  }
}

ROMDataCodec.Codec = {
  // generic formats
  "byteSwapped": {
    encode: function(data, width) {
      if (!width) {
        data.dest = data.src.slice().reverse();
        return;
      }
      var s = 0;
      data.dest = new Uint8Array(data.src.length);
      var d = 0;
      for (var i = 0; i < data.src.length; i++) {
        d = s + width - 1;
        for (var b = 0; b < width; b++) {
          data.dest[d--] = data.src[s++];
        }
      }
    },
    decode: function(data, width) {
      if (!width) {
        data.dest = data.src.slice().reverse();
        return;
      }
      var s = 0;
      data.dest = new Uint8Array(data.src.length);
      var d = 0;
      for (var i = 0; i < data.src.length; i++) {
        d = s + width - 1;
        for (var b = 0; b < width; b++) data.dest[d--] = data.src[s++];
      }
    }
  },
  "interlace": {
    encode: function(data, word, layers, stride) {
      var step = word * layers;
      var block = step * stride;
      var length = Math.ceil(data.src.length / block) * block;
      var src = new Uint8Array(length);
      src.set(data.src);
      data.src = src;
      var s = 0;
      data.dest = new Uint8Array(length);
      var d = 0;
      while (s < data.src.length) {
        var s1 = s;
        while ((s1 - s) < step) {
          var s2 = s1;
          while ((s2 - s) < block) {
            data.dest.set(data.src.subarray(s2, s2 + word), d);
            d += word;
            s2 += step;
          }
          s1 += word;
        }
        s += block;
      }
    },
    decode: function(data, word, layers, stride) {
      var step = word * stride;
      var block = step * layers;
      var length = Math.ceil(data.src.length / block) * block;
      var src = new Uint8Array(length);
      src.set(data.src);
      data.src = src;
      var s = 0;
      data.dest = new Uint8Array(length);
      var d = 0;
      while (s < data.src.length) {
        var s1 = s;
        while ((s1 - s) < step) {
          var s2 = s1;
          while ((s2 - s) < block) {
            data.dest.set(data.src.subarray(s2, s2 + word), d);
            d += word;
            s2 += step;
          }
          s1 += word;
        }
        s += block;
      }
    }
  },
  "terminated": {
    encode: function(data, terminator, stride) {
      terminator = terminator || 0;
      stride = stride || 1;
      let length = data.src.length;
      if (length % stride) {
        length += stride - (length % stride);
        const src = new Uint8Array(length);
        src.set(data.src);
        data.src = src;
      }
      data.dest = new Uint8Array(length + 1);
      data.dest.set(data.src);
      data.dest[data.src.length] = terminator;
    },
    decode: function(data, terminator, stride) {
      terminator = terminator || 0;
      stride = stride || 1;
      let length = 0;
      while (length < data.src.length) {
        if (data.src[length] === terminator) break;
        length += stride;
      }
      data.src = data.src.slice(0, length + 1);
      data.dest = data.src.slice(0, length);
    }
  },

  // graphics formats
  "linear8bpp": GFX.graphicsFormat.linear8bpp,
  "linear4bpp": GFX.graphicsFormat.linear4bpp,
  "linear2bpp": GFX.graphicsFormat.linear2bpp,
  "linear1bpp": GFX.graphicsFormat.linear1bpp,
  "nes2bpp": GFX.graphicsFormat.nes2bpp,
  "snes2bpp": GFX.graphicsFormat.snes2bpp,
  "snes3bpp": GFX.graphicsFormat.snes3bpp,
  "snes4bpp": GFX.graphicsFormat.snes4bpp,

  // palette formats
  "rgb888": GFX.paletteFormat.rgb888,
  "rgb444": GFX.paletteFormat.rgb444,
  "bgr555": GFX.paletteFormat.bgr555,
  "nesPalette": GFX.paletteFormat.nesPalette,

  // tile formats
  "defaultTile": GFX.tileFormat.defaultTile,
  "generic8bppTile": GFX.tileFormat.generic8bppTile,
  "generic4bppTile": GFX.tileFormat.generic4bppTile,
  "generic2bppTile": GFX.tileFormat.generic2bppTile,
  "gba8bppTile": GFX.tileFormat.gba8bppTile,
  "gba4bppTile": GFX.tileFormat.gba4bppTile,
  "gba2bppTile": GFX.tileFormat.gba2bppTile,
  "nesNameTable": GFX.tileFormat.nesNameTable,
  "snes4bppTile": GFX.tileFormat.snes4bppTile,
  "snes3bppTile": GFX.tileFormat.snes3bppTile,
  "snes2bppTile": GFX.tileFormat.snes2bppTile,
  "snesSpriteTile": GFX.tileFormat.snesSpriteTile,
  "x16_4bppTile": GFX.tileFormat.x16_4bppTile,

  // game-specific formats
  "ff1-map": {
    encode: function(data) {
      var s = 0; // source pointer
      data.dest = new Uint8Array(4096);
      var d = 0;
      var b, l;

      while (s < data.src.length) {
        b = data.src[s++];
        l = 0;
        while (b === data.src[s + l]) l++;
        if (l > 255) {
          data.dest[d++] = b | 0x80;
          data.dest[d++] = 0;
          s += 255;
        } else if (l >= 1) {
          data.dest[d++] = b | 0x80;
          data.dest[d++] = l + 1;
          s += l;
        } else {
          data.dest[d++] = b;
        }
      }
      data.dest[d++] = 0xFF;
      data.dest = data.dest.slice(0, d);
    },
    decode: function(data) {
      var s = 0; // source pointer
      data.dest = new Uint8Array(4096);
      var d = 0; // destination pointer
      var b, l;

      while (s < data.src.length) {
        b = data.src[s++];
        if (b === 0xFF) break;
        if (b & 0x80) {
          l = data.src[s++] || 256;
          b &= 0x7F;
          while (l--) data.dest[d++] = b;
        } else {
          data.dest[d++] = b;
        }
      }
      data.dest = data.dest.slice(0, d);
    }
  },
  "ff1-shop": {
    encode: function(data) {
      data.dest = new Uint8Array(6);
      var d = 0;
      for (var s = 0; s < 5; s++) {
        if (!data.src[s]) continue;
        data.dest[d++] = data.src[s];
      }
      data.dest[d++] = 0;
      data.dest = data.dest.slice(0, d);
    },
    decode: function(data) {
      data.dest = new Uint8Array(5);
      var d = 0;
      for (var s = 0; s < data.src.length; s++) {
        if (!data.src[s]) break;
        data.dest[d++] = data.src[s];
      }
    }
  },
  "ff4-battlebg": {
    encode: function(data) {
      // 16-bit source, 8-bit destination
      const src16 = new Uint16Array(data.src.buffer);
      data.dest = new Uint8Array(src16.length);
      for (var i = 0; i < src16.length; i++) {
        var t = src16[i] & 0x3F;
        var p = src16[i] & 0x0400;
        var v = src16[i] & 0x8000;
        data.dest[i] = t | (p >> 4) | (v >> 8);
      }
      return data.dest;
    },
    decode: function(data) {
      // 8-bit source, 16-bit destination
      const dest16 = new Uint16Array(data.src.length);
      for (var i = 0; i < data.src.length; i++) {
        var t = data.src[i] & 0x3F;
        var p = data.src[i] & 0x40;
        var v = data.src[i] & 0x80;
        dest16[i] = t | (p << 4) | (v << 8);
      }
      data.dest = new Uint8Array(dest16.buffer);
    }
  },
  "ff4-monster": {
    encode: function(data) {
      data.dest = new Uint8Array(20);
      data.dest.set(data.src.subarray(0, 9));
      let flags = 0;
      let d = 10;
      if (data.src[10] || data.src[11] || data.src[12]) {
        flags |= 0x80;
        data.dest.set(data.src.subarray(10, 13), d);
        d += 3;
      }
      if (data.src[13] || data.src[14] || data.src[15]) {
        flags |= 0x40;
        data.dest.set(data.src.subarray(13, 16), d);
        d += 3;
      }
      if (data.src[16]) {
        flags |= 0x20;
        data.dest[d++] = data.src[16];
      }
      if (data.src[17]) {
        flags |= 0x10;
        data.dest[d++] = data.src[17];
      }
      if (data.src[18]) {
        flags |= 0x08;
        data.dest[d++] = data.src[18];
      }
      if (data.src[19]) {
        flags |= 0x04;
        data.dest[d++] = data.src[19];
      }
      data.dest[9] = flags;
      data.dest = data.dest.slice(0, d);
    },
    decode: function(data) {
      data.dest = new Uint8Array(20);
      data.dest.set(data.src.subarray(0, 9));
      let flags = data.src[9];
      let i = 10;
      if (flags & 0x80) {
        data.dest.set(data.src.subarray(i, i + 3), 10);
        i += 3;
      }
      if (flags & 0x40) {
        data.dest.set(data.src.subarray(i, i + 3), 13);
        i += 3;
      }
      if (flags & 0x20) data.dest[16] = data.src[i++];
      if (flags & 0x10) data.dest[17] = data.src[i++];
      if (flags & 0x08) data.dest[18] = data.src[i++];
      if (flags & 0x04) data.dest[19] = data.src[i++];
    }
  },
  "ff4-world": {
    encode: function(data) {
      var s = 0; // source pointer
      data.dest = new Uint8Array(256);
      var d = 0;
      var b, l;

      while (s < data.src.length) {
        b = data.src[s++];
        if ((b === 0x00) || (b === 0x10) || (b === 0x20) || (b === 0x30)) {
          data.dest[d++] = b;
          s += 3;
          continue;
        }
        l = 0;
        while (((s + l) < data.src.length) && (b === data.src[s + l])) {
          l++;
        }
        if (l > 1) {
          data.dest[d++] = b | 0x80;
          data.dest[d++] = l;
          s += l;
        } else {
          data.dest[d++] = b;
        }
      }
      data.dest = data.dest.slice(0, d);
    },
    decode: function(data) {
      var s = 0; // source pointer
      data.dest = new Uint8Array(256);
      var d = 0; // destination pointer
      var b, l;

      while (s < data.src.length) {
        b = data.src[s++];
        if (b & 0x80) {
          l = data.src[s++] + 1;
          b &= 0x7F;
          while (l--) data.dest[d++] = b;
        } else if ((b === 0x00) || (b === 0x10) || (b === 0x20) || (b === 0x30)) {
          data.dest[d++] = b;
          data.dest[d++] = (b >> 4) * 3 + 0x70;
          data.dest[d++] = (b >> 4) * 3 + 0x71;
          data.dest[d++] = (b >> 4) * 3 + 0x72;
        } else {
          data.dest[d++] = b;
        }
      }
      data.dest = data.dest.slice(0, d);
    }
  },
  "ff4-map": {
    encode: function(data) {
      var s = 0; // source pointer
      data.dest = new Uint8Array(1024);
      var d = 0;
      var b, l;

      while (s < data.src.length) {
        b = data.src[s];
        l = 1;
        while (((s + l) < data.src.length) && (b === data.src[s + l])) {
          l++;
        }
        if (l > 1) {
          l = Math.min(l, 256);
          data.dest[d++] = b | 0x80;
          data.dest[d++] = l - 1;
          s += l;
        } else {
          data.dest[d++] = b;
          s++;
        }
      }
      data.dest = data.dest.slice(0, d);
    },
    decode: function(data) {
      var s = 0; // source pointer
      data.dest = new Uint8Array(1024);
      var d = 0; // destination pointer
      var b, l;

      while (s < data.src.length) {
        b = data.src[s++];
        if (b & 0x80) {
          l = data.src[s++] + 1;
          b &= 0x7F;
          while (l--) data.dest[d++] = b;
        } else {
          data.dest[d++] = b;
        }
      }
      data.dest = data.dest.slice(0, d);
    }
  },
  "ff4a-world-tile-properties": {
    encode: function(data) {
      var s = 0; // source pointer
      data.dest = new Uint8Array(1024);
      var d = 0; // destination pointer

      while (s < 256) {
        var start = s++;
        var value = data.src[start];
        if (value === 0) continue;
        var end = s;
        while (data.src[end] === value) end++;
        data.dest[d++] = start;
        data.dest[d++] = end - 1;
        data.dest[d++] = value - 1; d++;
        s = end;
      }
      d += 4;
      data.dest = data.dest.slice(0, d);
    },
    decode: function(data) {
      var s = 0; // source pointer
      data.dest = new Uint8Array(256);
      var d = 0; // destination pointer
      var start, end, value;

      while (s < data.src.length) {
        start = data.src[s++];
        end = data.src[s++];
        if (start === 0 && end === 0) break;
        value = data.src[s++]; s++;
        while (start <= end) data.dest[start++] = value + 1;
      }
    }
  },
  "ff5-battlebg": {
    encode: function(data) {
      const src16 = new Uint16Array(data.src.buffer);
      // var src = new Uint16Array(data.buffer, data.byteOffset, data.byteLength >> 1);
      data.dest = new Uint8Array(0x280);
      var s = 0;
      var d = 0;
      var b;

      while (s < 0x0280) {

        var s0 = src16[s];
        var s1 = src16[s+1];
        var s2 = src16[s+2];
        var s3 = src16[s+3];
        var s4 = src16[s+4];
        var s5 = src16[s+5];

        // if (s0 === s1 && s1 === s2 && s2 === s3 && s3 === s4 && s4 !== s5) {
        //     // this is a very specific case where exactly 5 identical
        //     // bytes in a row can be compressed more efficiently via
        //     // the second method than the first
        //     s += 5;
        //     dest[d++] = 0xFF;
        //     dest[d++] = 5;
        //     dest[d++] = s0;
        //     if (s0 & 0x0400) dest[d-1] |= 0x80;
        //     dest[d++] = 0;
        // } else
        if (s0 !== s1 && s0 === s2 && s0 === s4 && s1 === s3 && s1 === s5) {
          b = 3;
          s += 6;
          while (src16[s-2] === src16[s] && src16[s-1] === src16[s+1] && b < 0x40) {
            b++;
            s += 2
          }
          data.dest[d++] = 0xFF;
          data.dest[d++] = b | 0x80;
          data.dest[d++] = s0 & 0x7F;
          if (s0 & 0x0400) data.dest[d-1] |= 0x80;
          data.dest[d++] = s1 & 0x7F;
          if (s1 & 0x0400) data.dest[d-1] |= 0x80;
        } else if ((s1 - s0) === (s2 - s1) &&
        (s2 - s1) === (s3 - s2) &&
        (s3 - s2) === (s4 - s3)) {
          var delta = s1 - s0;
          s += 4;
          b = 4;
          while ((src16[s] - src16[s - 1]) === delta && b < 0x40) {
            s++; b++;
          }
          if (delta < 0) b |= 0x40;
          data.dest[d++] = 0xFF;
          data.dest[d++] = b;
          data.dest[d++] = s0 & 0x7F;
          if (s0 & 0x0400) data.dest[d-1] |= 0x80;
          data.dest[d++] = (delta >= 0 ? delta : -delta);
        } else {
          data.dest[d++] = s0 & 0x7F;
          if (s0 & 0x0400) data.dest[d-1] |= 0x80;
          s++;
        }
      }
      data.dest = data.dest.slice(0, d);
    },
    decode: function(data) {
      const dest16 = new Uint16Array(0x0280);
      var s = 0;
      var d = 0;
      while (d < 0x0280) {
        var b = data.src[s++];
        if (b !== 0xFF) {
          dest16[d++] = b;
          continue;
        }

        b = data.src[s++];
        var t1 = data.src[s++];
        var t2 = data.src[s++];

        if (b & 0x80) {
          b &= 0x3F;
          for (var i = 0; i < b; i++) {
            dest16[d++] = t1;
            dest16[d++] = t2;
          }
        } else if (b & 0x40) {
          b &= 0x3F;
          for (var i = 0; i < b; i++) {
            dest16[d++] = t1;
            t1 -= t2;
          }
        } else {
          b &= 0x3F;
          for (var i = 0; i < b; i++) {
            dest16[d++] = t1;
            t1 += t2;
          }
        }
      }
      for (var i = 0; i < 0x0280; i++) {
        if (dest16[i] & 0x80) {
          dest16[i] &= 0x007F;
          dest16[i] |= 0x0400;
        }
      }
      data.src = data.src.slice(0, s);
      data.dest = new Uint8Array(dest16.buffer);
    }
  },
  "ff5-battlebgflip": {
    encode: function(data) {
      data.dest = new Uint8Array(0x50);
      var s = 0;
      var d = 0;
      var run = 0;

      while (s < data.src.length) {
        var b = 0;
        // get the next 8 bits
        for (var i = 0; i < 8; i++) {
          b <<= 1;
          if (data.src[s++]) b |= 0x01;
        }

        if (b === 0) {
          // 8 sequential zeros
          run++;
        } else {
          if (run) {
            // encode sequential zeros
            data.dest[d++] = 0;
            data.dest[d++] = run;
            run = 0;
          }
          data.dest[d++] = b;
        }
      }
      if (run) {
        // fill in leftover run of zeros
        data.dest[d++] = 0;
        data.dest[d++] = run;
      }
      data.dest = data.dest.slice(0, d);
    },
    decode: function(data) {
      data.dest = new Uint8Array(0x0280);
      var s = 0;
      var d = 0;
      while (d < 0x0280) {
        var b = data.src[s++];
        if (b === 0) {
          // repeat zero
          var c = data.src[s++] * 8;
          for (var i = 0; i < c; i++) data.dest[d++] = 0;
          continue;
        }

        for (var i = 0; i < 8; i++) {
          data.dest[d++] = b & 0x80;
          b <<= 1;
        }
      }
    }
  },
  "ff5-world": {
    encode: function(data) {
      var s = 0; // source pointer
      data.dest = new Uint8Array(256);
      var d = 0;
      var b, l;

      while (s < 256) {
        b = data.src[s++];
        if ((b === 0x0C) || (b === 0x1C) || (b === 0x2C)) {
          data.dest[d++] = b;
          s += 2;
          continue;
        }
        l = 0;
        while (b === data.src[s + l]) l++;
        if (l > 1) {
          l = Math.min(l, 32);
          data.dest[d++] = 0xC0 + l;
          data.dest[d++] = b;
          s += l;
        } else {
          data.dest[d++] = b;
        }
      }

      data.src = data.src.slice(0, s);
      data.dest = data.dest.slice(0, s);
    },
    decode: function(data) {
      var s = 0; // source pointer
      data.dest = new Uint8Array(256);
      var d = 0; // destination pointer
      var b, l;

      while (s < data.src.length) {
        b = data.src[s++];
        if (b > 0xBF) {
          l = b - 0xBF;
          b = data.src[s++];
          while (l--) data.dest[d++] = b;
        } else if ((b === 0x0C) || (b === 0x1C) || (b === 0x2C)) {
          data.dest[d++] = b;
          data.dest[d++] = b + 1;
          data.dest[d++] = b + 2;
        } else {
          data.dest[d++] = b;
        }
      }
    }
  },
  "ff5-lzss": {
    encode: function(data) {

      const length = data.src.length;

      // create a source buffer preceded by 2K of empty space (this increases compression for some data)
      const src = new Uint8Array(0x0800 + data.src.length);
      src.set(data.src, 0x0800);
      data.src = src;
      var s = 0x0800; // start at 0x0800 to ignore the 2K of empty space

      data.dest = new Uint8Array(0x10000);
      var d = 2; // start at 2 so we can fill in the length at the end

      var header = 0;
      var line = new Uint8Array(17);

      var l = 1; // start at 1 so we can fill in the header at the end
      var b = 0x07DE; // buffer position
      var p = 0;
      var pMax, len, lenMax;

      var w;
      var mask = 1;

      while (s < data.src.length) {
        // find the longest sequence that matches the decompression buffer
        lenMax = 0;
        pMax = 0;
        for (p = 1; p <= 0x0800; p++) {
          len = 0;

          while ((len < 34) && (s + len < data.src.length) && (data.src[s + len - p] === data.src[s + len])) len++;

          if (len > lenMax) {
            // this sequence is longer than any others that have been found so far
            lenMax = len;
            pMax = (b - p) & 0x07FF;
          }
        }

        // check if the longest sequence is compressible
        if (lenMax >= 3) {
          // sequence is compressible - add compressed data to line buffer
          w = pMax & 0xFF;
          w |= (pMax & 0x0700) << 5;
          w |= (lenMax - 3) << 8;
          line[l++] = w & 0xFF;
          w >>= 8;
          line[l++] = w & 0xFF;
          s += lenMax;
          b += lenMax;
        } else {
          // sequence is not compressible - update header byte and add byte to line buffer
          header |= mask;
          line[l++] = data.src[s];
          s++;
          b++;
        }

        b &= 0x07FF;
        mask <<= 1;

        if (mask == 0x0100) {
          // finished a line, copy it to the destination
          line[0] = header;

          data.dest.set(line.subarray(0, l), d);
          d += l;
          header = 0;
          l = 1;
          mask = 1;
        }
      }

      if (mask !== 1) {
        // we're done with all the data but we're still in the middle of a line
        line[0] = header;
        data.dest.set(line.subarray(0, l), d);
        d += l;
      }

      // fill in the length
      data.dest[0] = length & 0xFF;
      data.dest[1] = (length >> 8) & 0xFF;

      // trim the buffers
      data.dest = data.dest.slice(0, d);
      data.src = data.src.slice(0x0800, s);
    },
    decode: function(data) {
      var s = 0; // source pointer
      data.dest = new Uint8Array(0x10000);
      var d = 0; // destination pointer
      var buffer = new Uint8Array(0x0800);
      var b = 0x07DE;
      var line = new Uint8Array(34);
      var header, pass, r, w, c, i, l;

      var length = data.src[s++] | (data.src[s++] << 8);
      while (d < length) { // ff5

        // read header
        header = data.src[s++];

        for (pass = 0; pass < 8; pass++, header >>= 1) {
          l = 0;
          if (header & 1) {
            // single byte (uncompressed)
            c = data.src[s++];
            line[l++] = c;
            buffer[b++] = c;
            b &= 0x07FF;
          } else {
            // 2-bytes (compressed)
            w = data.src[s++];
            r = data.src[s++];
            w |= (r & 0xE0) << 3;
            r = (r & 0x1F) + 3;

            for (i = 0; i < r; i++) {
              c = buffer[(w + i) & 0x07FF];
              line[l++] = c;
              buffer[b++] = c;
              b &= 0x07FF;
            }
          }
          if ((d + l) > data.dest.length) {
            // maximum buffer length exceeded
            data.dest.set(line.subarray(0, dest.length - d), d);
            data.src = data.src.slice(0, s);
            return;
          } else {
            // copy this pass to the destination buffer
            data.dest.set(line.subarray(0, l), d)
            d += l;
          }

          // reached end of compressed data
          if (d >= length) break; // ff5
        }
      }

      // trim the buffers
      data.src = data.src.slice(0, s);
      data.dest = data.dest.slice(0, d);
    }
  },
  "tose-70": {
    encode: function(data) {
      const encoder = new Tose70Encoder();
      encoder.encode(data);
    },
    decode: function(data) {
      const decoder = new Tose70Decoder();
      decoder.decode(data);
    }
  },
  "tose-graphics": {
    encode: function(data) {
      var header = new Uint32Array(2);
      header[0] = 1;
      header[1] = Math.floor(data.src.length / 32)
      var header8 = new Uint8Array(header.buffer);
      data.dest = new Uint8Array(8 + data.src.length);
      data.dest.set(header8, 0);
      data.dest.set(data.src, 8);
    },
    decode: function(data) {
      var header = new Uint32Array(data.src.buffer, data.src.byteOffset, 2);
      var mode = header[0]; // always 1
      if (mode !== 1) console.log(`Invalid TOSE graphics format ${mode}`);
      var count = header[1]; // tile count
      data.dest = data.src.slice(8);
    }
  },
  "tose-layout": {
    encode: function(data, width, height) {
      var header = new Uint32Array(2);
      header[0] = 2;
      header[1] = Math.floor(data.src.length / 2)
      var header8 = new Uint8Array(header.buffer);
      data.dest = new Uint8Array(12 + data.src.length);
      data.dest.set(header8, 0);
      data.src[8] = width;
      data.src[9] = height;
      data.dest.set(data.src, 12);
    },
    decode: function(data, width, height) {
      var header = new Uint32Array(data.src.buffer, data.src.byteOffset, 2);
      var mode = header[0]; // always 2
      if (mode !== 2) console.log(`Invalid TOSE layout format ${mode}`);
      var count = header[1]; // tile count
      var width = data.src[8];
      var height = data.src[9];
      data.dest = data.src.slice(12);
    }
  },
  "tose-palette": {
    encode: function(data) {
      var count = Math.ceil(data.src.length / 2); // number of colors
      var header = new Uint32Array(2);
      header[0] = 3;
      header[1] = count;
      var header8 = new Uint8Array(header.buffer);
      data.dest = new Uint8Array(8 + count * 2);
      data.dest.set(header8, 0);
      data.dest.set(data.src, 8);
    },
    decode: function(data) {
      var header = new Uint32Array(data.src.buffer, data.src.byteOffset, 2);
      var mode = header[0]; // always 3
      if (mode !== 3) console.log(`Invalid TOSE palette format ${mode}`);
      var count = header[1]; // number of 16-bit colors
      data.dest = data.src.slice(8);
    }
  },
  "ff5a-world": {
    encode: function(data) {
      var s = 0; // source pointer
      data.dest = new Uint8Array(256);
      var d = 0;
      var b;

      while (s < 256) {
        b = data.src[s++];
        while (b === data.src[s]) s++;
        data.dest[d++] = b;
        data.dest[d++] = s - 1;
      }
      data.dest = data.dest.slice(0, d);
    },
    decode: function(data) {
      var s = 0; // source pointer
      data.dest = new Uint8Array(256);
      var d = 0; // destination pointer
      var b, l;

      while (s < data.src.length) {
        b = data.src[s++];
        l = data.src[s++];
        while (d <= l) data.dest[d++] = b;
      }
    }
  },
  "ff6-lzss": {
    encode: function(data) {

      // create a source buffer preceded by 2K of empty space (this increases compression for some data)
      const src = new Uint8Array(0x0800 + data.src.length);
      src.set(data.src, 0x0800);
      data.src = src;
      var s = 0x0800; // start at 0x0800 to ignore the 2K of empty space

      data.dest = new Uint8Array(0x10000);
      var d = 2; // start at 2 so we can fill in the length at the end

      var header = 0;
      var line = new Uint8Array(17);

      var l = 1; // start at 1 so we can fill in the header at the end
      var b = 0x07DE; // buffer position
      var p = 0;
      var pMax, len, lenMax;

      var w;
      var mask = 1;

      while (s < data.src.length) {
        // find the longest sequence that matches the decompression buffer
        lenMax = 0;
        pMax = 0;
        for (p = 1; p <= 0x0800; p++) {
          len = 0;

          while ((len < 34) && (s + len < data.src.length) && (data.src[s + len - p] === data.src[s + len]))
          len++;

          if (len > lenMax) {
            // this sequence is longer than any others that have been found so far
            lenMax = len;
            pMax = (b - p) & 0x07FF;
          }
        }

        // check if the longest sequence is compressible
        if (lenMax >= 3) {
          // sequence is compressible - add compressed data to line buffer
          w = ((lenMax - 3) << 11) | pMax;
          line[l++] = w & 0xFF;
          w >>= 8;
          line[l++] = w & 0xFF;
          s += lenMax;
          b += lenMax;
        } else {
          // sequence is not compressible - update header byte and add byte to line buffer
          header |= mask;
          line[l++] = src[s];
          s++;
          b++;
        }

        b &= 0x07FF;
        mask <<= 1;

        if (mask == 0x0100) {
          // finished a line, copy it to the destination
          line[0] = header;

          data.dest.set(line.subarray(0, l), d);
          d += l;
          header = 0;
          l = 1;
          mask = 1;
        }
      }

      if (mask !== 1) {
        // we're done with all the data but we're still in the middle of a line
        line[0] = header;
        data.dest.set(line.subarray(0, l), d);
        d += l;
      }

      // fill in the length
      data.dest[0] = d & 0xFF;
      data.dest[1] = (d >> 8) & 0xFF;

      // trim the buffers
      data.dest = data.dest.slice(0, d);
      data.src = data.src.slice(0x0800, s);
    },
    decode: function(data) {
      var s = 0; // source pointer
      data.dest = new Uint8Array(0x10000);
      var d = 0; // destination pointer
      var buffer = new Uint8Array(0x0800);
      var b = 0x07DE; // buffer pointer
      var line = new Uint8Array(34);
      var header, pass, r, w, c, i, l;

      var length = data.src[s++] | (data.src[s++] << 8);
      if (length === 0xFFFF) {
        ROMDataCodec.Codec['apultra'].decode(data);
        // return ROM.dataFormat.apultra.decode(data);
      }
      while (s < length) {

        // read header
        header = data.src[s++];

        for (pass = 0; pass < 8; pass++, header >>= 1) {
          l = 0;
          if (header & 1) {
            // single byte (uncompressed)
            c = data.src[s++];
            line[l++] = c;
            buffer[b++] = c;
            b &= 0x07FF;
          } else {
            // 2-bytes (compressed)
            w = data.src[s++];
            w |= (data.src[s++] << 8);
            r = (w >> 11) + 3;
            w &= 0x07FF;

            for (i = 0; i < r; i++) {
              c = buffer[(w + i) & 0x07FF];
              line[l++] = c;
              buffer[b++] = c;
              b &= 0x07FF;
            }
          }
          if ((d + l) > data.length) {
            // maximum destination buffer length exceeded
            data.dest.set(line.subarray(0, data.dest.length - d), d)
            data.src = data.src.slice(0, s);
            return;
          } else {
            // copy this pass to the destination buffer
            data.dest.set(line.subarray(0, l), d)
            d += l;
          }

          // reached end of compressed data
          if (s >= length) break;
        }
      }

      // trim the buffers
      data.src = data.src.slice(0, s);
      data.dest = data.dest.slice(0, d);
    }
  },
  "ff6-animation-frame": {
    encode: function(data) {
      // 16-bit source, 16-bit destination
      const dest16 = new Uint16Array(data.src.length);
      var d = 0;
      for (var i = 0; i < data.src.length; i++) {
        if (src[i] === 0xFFFF) continue;  // skip blank tiles
        var t = src[i] & 0xFF;
        var x = i & 0x0F;
        var y = i >> 4;
        dest16[d++] = (t << 8) | (x << 4) | y;
      }
      data.dest = new Uint8Array(dest16.buffer);
    },
    decode: function(data) {
      // 16-bit source, 16-bit destination
      data.dest = new Uint16Array(256);
      data.dest.fill(0xFFFF);  // blank tiles are 0xFF
      for (var i = 0; i < data.src.length; i++) {
        var t = (src[i] & 0xFF00) >> 8;
        var x = (src[i] & 0xF0) >> 4;
        var y = src[i] & 0x0F;
        data.dest[x + y * 16] = t;
      }
    }
  },
  "ff6-animation-tilemap": {
    encode: function(data) {
      // 32-bit source, 16-bit destination
      const src32 = new Uint32Array(data.src.buffer);
      const dest16 = new Uint16Array(src32.length);
      for (var i = 0; i < src32.length; i++) {
        var t = src32[i] & 0x3FFF;
        var h = src32[i] & 0x10000000;
        var v = src32[i] & 0x20000000;
        dest16[i] = t | (h >> 14) | (v >> 14);
      }
      data.dest = new Uint8Array(dest16.buffer);
    },
    decode: function(data) {
      // 16-bit source, 32-bit destination
      const src16 = new Uint16Array(data.src.buffer);
      const dest32 = new Uint32Array(src16.length);
      for (var i = 0; i < src16.length; i++) {
        var t = src16[i] & 0x3FFF;
        var h = src16[i] & 0x4000;
        var v = src16[i] & 0x8000;
        dest32[i] = t | (h << 14) | (v << 14);
      }
      data.dest = new Uint8Array(dest32.buffer);
    }
  },
  "gba-lzss": {
    encode: function(data) {

      // note: gba format doesn't allow an empty preceding buffer
      var s = 0;

      data.dest = new Uint8Array(0x10000);
      var d = 0;

      // fill in the compression identifier byte and the length
      data.dest[d++] = 0x10;
      data.dest[d++] = data.src.length & 0xFF;
      data.dest[d++] = (data.src.length >> 8) & 0xFF;
      data.dest[d++] = (data.src.length >> 16) & 0xFF;

      var header = 0;
      var line = new Uint8Array(17);

      var l = 1; // start at 1 so we can fill in the header at the end
      var p = 0;
      var pMax, len, lenMax;

      var w;
      var mask = 0x80;

      while (s < data.src.length) {
        // find the longest sequence that matches the decompression buffer
        lenMax = 0;
        pMax = 0;
        for (p = 1; p <= 0x1000; p++) {
          len = 0;

          if (p > s) break;
          while ((len < 18) && (s + len < data.src.length) && (data.src[s + len - p] === data.src[s + len]))
          len++;

          if (len > lenMax) {
            // this sequence is longer than any others that have been found so far
            lenMax = len;
            pMax = (p - 1) & 0x0FFF;
          }
        }

        // check if the longest sequence is compressible
        if (lenMax >= 3) {
          // sequence is compressible - update header byte and add compressed data to line buffer
          header |= mask;
          w = ((lenMax - 3) << 12) | pMax;
          line[l++] = w >> 8;
          line[l++] = w & 0xFF;
          s += lenMax;
        } else {
          // sequence is not compressible - add byte to line buffer
          line[l++] = data.src[s++];
        }

        mask >>= 1;

        if (!mask) {
          // finished a line, copy it to the destination
          line[0] = header;

          data.dest.set(line.subarray(0, l), d);
          d += l;
          header = 0;
          l = 1;
          mask = 0x80;
        }
      }

      if (mask !== 0x80) {
        // we're done with all the data but we're still in the middle of a line
        line[0] = header;
        data.dest.set(line.subarray(0, l), d);
        d += l;
      }

      // trim the buffers
      data.dest = data.dest.slice(0, d);
      data.src = data.src.slice(0, s);
    },
    decode: function(data) {
      var s = 0; // source pointer
      data.dest = new Uint8Array(0x10000);
      var d = 0; // destination pointer
      var buffer = new Uint8Array(0x1000);
      var b = 0;
      var line = new Uint8Array(18);
      var header, pass, r, w, c, i, l;

      if (data.src[s++] !== 0x10) return [new Uint8Array(0), 0];

      var length = data.src[s++] | (data.src[s++] << 8) | (data.src[s++] << 16);
      while (d < length) {

        // read header
        header = data.src[s++];

        for (pass = 0; pass < 8; pass++, header <<= 1) {
          l = 0;
          if (header & 0x80) {
            // 2-bytes (compressed)
            w = (data.src[s++] << 8);
            w |= data.src[s++];
            r = (w >> 12) + 3;
            w &= 0x0FFF;
            w++;

            for (i = 0; i < r; i++) {
              c = buffer[(b - w) & 0x0FFF];
              line[l++] = c;
              buffer[b++] = c;
              b &= 0x0FFF;
            }
          } else {
            // single byte (uncompressed)
            c = data.src[s++];
            line[l++] = c;
            buffer[b++] = c;
            b &= 0x0FFF;
          }
          if ((d + l) > data.dest.length) {
            // maximum buffer length exceeded
            data.dest.set(line.subarray(0, dest.length - d), d)
            return;
          } else {
            // copy this pass to the destination buffer
            data.dest.set(line.subarray(0, l), d)
            d += l;
          }
          
          // reached end of compressed data
          if (d >= length) break;
        }
      }

      // trim the buffers
      data.src = data.src.slice(0, s);
      data.dest = data.dest.slice(0, d);
    }
  },
  "apultra": {
    encode: function(data, winSize) {
      winSize = winSize || 0x10000;
      data.dest = apultra_pack(data.src);
    },
    decode: function(data) {
      data.dest = apultra_unpack(data.src);
    }
  }
}

module.exports = ROMDataCodec;
