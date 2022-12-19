local packets_serverbound = require "libs.packet_list_serverbound"
local packets_clientbound = require "libs.packet_list_clientbound"

local packet_parser = {}

function print_hex(p_raw_data)
    local p_data =""
    for i=1, #p_raw_data do
        p_data = p_data .. string.format("%02x", string.byte(string.sub(p_raw_data, i, i))) .. " "
    end
    print(p_data)
end

-----------------------------------

local function _varint_d(data)
    -- p(#data, data)
    local varint, len = v.intread(data)
    data = data:sub(1+len, -1)
    return varint, data
end

local function _varlong_d(data)
    local varint, len = v.longread(data)
    data = data:sub(1+len, -1)
    return varint, data
end

local function _string_d(data)
    local lenght, v_bits = v.intread(data)
    local string = data:sub(1+v_bits,v_bits+lenght)
    return string, data:sub(1+v_bits+lenght)
end

local function _un_short_d(data)
    local _temp = data:sub(1,2)
    local _ushort = ((0 + string.byte(_temp:sub(1,1))) << 8) + string.byte(_temp:sub(2,2))
    -- print(_ushort)
    return _ushort, data:sub(3,-1)
end

local function _long_d(data)
    local _temp = data:sub(1,8)
    local _long = 0
    -- local _long = ((0 + string.byte(_temp:sub(1,1))) << 8) + string.byte(_temp:sub(2,2))
    -- local _long = data:sub(1,8)
    for i=1,8 do
        _long = (_long << 8) + string.byte(_temp:sub(i, i))
        -- print(_long, string.byte(_temp:sub(i, i)))
    end
    -- print(_long)
    return _long, data:sub(9,-1)
end

local function _bool_d(data)
    if string.byte(data) == 1 then 
        return true, string.sub(data, 2,-1)
    else 
        return false, string.sub(data, 2,-1)
    end
    
end

local function _double_d(data)          -- TODO: optimize
    local _temp, _temp2, _temp3 = "" , string.sub(data, 1, 8), 0
    local float
    for i=1, #_temp2 do
        -- _temp = _temp .. string.format("%02x", string.byte(string.sub(_temp2, i, i))) .. " "
        _temp3 = (_temp3 << 8) + string.byte(string.sub(_temp2, i,i))
    end
    -- print(_temp3)
    _temp2 = string.pack("i8", _temp3)
    _temp3 = string.unpack("d",_temp2)
    return _temp3, data:sub(9, -1)
end

local function _float_d(data)
    local _temp, _temp2, _temp3 = "" , string.sub(data, 1, 4), 0
    local float
    -- for i=1, #_temp2 do
    --     _temp = _temp .. string.format("%02x", string.byte(string.sub(_temp2, i, i))) .. " "
    --     _temp3 = (_temp3 << 8) + string.byte(string.sub(_temp2, i,i))
    -- end
    -- print(_temp)
    -- _temp2 = string.pack("i8", _temp3)
    _temp3 = string.unpack("f",_temp2:reverse())
    return _temp3, data:sub(5, -1)
end

local function _position_d(data)
    local _position = {}
    local _temp, _temp2, _temp3 = 0, nil, nil
    
    for i=1, 8 do
        -- _temp = _temp .. string.format("%02x", string.byte(string.sub(_temp2, i, i))) .. " "
        _temp = (_temp << 8) + string.byte(string.sub(data, i,i))
    end
    -- print(_temp)
    
    -- print(_temp2 & 0x2000000)
    -- print(string.format("%02x", _temp2))
    
    -- _temp3 = (-1 << 26) + _temp2
    -- print(string.format("%02x", _temp3))

    -- print(_temp3)
    _temp2 = _temp >> 38 & 0x3FFFFFF
    if _temp2 & 0x2000000 then
        _position[1] = (-1 << 26) + _temp2
    else
        _position[1] = _temp2
    end
    _temp2 = _temp >> 26 & 0xFFF
    if _temp2 & 0x800 then
        _position[2] = (-1 << 12) + _temp2 & 0xFF
    else
        _position[2] = _temp2
    end
    _temp2 = _temp & 0x3FFFFFF
    if _temp2 & 0x2000000 then
        _position[3] = (-1 << 26) + _temp2 & 0x3FFFFFF
    else
        _position[3] = _temp2
    end
    -- _position[1] = nil

    return _position , data:sub(9, -1)
end                                                                 -- okolice tego -84.900768393958, 94.0, 276.27146856842

local function _byte_d(data)
    return string.unpack("b", data:sub(1,1)) , string.sub(data, 2, -1)
end

local function _un_byte_d(data)
    -- print_hex(data)
    -- print_hex(string.sub(data, 2, -1))
    return string.unpack("B", data:sub(1,1)) , string.sub(data, 2, -1)
end

local function _short_d(data)
    return string.unpack("h", data:sub(1,2):reverse()) , string.sub(data, 3, -1)
end

local function _int_d(data)
    return string.unpack("i4", data:sub(1, 4):reverse()) , string.sub(data, 5, 1)
end

local function _slot_d(data)
    local slot, ID = {}, 0
    ID, data = _short_d(data)
    if ID == -1 then
        return { -1 }
    else
        slot[1] = ID
        slot[2], data = _byte_d(data)
        slot[3], data = _short_d(data)
        slot[4] = data
        print_hex(data)
        return slot
    end
    -- p(slot)
end

-----------------------------------

local function _long_c(data)
    local _temp = data
    local _long = ""
    -- p("data", data)
    while _temp > 0 do
        _long = string.char(_temp & 255) .. _long
        _temp = _temp >> 8
        -- p(string.char(_temp & 128), _temp)
    end
    
    if #_long < 8 then
        _long = string.rep("\x00", 8 - #_long) .. _long
    end
        -- p("dlogosc", #_long, _long)
        -- print_hex(_long)
    return _long
end

local function _string_c(data)
    return v.intwrite(#data)..data
end

-- local function _int_c(data)      -- TODO: make sure that it can work witch negative numbers
--     local _temp = data
--     local _int = ""
--     -- p("data", data)
--     while _temp > 0 do
--         _int = string.char(_temp & 127) .. _int
--         _temp = _temp >> 8
--         -- p(string.char(_temp & 128), _temp)
--     end
    
--     if #_int < 4 then
--         _int = string.rep("\x00", 8 - #_int) .. _int
--     end
--         -- p("dlogosc", #_long, _long)
--         -- print_hex(_long)
--     return _int
-- end

local function _bool_c(data)
    if data == true then return "\x01" else return "\x00" end
end


-----------------------------------

local _fieldtypes_d = {
    [1]  = _bool_d,             -- boolean
    [2]  = _byte_d,             -- byte
    [3]  = _un_byte_d,             -- unsigned byte
    [4]  = _short_d,             -- short
    [5]  = _un_short_d,       -- unsigned short
    [6]  = _int_d,             -- int
    [7]  = _long_d,             -- long
    [8]  = _float_d,             -- float
    [9]  = _double_d,             -- double
    [10] = _string_d,         -- string
    [11] = nil,             -- chat
    [12] = nil,             -- identifier
    [13] = _varint_d,         -- varint
    [14] = _varlong_d,        -- varlong
    [15] = nil,             -- entity metadata
    [16] = _slot_d,             -- slot
    [17] = nil,             -- NBT tag
    [18] = _position_d,             -- position
    [19] = nil,             -- angle
    [20] = nil,             -- UUID
    [21] = nil,             --       TODO
    [22] = nil,             --       TODO
    [23] = nil,             --       TODO
    [24] = nil              --       TODO
}

local _fieldtypes_c = {
    [1]  = _bool_c,             -- boolean
    [2]  = nil,             -- byte
    [3]  = nil,             -- unsigned byte
    [4]  = nil,             -- short
    [5]  = nil,       -- unsigned short
    [6]  = nil,             -- int
    [7]  = _long_c,             -- long
    [8]  = nil,             -- float
    [9]  = nil,             -- double
    [10] = _string_c,         -- string
    [11] = nil,             -- chat
    [12] = nil,             -- identifier
    [13] = v.intwrite,         -- varint
    [14] = v.longwrite,        -- varlong
    [15] = nil,             -- entity metadata
    [16] = nil,             -- slot
    [17] = nil,             -- NBT tag
    [18] = nil,             -- position
    [19] = nil,             -- angle
    [20] = nil,             -- UUID
    [21] = nil,             --       TODO
    [22] = nil,             --       TODO
    [23] = nil,             --       TODO
    [24] = nil              --       TODO
}

function packet_parser.parse(state, packet)
    local decoded_packet = {}
    local lenght, ID, _func, _func_return

    lenght, packet = _varint_d(packet)
    ID, packet = _varint_d(packet)

    -- p(ID)
    -- p(state)
    p("ID: 0x"..string.format("%02x", ID), "Lenght: "..lenght)
    -- local structure = handshake_packets[ID]
    for i,v in ipairs(packets_serverbound[state][ID]) do
        -- print(v)
        -- p("type", v)
        -- print_hex(packet)
        _func = _fieldtypes_d[v]
        _func_return, packet = _func(packet)
        -- p(_func_return)
        table.insert(decoded_packet, _func_return)
        -- print(_func_return)
    end


    -- p(lenght, ID, #packet)
    -- p("ID: ".. string.format("%02x", ID), "Data:", decoded_packet)
    p("Data:", decoded_packet)
    table.insert(decoded_packet, 1, ID )
    return decoded_packet
end

function packet_parser.create(state, ID, data)
    local new_packet = ""
    local lenght = 0
    for index,value in ipairs(packets_clientbound[state][ID]) do
        _func = _fieldtypes_c[value]
        _func_return= _func(data[index])
        new_packet = new_packet .. _func_return
    end

    new_packet = v.intwrite(ID)..new_packet

    lenght = v.intwrite(#new_packet)
    return lenght..new_packet
end


return packet_parser