import romtools as rt


class Range:

    def __init__(self, begin, end=None):

        self.begin = 0
        self.end = 0

        if isinstance(begin, int):
            # begin parameter is an int
            self.begin = begin

        elif isinstance(begin, str):
            # begin parameter is a string
            bounds = begin.split('-')

            if len(bounds) == 2:
                # begin and end specified in a single string
                begin = bounds[0]
                end = bounds[1]

            try:
                self.begin = int(begin, 0)
            except ValueError:
                raise TypeError('Cannot convert range begin to int: ' + begin)

        if end is None:
            # single parameter, range is from 0 to value - 1
            self.end = self.begin - 1
            self.begin = 0

        elif isinstance(end, int):
            # end parameter is an int
            self.end = end

        elif isinstance(end, str):
            # end parameter is a string
            try:
                self.end = int(end, 0)
            except ValueError:
                raise TypeError('Cannot convert range end to int: ' + end)

        else:
            raise TypeError('Range end must be an int or string')

    def __str__(self):
        if self.end < 0x0100:
            return f'{self.begin}-{self.end}'
        else:
            return self.hex_string()

    def hex_string(self, pad=None):
        begin_string = rt.hex_string(self.begin, pad)
        end_string = rt.hex_string(self.end, pad)
        return f'{begin_string}-{end_string}'

    def contains(self, i):
        if i >= self.begin and i <= self.end:
            return True
        else:
            return False

    def offset_by(self, offset):
        return Range(self.begin + offset, self.end + offset)

    def intersection(self, other_range):
        begin = max(self.begin, other_range.begin)
        end = min(self.end, other_range.end)
        return Range(begin, end)

    def length(self):
        return self.end - self.begin + 1

    def is_empty(self):
        return self.length() <= 0
