import romtools as rt


class MemoryMap:

    def __init__(self, mode):
        self.mode = mode

    def map_address(self, address):
        if self.mode == 'none':
            return address

        elif self.mode == 'mmc1':
            bank = address & 0xFF0000
            if address & 0x8000 == 0:
                raise ValueError('Invalid MMC1 address: ' + hex(address))
            address &= 0x3FFF
            address |= (bank >> 2)
            return address + 0x10

        elif self.mode == 'mmc3':
            bank = address & 0xFF0000
            if address & 0x8000 == 0:
                raise ValueError('Invalid MMC3 address: ' + hex(address))
            address &= 0x1FFF
            address |= (bank >> 3)
            return address + 0x10

        elif self.mode == 'lorom':
            if address & 0x8000 == 0:
                raise ValueError('Invalid LoROM address: ' + hex(address))
            bank = address & 0xFF0000
            return (bank >> 1) + (address & 0x7FFF)

        elif self.mode == 'hirom':
            if address <= 0x7FFFFF:
                raise ValueError('Invalid HiROM address: ' + hex(address))
            elif address <= 0xBFFFFF:
                return address - 0x800000
            elif address <= 0xFFFFFF:
                return address - 0xC00000
            else:
                raise ValueError('Invalid HiROM address: ' + hex(address))

        else:
            raise ValueError('Invalid map mode: ' + self.mode)

    def unmap_address(self, address):

        if self.mode == 'none':
            return address

        elif self.mode == 'mmc1':
            if (address < 0x10):
                raise ValueError('Invalid MMC1 address: ' + hex(address))
            address -= 0x10
            bank = (address << 2) & 0xFF0000
            return bank | (address & 0x3FFF) | 0x8000

        elif self.mode == 'mmc3':
            if (address < 0x10):
                raise ValueError('Invalid MMC1 address: ' + hex(address))
            address -= 0x10
            bank = (address << 3) & 0xFF0000
            if bank & 0x010000 == 0:
                return bank | (address & 0x1FFF) | 0x8000
            else:
                return bank | (address & 0x1FFF) | 0xA000

        elif self.mode == 'lorom':
            bank = (address << 1) & 0xFF0000
            return bank | (address & 0x7FFF) | 0x8000

        elif self.mode == 'hirom':
            return address + 0xC00000

        else:
            raise ValueError('Invalid map mode: ' + self.mode)

    def map_range(self, range):
        begin = self.map_address(range.begin)
        end = self.map_address(range.end)
        return rt.Range(begin, end)

    def unmap_range(self, range):
        begin = self.unmap_address(range.begin)
        end = self.unmap_address(range.end)
        return rt.Range(begin, end)
