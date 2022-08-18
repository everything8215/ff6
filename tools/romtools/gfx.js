//
// gfx.js
// created 1/7/2018
//

let GFX = {

  makeLong: function(a,b) { return ((a & 0xFFFF) | ((b & 0xFFFF) << 16)); },
  makeWord: function(a,b) { return ((a & 0xFF) | ((b & 0xFF) << 8)); },
  makeByte: function(a,b) { return ((a & 0x0F) | ((b & 0x0F) << 4)); },
  hiWord: function(a) { return ((a >> 16) & 0xFFFF); },
  loWord: function(a) { return (a & 0xFFFF); },
  hiByte: function(a) { return ((a >> 8) & 0xFF); },
  loByte: function(a) { return (a & 0xFF); },
  hiNybble: function(a) { return ((a >> 4) & 0x0F); },
  loNybble: function(a) { return (a & 0x0F); },

  Z: {
    bottom: 0, // force to bottom
    snesBk: 0, // snes back area
    snes4L: 2, // snes layer 4, low priority
    snes3L: 3, // snes layer 3, low priority
    snesS0: 4, // snes sprites, priority 0
    snes4H: 6, // snes layer 4, high priority
    snes3H: 7, // snes layer 3, high priority
    snesS1: 8, // snes sprites, priority 1
    snes2L: 10, // snes layer 2, low priority
    snes1L: 11, // snes layer 1, low priority
    snesS2: 12, // snes sprites, priority 2
    snes2H: 14, // snes layer 2, high priority
    snes1H: 15, // snes layer 1, high priority
    snesS3: 16, // snes sprites, priority 3
    snes3P: 17, // snes layer 3, highest priority
    top: 100 // force to top
  },

  graphicsFormat: {
    linear8bpp: {
      key: "linear8bpp",
      name: "Linear 8bpp",
      colorDepth: 8,
      colorsPerPalette: 256,
      encode: function(data) {
        data.dest = new Uint8Array(data.src.buffer);
      },
      decode: function(data) {
        data.dest = new Uint8Array(data.src.buffer);
      }
    },
    linear4bpp: {
      key: "linear4bpp",
      name: "Linear 4bpp",
      colorDepth: 4,
      colorsPerPalette: 16,
      encode: function(data, reverse) {
        // 8-bit source, 8-bit destination
        data.dest = new Uint8Array(Math.ceil(data.src.length / 2));

        var s = 0;
        var d = 0;
        var a1, a2;

        if (reverse) {
          while (s < data.src.length) {
            a1 = data.src[s++] & 0x0F;
            a2 = (data.src[s++] || 0) & 0x0F;
            data.dest[d++] = GFX.makeByte(a2,a1);
          }
        } else {
          while (s < data.src.length) {
            a1 = data.src[s++] & 0x0F;
            a2 = (data.src[s++] || 0) & 0x0F;
            data.dest[d++] = GFX.makeByte(a1,a2);
          }
        }
      },
      decode: function(data, reverse) {
        // 8-bit source, 8-bit destination
        data.dest = new Uint8Array(data.src.length * 2);

        var s = 0;
        var d = 0;
        var c;

        if (reverse) {
          while (s < src.length) {
            c = data.src[s++];
            data.dest[d++] = GFX.hiNybble(c);
            data.dest[d++] = GFX.loNybble(c);
          }
        } else {
          while (s < data.src.length) {
            c = data.src[s++];
            data.dest[d++] = GFX.loNybble(c);
            data.dest[d++] = GFX.hiNybble(c);
          }
        }
      }
    },
    linear2bpp: {
      key: "linear2bpp",
      name: "Linear 2bpp",
      colorDepth: 2,
      colorsPerPalette: 4,
      encode: function(data, reverse) {
        // 8-bit source, 8-bit destination
        data.dest = new Uint8Array(Math.ceil(data.src.length / 4));

        var s = 0;
        var d = 0;
        var a1, a2, a3, a4;

        if (reverse) {
          while (s < data.src.length) {
            a1 = data.src[s++] & 0x03;
            a2 = (data.src[s++] || 0) & 0x03;
            a3 = (data.src[s++] || 0) & 0x03;
            a4 = (data.src[s++] || 0) & 0x03;
            data.dest[d++] = a4 | (a3 << 2) | (a2 << 4) | (a1 << 6);
          }
        } else {
          while (s < data.src.length) {
            a1 = data.src[s++] & 0x03;
            a2 = (data.src[s++] || 0) & 0x03;
            a3 = (data.src[s++] || 0) & 0x03;
            a4 = (data.src[s++] || 0) & 0x03;
            data.dest[d++] = a1 | (a2 << 2) | (a3 << 4) | (a4 << 6);
          }
        }
      },
      decode: function(data, reverse) {
        // 8-bit source, 8-bit destination
        data.dest = new Uint8Array(data.src.length * 4);

        var s = 0;
        var d = 0;
        var c;

        if (reverse) {
          while (s < data.src.length) {
            c = data.src[s++];
            data.dest[d++] = (c >> 6) & 0x03;
            data.dest[d++] = (c >> 4) & 0x03;
            data.dest[d++] = (c >> 2) & 0x03;
            data.dest[d++] = c & 0x03;
          }
        } else {
          while (s < data.src.length) {
            c = data.src[s++];
            data.dest[d++] = c & 0x03;
            data.dest[d++] = (c >> 2) & 0x03;
            data.dest[d++] = (c >> 4) & 0x03;
            data.dest[d++] = (c >> 6) & 0x03;
          }
        }
      }
    },
    linear1bpp: {
      key: "linear1bpp",
      name: "Linear 1bpp",
      colorDepth: 1,
      colorsPerPalette: 2,
      encode: function(data, reverse) {
        // 8-bit source, 8-bit destination
        data.dest = new Uint8Array(Math.ceil(data.src.length / 8));

        var s = 0;
        var d = 0;
        var a;

        if (reverse) {
          while (s < data.src.length) {
            a = (data.src[s++] & 1) << 7;
            a |= (data.src[s++] & 1) << 6;
            a |= (data.src[s++] & 1) << 5;
            a |= (data.src[s++] & 1) << 4;
            a |= (data.src[s++] & 1) << 3;
            a |= (data.src[s++] & 1) << 2;
            a |= (data.src[s++] & 1) << 1;
            a |= data.src[s++] & 1;
            data.dest[d++] = a;
          }
        } else {
          while (s < data.src.length) {
            a = data.src[s++] & 1;
            a |= (data.src[s++] & 1) << 1;
            a |= (data.src[s++] & 1) << 2;
            a |= (data.src[s++] & 1) << 3;
            a |= (data.src[s++] & 1) << 4;
            a |= (data.src[s++] & 1) << 5;
            a |= (data.src[s++] & 1) << 6;
            a |= (data.src[s++] & 1) << 7;
            data.dest[d++] = a;
          }
        }
      },
      decode: function(data, reverse) {
        // 8-bit source, 8-bit destination
        // var src = new Uint8Array(data.buffer, data.byteOffset, data.byteLength);
        data.dest = new Uint8Array(data.src.length * 8);

        var s = 0;
        var d = 0;
        var c;

        if (reverse) {
          while (s < data.src.length) {
            c = data.src[s++];
            data.dest[d++] = (c >> 7) & 1;
            data.dest[d++] = (c >> 6) & 1;
            data.dest[d++] = (c >> 5) & 1;
            data.dest[d++] = (c >> 4) & 1;
            data.dest[d++] = (c >> 3) & 1;
            data.dest[d++] = (c >> 2) & 1;
            data.dest[d++] = (c >> 1) & 1;
            data.dest[d++] = (c >> 0) & 1;
          }
        } else {
          while (s < data.src.length) {
            c = data.src[s++];
            data.dest[d++] = (c >> 0) & 1;
            data.dest[d++] = (c >> 1) & 1;
            data.dest[d++] = (c >> 2) & 1;
            data.dest[d++] = (c >> 3) & 1;
            data.dest[d++] = (c >> 4) & 1;
            data.dest[d++] = (c >> 5) & 1;
            data.dest[d++] = (c >> 6) & 1;
            data.dest[d++] = (c >> 7) & 1;
          }
        }
      }
    },
    nes2bpp: {
      key: "nes2bpp",
      name: "NES 2bpp",
      colorDepth: 2,
      colorsPerPalette: 4,
      encode: function(data) {
        // 8-bit source, 8-bit destination
        data.dest = new Uint8Array(Math.ceil(data.src.byteLength / 4));

        var s = 0;
        var d = 0;
        var c, r, bp;

        while (s < data.src.length) {
          for (r = 0; r < 8; r++) {
            bp = [0,0];
            for (b = 7; b >= 0; b--) {
              c = data.src[s++] || 0;
              bp[0] |= (c & 1) << b; c >>= 1;
              bp[1] |= (c & 1) << b;
            }
            data.dest[d + 8] = bp[1];
            data.dest[d++] = bp[0];
          }
          d += 8;
        }
      },
      decode: function(data) {
        // 8-bit source, 8-bit destination
        data.dest = new Uint8Array(data.src.byteLength * 4);

        var s = 0;
        var d = 0;
        var c, bp1, bp2, bp;

        while (s < data.src.length) {
          for (r = 0; r < 8; r++) {
            bp2 = data.src[s + 8] || 0;
            bp1 = data.src[s++] || 0;
            bp = GFX.makeWord(bp1, bp2);
            for (b = 0; b < 8; b++) {
              c = bp & 0x8080;
              c >>= 7;
              c |= (c >> 7);
              c &= 0x03;
              data.dest[d++] = c;
              bp <<= 1;
            }
          }
          s += 8;
        }
      }
    },
    snes4bpp: {
      key: "snes4bpp",
      name: "SNES 4bpp",
      colorDepth: 4,
      colorsPerPalette: 16,
      encode: function(data) {
        // 8-bit source, 8-bit destination
        data.dest = new Uint8Array(Math.ceil(data.src.length / 2));

        var s = 0;
        var d = 0;
        var c, r, bp;

        while (s < data.src.length) {
          for (r = 0; r < 8; r++) {
            bp = [0,0,0,0];
            for (b = 7; b >= 0; b--) {
              c = data.src[s++] || 0;
              bp[0] |= (c & 1) << b; c >>= 1;
              bp[1] |= (c & 1) << b; c >>= 1;
              bp[2] |= (c & 1) << b; c >>= 1;
              bp[3] |= (c & 1) << b;
            }
            data.dest[d] = bp[0];
            data.dest[d + 1] = bp[1];
            data.dest[d + 16] = bp[2];
            data.dest[d + 17] = bp[3];
            d += 2;
          }
          d += 16;
        }
      },
      decode: function(data) {
        // 16-bit source, 8-bit destination
        const src16 = new Uint16Array(data.src.buffer);
        data.dest = new Uint8Array(src16.length * 4);

        var s = 0;
        var d = 0;
        var bp12, bp34, bp, c, r, b;

        while (s < src16.length) {
          for (r = 0; r < 8; r++) {
            bp34 = src16[s + 8] || 0;
            bp12 = src16[s++] || 0;
            bp = GFX.makeLong(bp12, bp34);
            for (b = 0; b < 8; b++) {
              c = bp & 0x80808080;
              c >>= 7;
              c |= (c >> 7);
              c |= (c >> 14);
              c &= 0x0F;
              data.dest[d++] = c;
              bp <<= 1;
            }
          }
          s += 8;
        }
      }
    },
    snes3bpp: {
      key: "snes3bpp",
      name: "SNES 3bpp",
      colorDepth: 3,
      colorsPerPalette: 8,
      encode: function(data) {
        // 8-bit source, 8-bit destination
        data.dest = new Uint8Array(Math.ceil(data.src.length / 64) * 24);

        var s = 0;
        var d = 0;
        var c, r, bp, d1;

        while (s < data.src.length) {
          d1 = d + 16;
          for (r = 0; r < 8; r++) {
            bp = [0,0,0];
            for (b = 7; b >= 0; b--) {
              c = data.src[s++] || 0;
              bp[0] |= (c & 1) << b; c >>= 1;
              bp[1] |= (c & 1) << b; c >>= 1;
              bp[2] |= (c & 1) << b;
            }
            data.dest[d] = bp[0];
            data.dest[d + 1] = bp[1];
            d += 2;
            data.dest[d1++] = bp[2];
          }
          d += 8;
        }
      },
      decode: function(data) {
        // 16-bit/8-bit source, 8-bit destination
        const src16 = new Uint16Array(data.src.buffer);
        data.dest = new Uint8Array(Math.ceil(src16.length / 12) * 64);

        var s16 = 0;
        var s8 = 16;
        var d = 0;
        var bp12, bp3, bp, c, r, b;

        while (s16 < src16.length) {
          for (r = 0; r < 8; r++) {
            bp12 = src16[s16++] || 0;
            bp3 = data.src[s8++] || 0;
            bp = GFX.makeLong(bp12, bp3);
            for (b = 0; b < 8; b++) {
              c = bp & 0x808080;
              c >>= 7;
              c |= (c >> 7);
              c |= (c >> 14);
              c &= 0x07;
              data.dest[d++] = c;
              bp <<= 1;
            }
          }
          s16 += 4;
          s8 += 16;
        }
      }
    },
    snes2bpp: {
      key: "snes2bpp",
      name: "SNES 2bpp",
      colorDepth: 2,
      colorsPerPalette: 4,
      encode: function(data) {
        // 8-bit source, 8-bit destination
        data.dest = new Uint8Array(Math.ceil(data.src.length / 4));

        var s = 0;
        var d = 0;
        var c, r, bp;

        while (s < data.src.length) {
          for (r = 0; r < 8; r++) {
            bp = [0,0];
            for (b = 7; b >= 0; b--) {
              c = data.src[s++] || 0;
              bp[0] |= (c & 1) << b; c >>= 1;
              bp[1] |= (c & 1) << b;
            }
            data.dest[d++] = bp[0];
            data.dest[d++] = bp[1];
          }
        }
      },
      decode: function(data) {
        // 16-bit source, 8-bit destination
        const src16 = new Uint16Array(data.src.buffer);
        data.dest = new Uint8Array(src16.length * 8);

        var s = 0;
        var d = 0;
        var bp, c, r, b;

        while (s < src16.length) {
          for (r = 0; r < 8; r++) {
            bp = src16[s++];
            for (b = 0; b < 8; b++) {
              c = bp & 0x8080;
              c >>= 7;
              c |= (c >> 7);
              c &= 0x03;
              data.dest[d++] = c;
              bp <<= 1;
            }
          }
        }
      }
    }
  },

  // for 5-bit to 8-bit color conversion (gamma corrected)
  gammaColorsSNES: [
    0x00, 0x01, 0x03, 0x06, 0x0a, 0x0f, 0x15, 0x1c,
    0x24, 0x2d, 0x37, 0x42, 0x4e, 0x5b, 0x69, 0x78,
    0x88, 0x90, 0x98, 0xa0, 0xa8, 0xb0, 0xb8, 0xc0,
    0xc8, 0xd0, 0xd8, 0xe0, 0xe8, 0xf0, 0xf8, 0xff,
  ],

  // for 5-bit to 8-bit color conversion (linear)
  colors31: [
    0,   8,   16,  25,  33,  41,  49,  58,
    66,  74,  82,  90,  99,  107, 115, 123,
    132, 140, 148, 156, 165, 173, 181, 189,
    197, 206, 214, 222, 230, 239, 247, 255
  ],

  // for 4-bit to 8-bit color conversion
  colors15: [
    0,   17,  34,  51,  68,  85,  102, 119,
    136, 153, 170, 187, 204, 221, 238, 255
  ],

  // from blargg's full palette demo
  colorsNES: [
    [ 84,  84,  84], [  0,  30, 116], [  8,  16, 144], [ 48,   0, 136],
    [ 68,   0, 100], [ 92,   0,  48], [ 84,   4,   0], [ 60,  24,   0],
    [ 32,  42,   0], [  8,  58,   0], [  0,  64,   0], [  0,  60,   0],
    [  0,  50,  60], [  0,   0,   0], [  0,   0,   0], [  0,   0,   0],

    [152, 150, 152], [  8,  76, 196], [ 48,  50, 236], [ 92,  30, 228],
    [136,  20, 176], [160,  20, 100], [152,  34,  32], [120,  60,   0],
    [ 84,  90,   0], [ 40, 114,   0], [  8, 124,   0], [  0, 118,  40],
    [  0, 102, 120], [  0,   0,   0], [  0,   0,   0], [  0,   0,   0],

    [236, 238, 236], [ 76, 154, 236], [120, 124, 236], [176,  98, 236],
    [228,  84, 236], [236,  88, 180], [236, 106, 100], [212, 136,  32],
    [160, 170,   0], [116, 196,   0], [ 76, 208,  32], [ 56, 204, 108],
    [ 56, 180, 204], [ 60,  60,  60], [  0,   0,   0], [  0,   0,   0],

    [236, 238, 236], [168, 204, 236], [188, 188, 236], [212, 178, 236],
    [236, 174, 236], [236, 174, 212], [236, 180, 176], [228, 196, 144],
    [204, 210, 120], [180, 222, 120], [168, 226, 144], [152, 226, 180],
    [160, 214, 228], [160, 162, 160], [  0,   0,   0], [  0,   0,   0]
  ],

  vgaPalette: new Uint32Array([
    0xFF000000, 0xFF800000, 0xFF008000, 0xFF808000,
    0xFF000080, 0xFF800080, 0xFF008080, 0xFFC0C0C0,
    0xFF808080, 0xFFFF0000, 0xFF00FF00, 0xFFFFFF00,
    0xFF0000FF, 0xFFFF00FF, 0xFF00FFFF, 0xFFFFFFFF
  ]),

  paletteFormat: {
    bgr555: {
      key: "bgr555",
      name: "BGR555",
      encode: function(data) {
        // 32-bit source, 16-bit destination
        const src32 = new Uint32Array(data.src.buffer, data.src.byteOffset, data.src.length >> 2);
        const dest16 = new Uint16Array(src32.length);

        var s = 0;
        var d = 0;
        var r, g, b, rgb;

        while (s < src32.length) {
          rgb = src32[s++];
          b = (rgb & 0x00FF0000) >> 16; b = Math.round(b * 31 / 255);
          g = (rgb & 0x0000FF00) >> 8; g = Math.round(g * 31 / 255);
          r = (rgb & 0x000000FF); r = Math.round(r * 31 / 255);
          dest16[d++] = (b << 10) | (g << 5) | r;
        }
        data.dest = new Uint8Array(dest16.buffer);
      },
      decode: function(data) {
        // 16-bit source, 8-bit destination
        const src16 = new Uint16Array(data.src.buffer);
        const dest8 = new Uint8Array(src16.length * 4);

        var s = 0;
        var d = 0;
        var bgr555;

        while (s < data.src.length) {
          bgr555 = src16[s++];
          dest8[d++] = GFX.colors31[bgr555 & 0x1F]; bgr555 >>= 5;
          dest8[d++] = GFX.colors31[bgr555 & 0x1F]; bgr555 >>= 5;
          dest8[d++] = GFX.colors31[bgr555 & 0x1F];
          dest8[d++] = 0xFF;
        }
        data.dest = dest8;
      }
    },
    nesPalette: {
      key: "nesPalette",
      name: "NES Palette",
      encode: function(data) {
        // 32-bit source, 8-bit destination
        const src8 = new Uint8Array(data.src.buffer);
        data.dest = new Uint8Array(data.src.length);

        var s = 0;
        var d = 0;
        var c, r, g, b, color, diff;
        var bestColor, bestDiff;

        while (s < src8.length) {
          r = src8[s++];
          g = src8[s++];
          b = src8[s++];
          s++;

          // find the closest color in the NES palette
          bestColor = 0x0F;

          // euclidean difference
          bestDiff = b * b + g * g + r * r;

          for (c = 0; c < GFX.colorsNES.length; c++) {
            if (bestDiff === 0) break;
            color = GFX.colorsNES[c];
            diff = 0;

            // euclidean difference
            diff += (r - color[0]) * (r - color[0]);
            diff += (g - color[1]) * (g - color[1]);
            diff += (b - color[2]) * (b - color[2]);

            if (diff < bestDiff) {
              bestColor = c;
              bestDiff = diff;
            }
          }
          data.dest[d++] = bestColor;
        }
      },
      decode: function(data) {
        // 8-bit source, 32-bit destination
        const dest8 = new Uint8Array(data.src.length * 4);

        var s = 0;
        var d = 0;
        var c;

        while (s < data.src.length) {
          c = data.src[s++] & 0x3F;
          dest8[d++] |= GFX.colorsNES[c][0];
          dest8[d++] |= GFX.colorsNES[c][1];
          dest8[d++] |= GFX.colorsNES[c][2];
          dest8[d++] |= 0xFF;
        }
        data.dest = new Uint32Array(dest8.buffer);
      }
    },
    rgb444: {
      key: "rgb444",
      name: "RGB444",
      encode: function(data) {
        // 32-bit source, 16-bit destination
        data.dest = new Uint16Array(data.src.length);

        var s = 0;
        var d = 0;
        var r, g, b, rgb;

        while (s < data.src.length) {
          rgb = data.src[s++];
          b = (rgb & 0x00FF0000) >> 16; b = Math.round(b * 15 / 255);
          g = (rgb & 0x0000FF00) >> 8; g = Math.round(g * 15 / 255);
          r = (rgb & 0x000000FF); r = Math.round(r * 15 / 255);
          data.dest[d++] = (r << 8) | (g << 4) | b;
        }
      },
      decode: function(data) {
        // 16-bit source, 32-bit destination
        const src16 = new Uint16Array(data.src.buffer);
        const dest8 = new Uint8Array(src16.length * 4);

        var s = 0;
        var d = 0;
        var rgb444, r, g, b;

        while (s < src16.length) {
          rgb444 = src16[s++];
          b = GFX.colors15[rgb444 & 0x0F]; rgb444 >>= 4;
          g = GFX.colors15[rgb444 & 0x0F]; rgb444 >>= 4;
          r = GFX.colors15[rgb444 & 0x0F];
          dest[d++] = r;
          dest[d++] = g;
          dest[d++] = b;
          dest[d++] = 0xFF;
        }
        data.dest = new Uint32Array(dest16.buffer);
      }
    },
    rgb888: {
      key: "rgb888",
      name: "RGB888",
      encode: function(data) {
        data.dest = new Uint32Array(data.src.buffer);
      },
      decode: function(data) {
        data.dest = new Uint32Array(data.src.buffer);
      }
    }
  },

  makeGrayPalette: function(n, invert) {
    var pal = new Uint32Array(n);
    for (var i = 0; i < n; i++) {
      var c = Math.round((invert ? (n - i - 1) : i) / (n - 1) * 255);
      pal[i] = c | (c << 8) | (c << 16) | 0xFF000000;
    }
    return pal;
  },

  gammaCorrectedPaletteSNES: function(data) {
    // 8-bit source, 8 bit destination
    var src = new Uint8Array(data.buffer, data.byteOffset, data.byteLength);
    var dest = new Uint8Array(src.length);

    var s = 0;
    var d = 0;
    var r, g, b, a;

    while (s < src.length) {
      b = src[s++]; b = Math.round(b * 31 / 255);
      g = src[s++]; g = Math.round(g * 31 / 255);
      r = src[s++]; r = Math.round(r * 31 / 255);
      a = src[s++];

      dest[d++] = GFX.gammaColorsSNES[b];
      dest[d++] = GFX.gammaColorsSNES[g];
      dest[d++] = GFX.gammaColorsSNES[r];
      dest[d++] = 0xFF;
    }
    return new Uint32Array(dest.buffer);
  },

  gammaCorrectedPaletteGBA: function(data) {
    // 8-bit source, 8 bit destination
    var src = new Uint8Array(data.buffer, data.byteOffset, data.byteLength);
    var dest = new Uint8Array(src.length);

    var s = 0;
    var d = 0;
    var r, g, b, a, r1, g1, b1;

    while (s < src.length) {
      b = src[s++]; b = Math.round(b * 31 / 255);
      g = src[s++]; g = Math.round(g * 31 / 255);
      r = src[s++]; r = Math.round(r * 31 / 255);
      a = src[s++];

      b1 = Math.pow(b / 31, 4.0);
      g1 = Math.pow(g / 31, 4.0);
      r1 = Math.pow(r / 31, 4.0);

      b = Math.pow((220 * b1 +  10 * g1 +  50 * r1) / 255, 1 / 2.2) * (0xFF * 255 / 280);
      g = Math.pow(( 30 * b1 + 230 * g1 +  10 * r1) / 255, 1 / 2.2) * (0xFF * 255 / 280);
      r = Math.pow((  0 * b1 +  50 * g1 + 255 * r1) / 255, 1 / 2.2) * (0xFF * 255 / 280);

      dest[d++] = b;
      dest[d++] = g;
      dest[d++] = r;
      dest[d++] = 0xFF;
    }
    return new Uint32Array(dest.buffer);
  },

  tileFormat: {
    defaultTile: {
      // --vhzzzz pppppppp tttttttt tttttttt
      key: "defaultTile",
      name: "Default Tile",
      maxTiles: 65536,
      colorsPerPalette: 256,
      maxZ: 16,
      hFlip: true,
      vFlip: true,
      encode: function(data) {
        data.dest = new Uint8Array(data.src);
      },
      decode: function(data) {
        data.dest = new Uint8Array(data.src);
      }
    },
    generic8bppTile: {
      //                            tttttttt
      // -------- -------- -------- tttttttt
      key: "generic4bppTile",
      name: "Generic 4bpp Tile",
      maxTiles: 256,
      colorsPerPalette: 256,
      maxZ: 0,
      hFlip: false,
      vFlip: false,
      encode: function(data) {
        // 32-bit source, 8-bit destination
        const src32 = new Uint32Array(data.src.buffer);
        data.dest = new Uint8Array(src32.length);

        var s = 0;
        var d = 0;
        var t, tile;

        while (s < src32.length) {
          t = src32[s++];
          tile = t & 0x000000FF;
          data.dest[d++] = tile;
        }
      },
      decode: function(data) {
        // 8-bit source, 32-bit destination
        // data.src = new Uint8Array(data.src.buffer);
        data.dest = new Uint32Array(data.src.length);

        var s = 0;
        var d = 0;
        var t, tile;

        while (s < data.src.length) {
          t = data.src[s++];
          tile = t & 0x00FF;
          data.dest[d++] = tile;
        }
        data.dest = new Uint8Array(data.dest.buffer);
      }
    },
    generic4bppTile: {
      //                            tttttttt
      // -------- -------- -------- tttttttt
      key: "generic4bppTile",
      name: "Generic 4bpp Tile",
      maxTiles: 256,
      colorsPerPalette: 16,
      maxZ: 0,
      hFlip: false,
      vFlip: false,
      encode: function(data) {
        // 32-bit source, 8-bit destination
        const src32 = new Uint32Array(data.src.buffer);
        data.dest = new Uint8Array(src32.length);

        var s = 0;
        var d = 0;
        var t, tile;

        while (s < src32.length) {
          t = src32[s++];
          tile = t & 0x000000FF;
          data.dest[d++] = tile;
        }
        data.dest = new Uint8Array(data.dest.buffer);
      },
      decode: function(data) {
        // 8-bit source, 32-bit destination
        // var src = new Uint8Array(data.buffer, data.byteOffset, data.byteLength);
        data.dest = new Uint32Array(data.src.length);

        var s = 0;
        var d = 0;
        var t, tile;

        while (s < data.src.length) {
          t = data.src[s++];
          tile = t & 0x00FF;
          data.dest[d++] = tile;
        }
        data.dest = new Uint8Array(data.dest.buffer);
      }
    },
    generic2bppTile: {
      //                            tttttttt
      // -------- -------- -------- tttttttt
      key: "generic2bppTile",
      name: "Generic 2bpp Tile",
      maxTiles: 256,
      colorsPerPalette: 4,
      maxZ: 0,
      hFlip: false,
      vFlip: false,
      encode: function(data) {
        // 32-bit source, 8-bit destination
        const src32 = new Uint32Array(data.src.buffer);
        data.dest = new Uint8Array(src32.length);

        var s = 0;
        var d = 0;
        var t, tile;

        while (s < src32.length) {
          t = src32[s++];
          tile = t & 0x000000FF;
          data.dest[d++] = tile;
        }
        data.dest = new Uint8Array(data.dest.buffer);
      },
      decode: function(data) {
        // 8-bit source, 32-bit destination
        // var src = new Uint8Array(data.buffer, data.byteOffset, data.byteLength);
        data.dest = new Uint32Array(data.src.length);

        var s = 0;
        var d = 0;
        var t, tile;

        while (s < data.src.length) {
          t = data.src[s++];
          tile = t & 0x00FF;
          data.dest[d++] = tile;
        }
        data.dest = new Uint8Array(data.dest.buffer);
      }
    },
    gba8bppTile: {
      //                   zpppvhtt tttttttt
      // --vh---z ppp----- ------tt tttttttt
      key: "gba8bppTile",
      name: "GBA 8bpp Tile",
      maxTiles: 1024,
      colorsPerPalette: 256,
      maxZ: 2,
      hFlip: true,
      vFlip: true,
      encode: function(data) {
        // 32-bit source, 16-bit destination
        const src32 = new Uint32Array(data.src.buffer);
        const dest16 = new Uint16Array(src32.length);

        var s = 0;
        var d = 0;
        var t, tile;

        while (s < src32.length) {
          t = src32[s++];
          tile = t & 0x000003FF;
          tile |= (t & 0x00E00000) >> 9;
          tile |= (t & 0x01000000) >> 9;
          tile |= (t & 0x30000000) >> 18;
          dest16[d++] = tile;
        }
        data.dest = new Uint8Array(dest16.buffer);
      },
      decode: function(data) {
        // 16-bit source, 32-bit destination
        const src16 = new Uint16Array(data.src.buffer);
        // var src = new Uint16Array(data.buffer, data.byteOffset, data.byteLength >> 1);
        data.dest = new Uint32Array(src16.length);

        var s = 0;
        var d = 0;
        var t, tile;

        while (s < src16.length) {
          t = src16[s++];
          tile = t & 0x03FF;
          tile |= (t & 0x7000) << 9;
          tile |= (t & 0x8000) << 9;
          tile |= (t & 0x0C00) << 18;
          data.dest[d++] = tile;
        }
        data.dest = new Uint8Array(data.dest.buffer);
      }
    },
    gba4bppTile: {
      //                   zpppvhtt tttttttt
      // --vh---z -ppp---- ------tt tttttttt
      key: "gba4bppTile",
      name: "GBA 4bpp Tile",
      maxTiles: 1024,
      colorsPerPalette: 16,
      maxZ: 2,
      hFlip: true,
      vFlip: true,
      encode: function(data) {
        // 32-bit source, 16-bit destination
        const src32 = new Uint32Array(data.src.buffer);
        const dest16 = new Uint16Array(src32.length);

        var s = 0;
        var d = 0;
        var t, tile;

        while (s < src32.length) {
          t = src32[s++];
          tile = t & 0x000003FF;
          tile |= (t & 0x00700000) >> 8;
          tile |= (t & 0x01000000) >> 9;
          tile |= (t & 0x30000000) >> 18;
          dest16[d++] = tile;
        }
        data.dest = new Uint8Array(dest16.buffer);
      },
      decode: function(data) {
        // 16-bit source, 32-bit destination
        const src16 = new Uint16Array(data.src.buffer);
        data.dest = new Uint32Array(src16.length);

        var s = 0;
        var d = 0;
        var t, tile;

        while (s < src16.length) {
          t = src16[s++];
          tile = t & 0x03FF;
          tile |= (t & 0x7000) << 8;
          tile |= (t & 0x8000) << 9;
          tile |= (t & 0x0C00) << 18;
          data.dest[d++] = tile;
        }
        data.dest = new Uint8Array(data.dest.buffer);
      }
    },
    gba2bppTile: {
      //                   zpppvhtt tttttttt
      // --vh---z ---ppp-- ------tt tttttttt
      key: "gba2bppTile",
      name: "GBA 2bpp Tile",
      maxTiles: 1024,
      colorsPerPalette: 4,
      maxZ: 2,
      hFlip: true,
      vFlip: true,
      encode: function(data) {
        // 32-bit source, 16-bit destination
        const src32 = new Uint32Array(data.src.buffer);
        const dest16 = new Uint16Array(src32.length);

        var s = 0;
        var d = 0;
        var t, tile;

        while (s < src32.length) {
          t = src32[s++];
          tile = t & 0x000003FF;
          tile |= (t & 0x001C0000) >> 6;
          tile |= (t & 0x01000000) >> 9;
          tile |= (t & 0x30000000) >> 18;
          data.dest[d++] = tile;
        }
        data.dest = new Uint8Array(data.dest.buffer);
      },
      decode: function(data) {
        // 16-bit source, 32-bit destination
        const src16 = new Uint16Array(data.buffer);
        // var src = new Uint16Array(data.buffer, data.byteOffset, data.byteLength >> 1);
        data.dest = new Uint32Array(src16.length);

        var s = 0;
        var d = 0;
        var t, tile;

        while (s < src16.length) {
          t = src16[s++];
          tile = t & 0x03FF;
          tile |= (t & 0x7000) << 6;
          tile |= (t & 0x8000) << 9;
          tile |= (t & 0x0C00) << 18;
          data.dest[d++] = tile;
        }
        data.dest = new Uint8Array(data.dest.buffer);
      }
    },
    nesNameTable: {
      //                            tttttttt
      // -------- ----pp-- -------- tttttttt
      // (palette from attribute table)
      key: "nesNameTable",
      name: "NES Name Table",
      maxTiles: 256,
      colorsPerPalette: 4,
      maxZ: 0,
      hFlip: false,
      vFlip: false,
      encode: function(data) {
        // 32-bit source (960 tiles)
        // 8-bit destination (1024 bytes)
        var srcLength = Math.min(data.byteLength >> 2, 960);
        var src32 = new Uint32Array(data.buffer, data.byteOffset, srcLength);
        var src = new Uint32Array(960);
        src.set(src32.subarray(0, srcLength));
        var dest = new Uint8Array(1024);

        var s = 0;
        var d = 0;
        var t, tile;

        // encode tile index (name table)
        while (s < src.length) {
          dest[d++] = src[s++] & 0xFF;
        }

        // encode palette index (attribute table)
        var n = 0;
        var attr;
        while (n < 64) {
          s = (n & 0x07) * 4 + (n >> 3) * 128;
          // use the top left 8x8 subtile of each 16x16 tile
          attr = (src[s] & 0x000C0000) >> 18;
          attr |= (src[s+2] & 0x000C0000) >> 16;
          if (n < 56) {
            attr |= (src[s+64] & 0x000C0000) >> 14;
            attr |= (src[s+66] & 0x000C0000) >> 12;
          }
          dest[960 + n++] = attr;
        }

        return [dest, src.byteLength];
      },
      decode: function(data) {
        // 8-bit source (1024 bytes)
        // 32-bit destination (960 tiles)
        var srcLength = Math.min(data.byteLength, 1024);
        var src8 = new Uint8Array(data.buffer, data.byteOffset, srcLength);
        var src = new Uint32Array(1024);
        src.set(src8.subarray(0, srcLength));
        var dest = new Uint32Array(960);

        var s = 0;
        var d = 0;
        var t, tile;

        // decode tile index (name table)
        while (s < 960) {
          dest[d++] = src[s++];
        }

        // decode palette index (attribute table)
        var attr, p, n;
        while (s < 1024) {
          n = s - 960;
          attr = src[s++];
          d = (n & 0x07) * 4 + (n >> 3) * 128;

          p = (attr & 3) << 18; attr >>= 2;
          dest[d] |= p;
          dest[d+1] |= p;
          dest[d+32] |= p;
          dest[d+33] |= p;

          p = (attr & 3) << 18; attr >>= 2;
          dest[d+2] |= p;
          dest[d+3] |= p;
          dest[d+34] |= p;
          dest[d+35] |= p;

          d += 64;

          p = (attr & 3) << 18; attr >>= 2;
          dest[d] |= p;
          dest[d+1] |= p;
          dest[d+32] |= p;
          dest[d+33] |= p;

          p = (attr & 3) << 18;
          dest[d+2] |= p;
          dest[d+3] |= p;
          dest[d+34] |= p;
          dest[d+35] |= p;
        }
        return [dest, src.byteLength];
      }
    },
    snes4bppTile: {
      //                   vhzppptt tttttttt
      // --vh---z -ppp---- ------tt tttttttt
      key: "snes4bppTile",
      name: "SNES 4bpp Tile",
      maxTiles: 1024,
      colorsPerPalette: 16,
      maxZ: 2,
      hFlip: true,
      vFlip: true,
      encode: function(data) {
        // 32-bit source, 16-bit destination
        const src32 = new Uint32Array(data.src.buffer);
        const dest16 = new Uint16Array(src32.length);

        var s = 0;
        var d = 0;
        var t, tile;

        while (s < src32.length) {
          t = src32[s++];
          tile = t & 0x000003FF;
          tile |= (t & 0x00700000) >> 10;
          tile |= (t & 0x01000000) >> 11;
          tile |= (t & 0x30000000) >> 14;
          dest16[d++] = tile;
        }
        data.dest = new Uint8Array(dest16.buffer);
      },
      decode: function(data) {
        // 16-bit source, 32-bit destination
        const src16 = new Uint16Array(data.src.buffer);
        data.dest = new Uint32Array(src16.length);

        var s = 0;
        var d = 0;
        var t, tile;

        while (s < src16.length) {
          t = src16[s++];
          tile = t & 0x03FF;
          tile |= (t & 0x1C00) << 10;
          tile |= (t & 0x2000) << 11;
          tile |= (t & 0xC000) << 14;
          data.dest[d++] = tile;
        }
        data.dest = new Uint8Array(data.dest.buffer);
      }
    },
    snes3bppTile: {
      //                   vhzppptt tttttttt
      // --vh---z --ppp--- ------tt tttttttt
      key: "snes3bppTile",
      name: "SNES 3bpp Tile",
      maxTiles: 1024,
      colorsPerPalette: 8,
      maxZ: 2,
      hFlip: true,
      vFlip: true,
      encode: function(data) {
        // 32-bit source, 16-bit destination
        const src32 = new Uint32Array(data.src.buffer);
        const dest16 = new Uint16Array(src32.length);

        var s = 0;
        var d = 0;
        var t, tile;

        while (s < src32.length) {
          t = src32[s++];
          tile = t & 0x000003FF;
          tile |= (t & 0x00380000) >> 9;
          tile |= (t & 0x01000000) >> 11;
          tile |= (t & 0x30000000) >> 14;
          dest16[d++] = tile;
        }
        data.dest = new Uint8Array(dest16.buffer);
      },
      decode: function(data) {
        // 16-bit source, 32-bit destination
        const src16 = new Uint16Array(data.src.buffer);
        data.dest = new Uint32Array(src16.length);

        var s = 0;
        var d = 0;
        var t, tile;

        while (s < src16.length) {
          t = src16[s++];
          tile = t & 0x03FF;
          tile |= (t & 0x1C00) << 9;
          tile |= (t & 0x2000) << 11;
          tile |= (t & 0xC000) << 14;
          data.dest[d++] = tile;
        }
        data.dest = new Uint8Array(data.dest.buffer);
      }
    },
    snes2bppTile: {
      //                   vhzppptt tttttttt
      // --vh---z ---ppp-- ------tt tttttttt
      key: "snes2bppTile",
      name: "SNES 2bpp Tile",
      maxTiles: 1024,
      colorsPerPalette: 4,
      maxZ: 2,
      hFlip: true,
      vFlip: true,
      encode: function(data) {
        // 32-bit source, 16-bit destination
        const src32 = new Uint32Array(data.src.buffer);
        const dest16 = new Uint16Array(src32.length);

        var s = 0;
        var d = 0;
        var t, tile;

        while (s < src32.length) {
          t = src32[s++];
          tile = t & 0x000003FF;
          tile |= (t & 0x001C0000) >> 8;
          tile |= (t & 0x01000000) >> 11;
          tile |= (t & 0x30000000) >> 14;
          dest16[d++] = tile;
        }
        data.dest = new Uint8Array(dest16.buffer);
      },
      decode: function(data) {
        // 16-bit source, 32-bit destination
        const src16 = new Uint16Array(data.src.buffer);
        data.dest = new Uint32Array(src16.length);

        var s = 0;
        var d = 0;
        var t, tile;

        while (s < src16.length) {
          t = src16[s++];
          tile = t & 0x03FF;
          tile |= (t & 0x1C00) << 8;
          tile |= (t & 0x2000) << 11;
          tile |= (t & 0xC000) << 14;
          data.dest[d++] = tile;
        }
        data.dest = new Uint8Array(data.dest.buffer);
      }
    },
    snesSpriteTile: {
      //                   vhzzpppt tttttttt
      // --vh--zz -ppp---- -------t tttttttt
      key: "snesSpriteTile",
      name: "SNES Sprite Tile",
      maxTiles: 512,
      colorsPerPalette: 16,
      maxZ: 4,
      hFlip: true,
      vFlip: true,
      encode: function(data) {
        // 32-bit source, 16-bit destination
        const src32 = new Uint32Array(data.src.buffer);
        const dest16 = new Uint16Array(src32.length);

        var s = 0;
        var d = 0;
        var t, tile;

        while (s < src32.length) {
          t = src32[s++];
          tile = t & 0x000001FF;
          tile |= (t & 0x00700000) >> 11;
          tile |= (t & 0x03000000) >> 12;
          tile |= (t & 0x30000000) >> 14;
          dest16[d++] = tile;
        }
        data.dest = new Uint8Array(dest16.buffer);
      },
      decode: function(data) {
        // 16-bit source, 32-bit destination
        const src16 = new Uint16Array(data.src.buffer);
        data.dest = new Uint32Array(src16.length);

        var s = 0;
        var d = 0;
        var t, tile;

        while (s < src16.length) {
          t = src16[s++];
          tile = t & 0x01FF;
          tile |= (t & 0x0E00) << 11;
          tile |= (t & 0x3000) << 12;
          tile |= (t & 0xC000) << 14;
          data.dest[d++] = tile;
        }
        data.dest = new Uint8Array(data.dest.buffer);
      }
    },
    x16_4bppTile: {
      //                   ppppvhtt tttttttt
      // --vh---- pppp---- ------tt tttttttt
      key: "x164bppTile",
      name: "X16 4bpp Tile",
      maxTiles: 1024,
      colorsPerPalette: 16,
      maxZ: 0,
      hFlip: true,
      vFlip: true,
      encode: function(data) {
        // 32-bit source, 16-bit destination
        const src32 = new Uint32Array(data.src.buffer);
        const dest16 = new Uint16Array(src32.length);

        var s = 0;
        var d = 0;
        var t, tile;

        while (s < src32.length) {
          t = src32[s++];
          tile = t & 0x000003FF;
          tile |= (t & 0x00F00000) >> 8;
          tile |= (t & 0x30000000) >> 18;
          dest16[d++] = tile;
        }
        data.dest = new Uint8Array(dest16.buffer);
      },
      decode: function(data) {
        // 16-bit source, 32-bit destination
        const src16 = new Uint16Array(data.buffer);
        data.dest = new Uint32Array(src16.length);

        var s = 0;
        var d = 0;
        var t, tile;

        while (s < src16.length) {
          t = src16[s++];
          tile = t & 0x03FF;
          tile |= (t & 0xF000) << 8;
          tile |= (t & 0x0C00) << 18;
          data.dest[d++] = tile;
        }
        data.dest = new Uint8Array(data.dest.buffer);
      }
    }
  },

  mathNone: function(c1) {
    return c1;
  },

  mathAdd: function(c1, c2) {
    var b1 = c1 & 0x000000FF;
    var g1 = c1 & 0x0000FF00;
    var r1 = c1 & 0x00FF0000;
    var b2 = c2 & 0x000000FF;
    var g2 = c2 & 0x0000FF00;
    var r2 = c2 & 0x00FF0000;
    var b = b1 + b2; if (b > 0x000000FF) b = 0x000000FF;
    var g = g1 + g2; if (g > 0x0000FF00) g = 0x0000FF00;
    var r = r1 + r2; if (r > 0x00FF0000) r = 0x00FF0000;
    var a = 0xFF000000;
    return b | g | r | a;
  },

  mathHalfAdd: function(c1, c2) {
    if (c2 == 0) {
      return c1;
    }
    var c = ((c1 & 0x00FEFEFE) + (c2 & 0x00FEFEFE)) >> 1;
    c += (c1 & c2 & 0x00010101);
    c += 0xFF000000;
    return c;
  },

  mathSub: function(c1, c2) {
    var c = 0;
    var b1 = c1 & 0x000000FF;
    var g1 = c1 & 0x0000FF00;
    var r1 = c1 & 0x00FF0000;
    var a1 = c1 & 0xFF000000;
    var b2 = c2 & 0x000000FF;
    var g2 = c2 & 0x0000FF00;
    var r2 = c2 & 0x00FF0000;
    if (r1 > r2) c += (r1 - r2);
    if (g1 > g2) c += (g1 - g2);
    if (b1 > b2) c += (b1 - b2);
    c += a1;
    return c;
  },

  mathHalfSub: function(c1, c2) {
    var b1 = c1 & 0x000000FF;
    var g1 = c1 & 0x0000FF00;
    var r1 = c1 & 0x00FF0000;
    var a1 = c1 & 0xFF000000;
    var b2 = (c2 & 0x000000FE) >> 1;
    var g2 = (c2 & 0x0000FE00) >> 1;
    var r2 = (c2 & 0x00FE0000) >> 1;
    var b = b1 - b2; if (b < 0x00000000) b = 0;
    var g = g1 - g2; if (g < 0x00000100) g = 0;
    var r = r1 - r2; if (r < 0x00010000) r = 0;
    var a = a1;
    return b | g | r | a;
  },

  render: function(dest, gfx, pal, ppl, backColor) {

    // 32-bit destination, 32-bit palette
    dest = new Uint32Array(dest.buffer, dest.byteOffset);
    pal = new Uint32Array(pal.buffer, pal.byteOffset, Math.ceil(pal.byteLength / 4));

    var g = 0;
    var d = 0;
    var x = 0;
    var y, c, p;

    backColor = backColor | 0;

    while (g < gfx.length) {
      y = d + x;
      for (var line = 0; line < 8; line++) {
        p = y;
        c = gfx[g++]; dest[p++] = c ? pal[c] : backColor;
        c = gfx[g++]; dest[p++] = c ? pal[c] : backColor;
        c = gfx[g++]; dest[p++] = c ? pal[c] : backColor;
        c = gfx[g++]; dest[p++] = c ? pal[c] : backColor;
        c = gfx[g++]; dest[p++] = c ? pal[c] : backColor;
        c = gfx[g++]; dest[p++] = c ? pal[c] : backColor;
        c = gfx[g++]; dest[p++] = c ? pal[c] : backColor;
        c = gfx[g++]; dest[p++] = c ? pal[c] : backColor;
        y += ppl;
      }
      x += 8;
      if (x >= ppl) {
        x = 0;
        d += 8 * ppl;
      }
    }
  },

  PPU: function() {
    var Layer = function() {
      this.format = 0;
      this.rows = 32;
      this.cols = 32;
      this.x = 0;
      this.y = 0;
      this.z = new Array(16).fill(0);
      this.gfx = null;
      this.tiles = null;
      this.attr = null;
      this.main = false;
      this.sub = false;
      this.math = false;
      this.tileWidth = 8;
      this.tileHeight = 8;
    }
    this.layers = [new Layer(), new Layer(), new Layer(), new Layer()];
    this.height = 0;
    this.width = 0;
    this.pal = null;
    this.subtract = false;
    this.half = false;
    this.back = false;
    this.flipped = false;

    this.createPNG = function(x, y, width, height) {

      // create a dummy palette with color indices
      var pal = this.pal;
      this.pal = new Uint32Array(256);
      for (var c = 0; c < 256; c++) this.pal[c] = c;

      // render the graphics to a Uint32Array
      var pixels32 = new Uint32Array(width * height);
      this.renderPPU(pixels32, x, y, width, height);

      // convert to an 8-bit array
      var pixels = new Uint8Array(pixels32);

      // restore the actual color palette
      this.pal = pal;

      return pzntg.create({
        width: width,
        height: height,
        pixels: pixels,
        palette: pal
      });
    }

    this.renderPPU = function(dest, x, y, width, height) {

      // declare this variable so i can access the ppu inside closures
      var ppu = this;

      x = x || 0;
      y = y || 0;
      width = width || ppu.width;
      height = height || ppu.height;

      // 32-bit destination, 32-bit palette
      dest = new Uint32Array(dest.buffer, dest.byteOffset);
      ppu.pal = new Uint32Array(ppu.pal.buffer, ppu.pal.byteOffset);

      // line buffers
      var main; // = new Uint32Array(width);
      var sub = new Uint32Array(width);
      var zBuffer = new Uint8Array(width);

      var d = 0; // destination buffer location
      var l; // layer index
      var layer;
      var bytesPerTile;

      var ly, lx; // layer position
      var tx, ty; // tile position
      var tw, th; // tile size
      var i, c, s, t, p, z, h, v, m; // tile parameters

      // color math as determined by ppu
      var math = GFX.mathNone;
      var ppuMath = GFX.mathNone;
      if (ppu.subtract) {
        ppuMath = ppu.half ? GFX.mathHalfSub : GFX.mathSub;
      } else {
        ppuMath = ppu.half ? GFX.mathHalfAdd : GFX.mathAdd;
      }

      // tile format based on layer
      var updateTile;

      // pixel rendering function
      var renderPixel;

      function renderPixelSub() {
        if (layer.z[z] > zBuffer[i]) {
          c = layer.gfx[t + ty + tx];
          if (c & m) {
            zBuffer[i] = layer.z[z];
            sub[i] = ppu.pal[p + c];
          }
        }
        ++i;
        ++lx;
      }

      function renderPixelMain() {
        if (layer.z[z] > zBuffer[i]) {
          c = layer.gfx[t + ty + tx];
          if (c & m) {
            zBuffer[i] = layer.z[z];
            s = sub[i];
            if (s) {
              main[i] = math(ppu.pal[p + c], s);
            } else {
              main[i] = ppu.pal[p + c];
            }
          }
        }
        ++i;
        ++lx;
      }

      // --vhzzzz pppppppp mmmmmmmm mmmmmmmm
      function updateTileGeneric() {
        var col = Math.floor(lx / tw) % layer.cols;
        var row = Math.floor(ly / th) % layer.rows;
        t = layer.tiles[col + row * layer.cols];
        p = (t & 0x00FF0000) >> 16; // palette
        z = (t & 0x0F000000) >> 24; // z-level
        h = (t & 0x10000000); // horizontal flip
        v = (t & 0x20000000); // vertical flip
        t = (t & 0x0000FFFF) * bytesPerTile; // tile index
        ty = (v ? (th - (ly % th) - 1) : (ly % th)) * tw;
        m = 255;
      }

      // mmmmmmmm
      function updateTileGBA8bpp() {
        var col = Math.floor(lx / tw) % layer.cols;
        var row = Math.floor(ly / th) % layer.rows;
        t = layer.tiles[col + row * layer.cols];
        p = 0; // palette
        z = 0; // z-level
        h = 0; // horizontal flip
        v = 0; // vertical flip
        t = (t & 0xFF) * bytesPerTile; // tile index
        ty = (v ? (th - (ly % th) - 1) : (ly % th)) * tw;
        m = 255;
      }

      // zpppvhmm mmmmmmmm
      function updateTileGBA4bpp() {
        var col = Math.floor(lx / tw) % layer.cols;
        var row = Math.floor(ly / th) % layer.rows;
        t = layer.tiles[col + row * layer.cols];
        p = (t & 0x7000) >> 8; // palette
        z = (t & 0x8000) >> 15; // z-level
        h = (t & 0x0400); // horizontal flip
        v = (t & 0x0800); // vertical flip
        t = (t & 0x03FF) * bytesPerTile; // tile index
        ty = (v ? (th - (ly % th) - 1) : (ly % th)) * tw;
        m = 15;
      }

      // zpppvhmm mmmmmmmm
      function updateTileGBA2bpp() {
        var col = Math.floor(lx / tw) % layer.cols;
        var row = Math.floor(ly / th) % layer.rows;
        t = layer.tiles[col + row * layer.cols];
        p = (t & 0x7000) >> 10; // palette
        z = (t & 0x8000) >> 15; // z-level
        h = (t & 0x0400); // horizontal flip
        v = (t & 0x0800); // vertical flip
        t = (t & 0x03FF) * bytesPerTile; // tile index
        ty = (v ? (th - (ly % th) - 1) : (ly % th)) * tw;
        m = 3;
      }

      // vhzpppmm mmmmmmmm
      function updateTileSNES4bpp() {
        var col = Math.floor(lx / tw) % layer.cols;
        var row = Math.floor(ly / th) % layer.rows;
        t = layer.tiles[col + row * layer.cols];
        p = (t & 0x1C00) >> 6; // palette
        z = (t & 0x2000) >> 13; // z-level
        h = (t & 0x4000); // horizontal flip
        v = (t & 0x8000); // vertical flip
        t = (t & 0x03FF) * bytesPerTile; // tile index
        ty = (v ? (th - (ly % th) - 1) : (ly % th)) * tw;
        m = 15;
      }

      // vhzpppmm mmmmmmmm
      function updateTileSNES2bpp() {
        var col = Math.floor(lx / tw) % layer.cols;
        var row = Math.floor(ly / th) % layer.rows;
        t = layer.tiles[col + row * layer.cols];
        p = (t & 0x1C00) >> 8; // palette
        z = (t & 0x2000) >> 13; // z-level
        h = (t & 0x4000); // horizontal flip
        v = (t & 0x8000); // vertical flip
        t = (t & 0x03FF) * bytesPerTile; // tile index
        ty = (v ? (th - (ly % th) - 1) : (ly % th)) * tw;
        m = 3;
      }

      // vhzzpppm mmmmmmmm
      function updateTileSNESSprite() {
        var col = Math.floor(lx / tw) % layer.cols;
        var row = Math.floor(ly / th) % layer.rows;
        t = layer.tiles[col + row * layer.cols];
        p = (t & 0x0E00) >> 5; // palette
        z = (t & 0x3000) >> 12; // z-level
        h = (t & 0x4000); // horizontal flip
        v = (t & 0x8000); // vertical flip
        t = (t & 0x01FF) * bytesPerTile; // tile index
        ty = (v ? (th - (ly % th) - 1) : (ly % th)) * tw;
        m = 15;
      }

      // mmmmmmmm (palette from attr table)
      function updateTileNESBG() {
        var col = Math.floor(lx / tw) % layer.cols;
        var row = Math.floor(ly / th) % layer.rows;
        var tt = col + row * layer.cols;
        t = layer.tiles[tt] * bytesPerTile; // tile index
        p = layer.attr[tt >> 2]; // palette index (from attribute table)
        p >>= (tt & 3); p &= 0x03; p <<= 2;
        z = 0;
        ty = (ly % th) * tw;
        m = 3;
      }

      function renderLayerLine() {

        tw = layer.tileWidth;
        th = layer.tileHeight;
        ly = y + layer.y; // y location in layer (ignoring flip)
        lx = x + layer.x; // x location in layer (ignoring flip)
        while (ly < 0) ly += 0x1000;
        while (lx < 0) lx += 0x1000;
        i = 0; // scanline x position

        // draw first tile
        updateTile();
        tx = (h ? (tw - lx - 1) : lx) % tw;
        while (h ? (tx >= 0) : (tx < tw)) {
          renderPixel();
          h ? --tx : ++tx;
        }

        // draw mid tiles
        while (i < width - tw) {
          updateTile();
          if (h) {
            tx = tw - 1;
            while (tx >= 0) {
              renderPixel();
              --tx;
            }
          } else {
            tx = 0;
            while (tx < tw) {
              renderPixel();
              ++tx;
            }
          }
        }

        // draw last tile
        updateTile();
        tx = h ? (tw - 1) : 0;
        while (i < width) {
          renderPixel();
          h ? --tx : ++tx;
        }
      }

      function renderLine() {

        zBuffer.fill(0);
        sub.fill(0);

        // render subscreen layers
        renderPixel = renderPixelSub;
        for (l = 0; l < 4; l++) {
          layer = ppu.layers[l];
          bytesPerTile = layer.tileWidth * layer.tileHeight;
          if (layer.sub) {
            switch (layer.format) {
              case GFX.TileFormat.gba2bppTile: updateTile = updateTileGBA2bpp; break;
              case GFX.TileFormat.gba4bppTile: updateTile = updateTileGBA4bpp; break;
              case GFX.TileFormat.gba8bppTile: updateTile = updateTileGBA8bpp; break;
              case GFX.TileFormat.snes2bppTile: updateTile = updateTileSNES2bpp; break;
              case GFX.TileFormat.snes4bppTile: updateTile = updateTileSNES4bpp; break;
              case GFX.TileFormat.snesSpriteTile: updateTile = updateTileSNESSprite; break;
              case GFX.TileFormat.nesBGTile: updateTile = updateTileNESBG; break;
              default: updateTile = updateTileGeneric; break;
            }
            renderLayerLine();
          }
        }

        // clear the z-level
        zBuffer.fill(0);

        // render main screen layers
        main = new Uint32Array(width);
        renderPixel = renderPixelMain;

        // render the back area
        if (ppu.back) {
          c = ppu.pal[0];
          main.fill(c);
        }

        for (l = 0; l < 4; l++) {
          layer = ppu.layers[l];
          bytesPerTile = layer.tileWidth * layer.tileHeight;
          if (layer.main) {
            switch (layer.format) {
              case GFX.TileFormat.gba2bppTile: updateTile = updateTileGBA2bpp; break;
              case GFX.TileFormat.gba4bppTile: updateTile = updateTileGBA4bpp; break;
              case GFX.TileFormat.gba8bppTile: updateTile = updateTileGBA8bpp; break;
              case GFX.TileFormat.snes2bppTile: updateTile = updateTileSNES2bpp; break;
              case GFX.TileFormat.snes4bppTile: updateTile = updateTileSNES4bpp; break;
              case GFX.TileFormat.snesSpriteTile: updateTile = updateTileSNESSprite; break;
              case GFX.TileFormat.nesBGTile: updateTile = updateTileNESBG; break;
              default: updateTile = updateTileGeneric; break;
            }
            math = layer.math ? ppuMath : GFX.mathNone;
            renderLayerLine();
          }
        }
      }

      // render each scanline
      var yf = y + height;

      while (y < yf) {
        renderLine();
        dest.set(main, d);
        d += width;
        if (d > dest.length) break;
        y++;
      }

      return;
    }
  }
}

GFX.TileFormat = {
  default: "default",
  gba8bppTile: "gba8bppTile",
  gba4bppTile: "gba4bppTile",
  gba2bppTile: "gba2bppTile",
  nesBGTile: "nesBGTile",
  nesSpriteTile: "nesSpriteTile",
  snes4bppTile: "snes4bppTile",
  snes3bppTile: "snes3bppTile",
  snes2bppTile: "snes2bppTile",
  snesSpriteTile: "snesSpriteTile",
}

module.exports = GFX;
