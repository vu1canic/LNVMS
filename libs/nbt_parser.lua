-- local v = require "varlen"
p = require('libs.utils').prettyPrint
local nbt_parser = {}

------ TODO: remove

function print_hex(p_raw_data)
    local p_data =""
    for i=1, #p_raw_data do
        p_data = p_data .. string.format("%02x", string.byte(string.sub(p_raw_data, i, i))) .. " "
    end
    print(p_data)
end

--------

local function _un_short_d(data)
    local _temp = data:sub(1,2)
    local _ushort = ((0 + string.byte(_temp:sub(1,1))) << 8) + string.byte(_temp:sub(2,2))
    -- print(_ushort)
    return _ushort, data:sub(3,-1)
end

local function _short_d(data)
    return string.unpack("h", data:sub(1,2):reverse()) , string.sub(data, 3, -1)
end

local function _int_d(data)
    return string.unpack("i4", data:sub(1, 4):reverse()) , string.sub(data, 5, 1)
end

---------------------------------------------

local function TAG_Compound(data)
    p("compound")
    
    -- type = string.byte(data:sub(lenght+3, lenght+3))
    -- print_hex(name)
    p(lenght, name)
    return 
end

local function TAG_String(data)
    local lenght
    lenght = string.unpack("h", data:sub(1, 2):reverse())
    -- p("len: ", lenght, data:sub(3, lenght+2))
    -- print_hex(data:sub(1, 2))
    -- print_hex(data)
    return data:sub(3, lenght+2), data:sub(lenght+3)
end

---------------------------------------------

local data_types = {
    [1] = TAG_Byte,
    [2] = TAG_Short,
    [3] = TAG_Int,
    [4] = TAG_Long,
    [5] = TAG_Float,
    [6] = TAG_Double,
    [7] = TAG_Byte_Array,
    [8] = TAG_String,
    [9] = TAG_List,
    --[10] = TAG_Compound,
    [11] = TAG_Int_Array,
    [12] = TAG_Long_Array

}


function nbt_parser.parse(data)
    local nbt, values = {}, {}
    local name_lenght, type, name
    local c_name_lenght, c_type, c_name
    local parsing = true
    -- local index = 1

    local _func, _func_return

    c_type = string.byte(data:sub(1, 1))
    c_name_lenght = string.unpack("i2", data:sub(2, 3):reverse())
    if c_name_lenght > 0 then
        c_name = data:sub(4, 3+c_name_lenght)
    else
        c_name = ""
    end
    -- p("once:", c_type, c_name_lenght, c_name)
    data = data:sub(3+c_name_lenght+1)

    while parsing do
        
        type = string.byte(data:sub(1, 1))

        if type == 0 then break end

        name_lenght = string.unpack("i2", data:sub(2, 3):reverse())
        if name_lenght > 0 then
            name = data:sub(4, 3+name_lenght)
        else
            name = ""
        end
        -- p("loop:", type, name_lenght, name)
        data = data:sub(3+name_lenght+1)

        -- print_hex(data)

        if type ~= 10 then
            _func = data_types[type]
            -- _func_return, data = _func(data:sub(2))
            _func_return, data = _func(data)
        else
            _func_return = nbt_parser.parse(data)
        end
        
        values[#values+1] = {type, name, _func_return}
        -- p("function return:", _func_return)
        -- print_hex(data)
        -- p("--------------------------------------")
    end
    
    return {c_type, c_name, table.unpack(values)}
end


-- function nbt_parser.parse(data)  -- basicly TAG_compound decoder idk if good design for decoding but will work for now
--     local parsing = true
--     local value = {}
--     local type, temp, _func, _func_return
--     local name, lenght
--     while parsing do
--         temp = data:sub(1,1)
--         type = string.byte(temp)

--         if type == 0 then 
--             parsing = false
--             p("breaking")
--             break
--         end
--         p("type:", string.byte(temp))
--         print_hex(data)
        
--         lenght = string.unpack("i2", data:sub(2, 3):reverse())
--         -- p(lenght)
--         if lenght > 0 then name = data:sub(4,3+lenght) else name = nil end

--         p(type, lenght, name)
--         data = data:sub(lenght+4)
        
--         -- parsing = false
--         -- if #data > 0 then nbt_parser.parse(data:sub(2)) end
--         if type ~= 10 then
--             _func = data_types[string.byte(temp)]
--             -- _func_return, data = _func(data:sub(2))
--             _func_return, data = _func(data)
--         else
--             _func_return = nbt_parser.parse(data)
--         end

--         p(_func_return)
--         -- table.insert(value, _func_return)
--         value = _func_return

--         -- parsing = false
--     end
    


--     return {type, name, value}
-- end

return nbt_parser