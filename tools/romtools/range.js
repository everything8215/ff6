
const hexString = require('./hex-string');
const isNumber = require('is-number');
const isString = require('is-string');

class ROMRange {

  constructor(begin, end) {

    // beginning of range (must be positive)
    this.begin = 0;
    // end of range (included in range)
    this.end = -1;

    if (isNumber(begin)) {
      // assume single value for now
      this.begin = begin;
      this.end = begin;
    } else if (isString(begin)) {
      const bounds = begin.split('-');
      if (bounds.length == 1) {
        // single value
        this.begin = Number(begin);
        if (!isNumber(this.begin)) {
          console.log(`Invalid range: ${begin}`);
          this.begin = 0;
        }
        this.end = this.begin;
      } else if (bounds.length == 2) {
        // multiple values
        this.begin = Number(bounds[0]);
        this.end = Number(bounds[1]);
        if (!isNumber(this.begin) || !isNumber(this.end)) {
          console.log(`Invalid range: ${begin}`);
          this.begin = 0;
          this.end = -1;
        }
      } else {
        console.log(`Invalid range: ${begin}`);
      }
    }

    // specified end value supercedes
    if (isNumber(end)) {
      this.end = end;
    } else if (isString(end)) {
      this.end = Number(end);
      if (!isNumber(this.end)) {
        console.log(`Invalid range: ${end}`);
        this.end = this.begin - 1;
      }
    }

    // validate range
    // if (this.begin < 0) {
    //   console.log(`Invalid range begin: ${this.begin}`);
    //   this.begin = 0;
    // }
    // if (this.end < this.begin) {
    //   console.log(`Invalid range: ${this.begin}-${this.end}`);
    //   this.end = this.begin;
    // }
  }

  toString(pad) {

    if (pad) {
      pad = Number(pad);
    } else if (this.end < 0x0100) {
      return `${this.begin}-${this.end}`;
    } else if (this.end < 0x010000) {
      pad = 4;
    } else if (this.end < 0x01000000) {
      pad = 6;
    } else {
      pad = 8;
    }
    return `${hexString(this.begin, pad)}-${hexString(this.end, pad)}`;
  }

  contains(i) {
    // true if this range includes i
    return (i >= this.begin && i <= this.end);
  }

  offset(offset) {
    // return a new range offset from this range
    return new ROMRange(this.begin + offset, this.end + offset);
  }

  intersection(range) {
    // return a new range that includes the intersection of this range
    // with another range (can be empty)
    const begin = Math.max(range.begin, this.begin);
    const end = Math.min(range.end, this.end);
    return new ROMRange(begin, end);
  }

  isEmpty() {
    // true if the array is empty
    return (this.end < this.begin);
  }

  get length() {
    // return the length of the range
    return (this.end - this.begin + 1);
  }

  set length(newLength) {
    // set the length of the range by changing end
    this.end = this.begin + newLength - 1;
  }
}

module.exports = ROMRange;
