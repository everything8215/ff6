
const isNumber = require('is-number');

function hexString(num, pad, prefix) {
  if (prefix === undefined) prefix = '0x';
  if (num < 0) num = 0xFFFFFFFF + num + 1;
  let hex = num.toString(16).toUpperCase();
  if (isNumber(pad)) {
    hex = hex.padStart(pad, '0');
  } else if (num < 0x0100) {
    hex = hex.padStart(2, '0');
  } else if (num < 0x010000) {
    hex = hex.padStart(4, '0');
  } else if (num < 0x01000000) {
    hex = hex.padStart(6, '0');
  } else {
    hex = hex.padStart(8, '0');
  }
  return (prefix + hex);
}

module.exports = hexString;
