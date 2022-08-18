// data-manager.js

const ROMTextCodec = require('./text-codec');
const ROMMemoryMap = require('./memory-map');

class ROMDataManager {
  constructor(definition) {

    this.definition = definition;

    // create the memory mapper
    const mapMode = definition.mode || ROMMemoryMap.MapMode.none;
    this.memoryMap = new ROMMemoryMap(mapMode);

    // create text codecs
    this.textCodec = {};
    for (let key in definition.textEncoding) {
      const encodingDef = definition.textEncoding[key];
      this.textCodec[key] = new ROMTextCodec(encodingDef, definition.charTable);
    }

    // create string tables

  }

  getDefinition(key) {
    return this.definition.assembly[key];
  }

  getObject(key) {
    return this.definition.obj[key];
  }

}

module.exports = ROMDataManager;
