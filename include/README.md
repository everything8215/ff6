# `include/` directory

## Macros

### Reserving space in RAM

The SFC/SNES has 128 kilobytes of RAM available for use as read-write
program data, and the various program modules in this game use almost all
of it. This presents a challenge for a reverse-engineering project, because
the variables and buffers have been allocated fairly optimally in the
available address space, so it is very difficult to insert new
variables or increase the size of existing variables. To do so would require
manually reallocating or overwriting subsequent regions of RAM, which it
time-consuming and prone to introducing bugs.

Although the ca65 assembler is equipped with some built-in tools that could
be useful for reserving space in RAM (`.struct`, `.tag`, `.res`, etc.), I've
found that it lacks a few capabilities that are needed to generate the RAM
maps for a game like Final Fantasy (array support and subscripting, re-use of
RAM regions by different modules). With that in mind, I've elected to write the
set of assembler macros below which can be used to map out the system RAM so
that variables can be used directly in the assembly code, and allowing for
easier insertions, deletions, and relocation of variables. Because we aren't
using the built-in commands of ca65, things like `.sizeof()` don't work, so
alternatives for these have been added manually.

#### `ram_org <offset>`

The `ram_org` macro sets the RAM offset, which is an assembler variable
similar to the program counter, but only used for reserving RAM variables.
This should be used to set the initial RAM offset before reserving space
for any variables. When space is reserved using one of the macros below,
the RAM offset will automatically be incremented by the size of the
variable(s) that were generated.

#### `ram_byte [label]`, `ram_word [label]`, `ram_faraddr [label]`, `ram_dword [label]`

Reserve space in RAM for a variable at the current RAM offset. If `label` is
blank, the RAM offset will still be incremented by the appropriate amount
but no symbol will be generated. The number of bytes reserved for each
macro is as follows:

- `ram_byte`: 1 byte
- `ram_word`: 2 bytes
- `ram_faraddr`: 3 bytes
- `ram_dword`: 4 bytes

Example:

```text
ram_org $10
ram_byte MyByte
ram_word MyWord
ram_word MyFarAddr
```

generates the following symbols with the values shown:

```text
MyByte = $10
MyWord = $11
MyFarAddr = $13
MyByte::SIZE = 1
MyWord::SIZE = 2
MyFarAddr::SIZE = 3
```

Additional symbols with explicit address sizes are also generated, see
`ram_addr_size` below.

#### `ram_res [label], <size>`

Reserve space of any size in RAM. Similarly to `ram_byte`, etc., if `label` is
blank, the RAM offset will still be incremented by the appropriate amount
but no symbol will be generated. If `size` is zero, the `SIZE` constant will
not be defined. This is so that sizes of arrays and scopes can be set manually.

#### `ram_scope <label>`, `end_ram_scope`

Declare a scoped region of RAM with the label `label`. All variables
declared between `ram_scope` and `end_ram_scope` can be accessed using the
standard ca65 namespace syntax. For example,

```text
ram_org $c800
ram_scope MyScope
        ram_byte Var1
        ram_word Var2
        ram_res Buffer, 14
end_ram_scope
```

will generate labels with the following values:

```text
MyScope = $c800
MyScope::Var1 = $c800
MyScope::Var1 = $c801
MyScope::Buffer = $c803
MyScope::SIZE = 17
MyScope::Buffer::Size = 14
```

#### `ram_array <label>, <num_items>, <item_size>, [num_blocks]`, `end_ram_array`, `end_ram_block`

A `ram_array` has all the same properties as a `ram_scope`, but in addition
it creates multiple copies of the variables declared inside it as determined
by the `num_copies` parameter. Unlike a scope, whose size is the sum of the
sizes of the variables inside it, the size of each item in an array is a
parameter that must be specified when the array is created (`item_size`). An
error check is performed when the array ends to ensure that the declared
member variables didn't overflow the specified item size. An example array
is declared as follows:

```text
ram_array MyArray, 4, 2
        ram_byte Member1
        ram_byte Member2
end_ram_array
```

will generate the following values

```text
MyArray = $c811
MyArray::SIZE = 8
MyArray::NUM_ITEMS = 4
MyArray::ITEM_SIZE = 2
MyArray::Member1 = $c811
MyArray::Member2 = $c812
MyArray::_0 = $c811
MyArray::_1 = $c813
MyArray::_2 = $c815
MyArray::_3 = $c817
MyArray::_0::Member1 = $c811
MyArray::_0::Member2 = $c812
MyArray::_1::Member1 = $c813
...
MyArray::_2::Member2 = $c816
MyArray::_3::Member1 = $c817
MyArray::_3::Member2 = $c818
```

Notice that the address of the first item's members can be used in assembly
code when indexed instructions like `lda MyArray::Member1,x` are used.
Specific items are more rarely needed, but they can be accessed using
the pseudo-subscript operator (really just more namespaces) as shown above.

To reduce the number of symbols generated for large arrays, individual
array items and their members do not have a `SIZE` attribute because every
item and its members have the same size. Instead the `ITEM_SIZE` constant
for the array and the size of the array members (i.e. `MyArray::Member1::SIZE`)
should be used.

The optional `num_blocks` parameter causes the array to be created as a set
of sequential blocks, each with size `item_size`. This is a technique sometimes
used in assembly programming so that the values used for indexing don't get too
large. For example, an array with 16 elements and an item size of 32 bytes
requires the use of 16-bit index registers. By splitting each item into two
blocks of 16 bytes each, the entire array can be accessed with 8-bit index
registers. Note, however, that all members must be contained entirely within
a single block because adjacent blocks for an array item are not stored
contiguously in RAM.

For example,

```text
ram_array BlockArray, 16, 32, 2
      ram_res FirstBlock, 16
      end_ram_block
      ram_res SecondBlock, 16
      end_ram_block
end_ram_array
```

will generate the following values:

```text
BlockArray = $c819
BlockArray::SIZE = 512
BlockArray::NUM_ITEMS = 16
BlockArray::ITEM_SIZE = 32
BlockArray::BLOCK_SIZE = 16
BlockArray::NUM_BLOCKS = 2
BlockArray::FirstBlock = $c819
BlockArray::SecondBlock = $c919
```

The `end_ram_block` identifies the end of each block. This is required
between blocks, but optional at the end of the last block. At the end of each
RAM block, an error check is performed to make sure that the block didn't
overflow.

In the example code below, we multiply the array index by the block size
(not the item size) to copy a 32-byte array item into a buffer even with 8-bit
index registers.

```text
        lda DesiredArrayIndex
        asl
        asl
        asl
        asl
        tax
        ldy #BlockArray::BLOCK_SIZE
:       lda BlockArray::FirstBlock,x
        sta SomeBuffer,x
        lda BlockArray::SecondBlock,x
        sta SomeBuffer+BlockArray::BLOCK_SIZE,x
        inx
        dey
        bne :-
```

#### `array_item <array>, <index>` and `array_member <array>, <index>, <member>`

Another way to get the address of a specific array item is to use the
`array_item` macro which has the syntax
`array_item <array_name>, <item_index>`, so
`array_item MyArray, 2` is equivalent to `MyArray::_2`. Similarly, the
`array_member` macro can be used to get the address of a member variable in
an array item, so `array_member MyArray, 2, Member1` is equivalent to
`MyArray::_2::Member1`.

The main benefit of using the `array_item` and `array_member` macros is that
any number format or assembler constant can be used as an index, whereas with
the `_2` syntax the index is a string so it must be specified as an underscore
followed by a base-10 value.

#### `ram_addr_size <size>`

Sets the default address size for reserved labels. The 65c816 architecture allows
us to set the direct page and data bank registers so that full 24-bit
addresses don't need to be specified in every instruction. This is especially
useful for variables allocated in bank `$7e` and `$7f` of the SNES onboard RAM
because a variable at e.g. `$7e4000` can be accessed via `lda $4000` rather
than `lda $7e4000` if the data bank is set to `$7e`, saving one byte per
instruction. Similarly, data at `$0b46` can be accessed via `lda $46`
rather than `lda $0b46` if the direct page register is set to `$0b00`, again
saving one byte per instruction.

To make use of this, every RAM label that is generated also
generates additional labels for each address size. For example, if the
RAM offset is `$7e5555`, `ram_byte MyVar` will generate the following
labels in addition to those listed above:

```text
MyVar_zp = $55
MyVar_near = $5555
MyVar_far = $7e5555
```

Explicitly sized labels within a scope or array can be accessed using
normal ca65 namespace notation, i.e. `MyScope::Var1_near` or even
`MyArray::_03::Member1_far`.

All of these labels can be used in the assembly code as needed, but the default
value assigned to the label `MyVar` above can be any one of these three, as
determined by the current RAM address size. The address size can be changed
with the `ram_addr_size` macro, where the `size` parameter is any of the
following values:

- `ZP`: use 1-byte zero-page (i.e. direct page) addressing
- `NEAR`: use 2-byte near addressing
- `FAR`: use 3-byte far addressing

Using the `NEAR` address size is useful when reserving variables in e.g. bank
`$7e` if the data bank is set to `$7e`. Similarly, the `ZP` address
size is useful when reserving variables in the range `$0b00-$0bff` if the
direct page register is set to `$0b00` (as is the case in the field
module of Final Fantasy 5).

#### `ram_verbose <0 or 1>`

When set to 1, the names of all reserved labels will be printed to the console
during assembly, along with their values. When set to 0, nothing will be
printed. The default is 0.
