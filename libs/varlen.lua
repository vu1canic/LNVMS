local varlen = {}

local function list_to_str(list)
    str = ""
    for i=1, #list do
        str = str .. string.char(list[i])
    end
    return str
end

function varlen.intwrite(int)
    local vint, bits, char = {}, 0, 1
    -- char = 1
    -- vint = {}
    if int <0 then int = 0xffffffff + int + 1 end -- process negetive numbers
    if int > 0 then
        while int > 0 do

            bits = int & 127
            int = int >> 7
            if int > 0 then bits = bits + 128 end
            vint[char] = bits
            char = char + 1

        end
        -- if char > 6 then error("VarInt is too long") end
        vint = list_to_str(vint)
    else
        return string.char(0)
    end
    return vint
end

function varlen.intread(in_data)
    local loop, int, bits = 0, 0, 0
    while loop < 10 do
        bits = string.byte(in_data)
        if (bits & 128) ~= 128 then
            int = int + ((bits & 127) << (loop*7))
            break
        else
            int = int + ((bits & 127) << (loop*7))
            loop = loop + 1
            in_data = string.sub(in_data , 2, -1)
        end
    end

    if (int >> 31) == 1 then
        int = 0xffffffff00000000 + int
    end

    return int, loop+1
end

function varlen.longwrite(long)
    local vlong, bits, char = {}, 0, 1
    -- char = 1
    -- vlong = {}
    if long < 0 then long = 0xffffffffffffffff + long + 1 end -- process negetive numbers
    if long ~= 0 then
        while long ~= 0 do

            bits = long & 127
            long = long >> 7
            -- print("b:" .. string.byte(bits))
            if long ~= 0 then bits = bits + 128 end
            vlong[char] = bits
            char = char + 1

        end
        -- if char > 11 then error("VarInt is too long") end
        vlong = list_to_str(vlong)
    else
        return string.char(0)
    end
    return vlong
end

function varlen.longread(in_data)
    local loop, long, bits = 0, 0, 0
    while loop < 10 do
        bits = string.byte(in_data)
        if (bits & 128) ~= 128 then 
            long = long + ((bits & 127) << (loop*7))
            break 
        else 
            long = long + ((bits & 127) << (loop*7))
            loop = loop + 1
            in_data = string.sub(in_data , 2, -1)
        end
    end

    -- if (long >> 63) == 1 then
    --     long = 0xffffffff00000000 + long
    -- end

    return long, loop+1
end

return varlen

