local v = require "libs.varlen"


function str_to_hexstr(str)
    hex = ""
    for i=1, #str do
        hex = hex .. string.format("%02x", string.byte(string.sub(str, i, i))) .. " "
        -- hex = hex .. string.byte(string.sub(str, i, i)) .. " "
    end

    return hex
end


-- response = {0x7a, 0x00, 0x78, 0x7b, 0x22, 0x64, 0x65, 0x73, 0x63, 0x72, 0x69, 0x70, 0x74, 0x69, 0x6f, 0x6e,
--             0x22, 0x3a, 0x7b, 0x22, 0x74, 0x65, 0x78, 0x74, 0x22, 0x3a, 0x22, 0x41, 0x20, 0x4d, 0x69, 0x6e,
--             0x65, 0x63, 0x72, 0x61, 0x66, 0x74, 0x20, 0x53, 0x65, 0x72, 0x76, 0x65, 0x72, 0x22, 0x7d, 0x2c,
--             0x22, 0x70, 0x6c, 0x61, 0x79, 0x65, 0x72, 0x73, 0x22, 0x3a, 0x7b, 0x22, 0x6d, 0x61, 0x78, 0x22,
--             0x3a, 0x32, 0x30, 0x2c, 0x22, 0x6f, 0x6e, 0x6c, 0x69, 0x6e, 0x65, 0x22, 0x3a, 0x30, 0x7d, 0x2c,
--             0x22, 0x76, 0x65, 0x72, 0x73, 0x69, 0x6f, 0x6e, 0x22, 0x3a, 0x7b, 0x22, 0x6e, 0x61, 0x6d, 0x65,
--             0x22, 0x3a, 0x22, 0x31, 0x2e, 0x31, 0x32, 0x2e, 0x32, 0x22, 0x2c, 0x22, 0x70, 0x72, 0x6f, 0x74,
--             0x6f, 0x63, 0x6f, 0x6c, 0x22, 0x3a, 0x33, 0x34, 0x30, 0x7d, 0x7d}

response = {0xcc, 0x01, 0x31, 0x6c, 0x6f, 0x63, 0x61, 0x6c, 0x68, 0x6f, 0x73, 0x74, 0x63, 0xdd, 0x01}


-- response = {0xdd, 0xc7, 0x01}

res = ""
for i=1, #response do
    res = res .. string.char(response[i])
end


-- print(str_to_hexstr(v.intwrite(0)))
-- print(str_to_hexstr(v.intwrite(1)))
-- print(str_to_hexstr(v.intwrite(2)))
-- print(str_to_hexstr(v.intwrite(127)))
-- print(str_to_hexstr(v.intwrite(128)))
-- print(str_to_hexstr(v.intwrite(255)))
-- print(str_to_hexstr(v.intwrite(25565)))
-- print(str_to_hexstr(v.intwrite(2097151)))
-- print(str_to_hexstr(v.intwrite(2147483647)))
-- print(str_to_hexstr(v.intwrite(-1)))
-- print(str_to_hexstr(v.intwrite(-2147483648)))

-- print(str_to_hexstr(v.longwrite(0)))
-- print(str_to_hexstr(v.longwrite(1)))
-- print(str_to_hexstr(v.longwrite(2)))
-- print(str_to_hexstr(v.longwrite(127)))
-- print(str_to_hexstr(v.longwrite(128)))
-- print(str_to_hexstr(v.longwrite(255)))
-- print(str_to_hexstr(v.longwrite(2147483647)))
-- print(str_to_hexstr(v.longwrite(9223372036854775807)))
-- print(str_to_hexstr(v.longwrite(-1)))
-- print(str_to_hexstr(v.longwrite(-2147483648)))
-- print(str_to_hexstr(v.longwrite(-9223372036854775808)))


-- print(v.intread(v.intwrite(0)))
-- print(v.intread(v.intwrite(1)))
-- print(v.intread(v.intwrite(2)))
-- print(v.intread(v.intwrite(127)))
-- print(v.intread(v.intwrite(128)))
-- print(v.intread(v.intwrite(255)))
-- print(v.intread(v.intwrite(25565)))
-- print(v.intread(v.intwrite(2097151)))
-- print(v.intread(v.intwrite(2147483647)))
-- print(v.intread(v.intwrite(-1)))
-- print(v.intread(v.intwrite(-2147483648)))

-- print(v.longread(v.longwrite(0)))
-- print(v.longread(v.longwrite(1)))
-- print(v.longread(v.longwrite(2)))
-- print(v.longread(v.longwrite(127)))
-- print(v.longread(v.longwrite(128)))
-- print(v.longread(v.longwrite(255)))
-- print(v.longread(v.longwrite(2147483647)))
-- print(v.longread(v.longwrite(9223372036854775807)))
-- print(v.longread(v.longwrite(-1)))
-- print(v.longread(v.longwrite(-2147483648)))
-- print(v.longread(v.longwrite(-9223372036854775808)))


print(v.intread("\x1d\x4c"))


-- a,b = v.intread(v.intwrite(-1))
-- print("value",a)
-- print("-----------------")
-- -- print(v.intwrite(-1))
-- a,b = v.longread(v.longwrite(9223372036854775807))
-- print("value", a, b)
-- print("a", string.format("%02x", a))

-- print("--.-.-.-.-.-.-.-.-.")
-- print("-1", string.format("%02x", -1))
-- print("-1", string.format("%02x", 1))
-- print("-2147483648", string.format("%02x", -2147483648))
-- print(str_to_hexstr(v.intwrite(-2147483648)))

-- print(0xffffffff - 1 + 1)

--[[
337:    101010001
340:    101010100

25565:  110001111011101
23951:  101110110001111
        110001111011101

]]--