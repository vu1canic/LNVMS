p = require('libs.utils').prettyPrint

nbt = require('libs.nbt_parser')


-- test_data = "\x0A\x00\x0B\x68\x65\x6C\x6C\x6F\x20\x77\x6F\x72\x6C\x64\x08\x00\x04\x6E\x61\x6D\x65\x00\x09\x42\x61\x6E\x61\x6E\x72\x61\x6D\x61\x00"

-- local f = assert(io.open("tests/hello_world.nbt", "rb"))
local f = assert(io.open("tests/handcrafted_strings.nbt", "rb"))
-- local f = assert(io.open("tests/bigtest_decompressed.nbt", "rb"))
test_data = f:read("*all")
f:close()

profiler.start()
parsed = nbt.parse(test_data)

p(parsed)

profiler.stop()
profiler.report("profiler.log")