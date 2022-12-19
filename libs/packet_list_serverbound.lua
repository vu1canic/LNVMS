--[[
    [1]  -- boolean
    [2]  -- byte
    [3]  -- unsigned byte
    [4]  -- short
    [5]  -- unsigned short
    [6]  -- int
    [7]  -- long
    [8]  -- float
    [9]  -- double
    [10] -- string
    [11] -- chat
    [12] -- identifier
    [13] -- varint
    [14] -- varlong
    [15] -- entity metadata
    [16] -- slot
    [17] -- NBT tag
    [18] -- position
    [19] -- angle
    [20] -- UUID
    [21] --       TODO
    [22] --       TODO
    [23] --       TODO
    [24] --       TODO
]]

local handshake_packets = {
    [0x00] = {13, 10, 5, 13}    -- ID: 0x00
}
-- TODO: legacy server list ping

local status_packets = {
    [0x00] = {},
    [0x01] = {7}
}

local login_packets = {
    [0x00] = {10},
    [0x01] = {13, 24, 13, 24}
}

local play_packets = { 
    [0x00] = {13},                                                     -- Teleport Confirm
    [0x01] = {},
    [0x02] = {10},                                                     -- chat message
    [0x03] = {}, 
    [0x04] = {10, 2, 13, 1, 3, 13},                                    -- client settings
    [0x05] = {2, 4, 1},                                                -- confirm transaction
    [0x06] = {2, 2},                                                   -- enchant item
    [0x07] = {3, 4, 2, 4, 13, 16},                                     -- click window (player interact with window)
    [0x08] = {3},                                                      -- close window
    [0x09] = {}, 
    [0x0A] = {},
    [0x0B] = {7},                                                     -- keep-alive
    [0x0C] = {1},                                                     -- player(on ground)
    [0x0D] = {9, 9, 9, 1},                                            -- player position
    [0x0E] = {9, 9, 9, 8, 8, 1},                                      -- player pos and look
    [0x0F] = {8, 8, 1},                                               -- player look
    [0x10] = {9, 9, 9, 8, 8},                                         -- vechicle move
    [0x11] = {1, 1},                                                  -- boat steering(paddles)
    [0x12] = {2, 13, 1},                                              -- craft recipe request(crafting book)
    [0x13] = {2, 8, 8},                                               -- player abilities
    [0x14] = {13, 18, 2},                                             -- player digging         (doing much more than that)
    [0x15] = {},
    [0x16] = {8, 8, 3},                                               -- steer vehicle
    [0x17] = {},
    [0x18] = {13},                                                    -- resource pack status
    [0x19] = {},
    [0x1A] = {4},                                                     -- held item change
    [0x1B] = {4, 16},                                                 -- creative inventory slot (delete item?)
    [0x1C] = {18, 10, 10, 10, 10},                                    -- update sign
    [0x1D] = {13},                                                    -- same as 32 (???????)
    [0x1E] = {20},                                                    -- spectator tp to UUID
    [0x1F] = {18, 13, 13, 8, 8, 8},                                   -- player block placement
    [0x20] = {13}                                                     -- use item(left or right hand)
}

return {handshake_packets, status_packets , login_packets, play_packets}