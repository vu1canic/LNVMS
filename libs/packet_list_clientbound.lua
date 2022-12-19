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
}


local status_packets = {
    [0x00] = {10},
    [0x01] = {7}
}

local login_packets = {
    [0x00] = {11},
    [0x01] = {10, 13, 24, 13, 24},
    [0x02] = {10, 10}
}

local play_packets = { -- clientbound
    [0x00] = {13, 20, 2, 9, 9, 9, 19, 19, 6, 4, 4, 4},         -- spawn object
    [0x01] = {13, 9, 9, 9, 4},                                 -- spawn xp orb
    [0x02] = {13, 2, 9, 9, 9},                                 -- spawn global entity
    [0x03] = {13, 20, 13, 9, 9, 9, 19, 19, 19, 4, 4, 4, 15},   -- spawn mob
    [0x04] = {13, 20, 10, 18, 2},                              -- spawn painting
    [0x05] = {13, 20, 9, 9, 9, 19, 19, 15},                    -- spawn player
    [0x06] = {13, 3},                                          -- play animation (clientbound)
    [0x07] = {},
    [0x08] = {13, 18, 2},                                      -- block break animation
    [0x09] = {18, 3, 17},                                      -- update block entity
    [0x0A] = {18, 3, 3, 13},                                  -- block action
    [0x0B] = {18, 13},                                        -- block change
    [0x0C] = {},
    [0x0D] = {3},                                             -- server difficulty
    [0x0E] = {},
    [0x0F] = {11, 2},                                         -- chat message
    [0x10] = {},
    [0x11] = {2, 4, 1},                                       -- confirm transaction (clientbound)
    [0x12] = {3},                                             -- Close Window (clientbound)
    [0x13] = {},
    [0x14] = {},
    [0x15] = {3, 4, 4},                                       -- Window Property
    [0x16] = {2, 4, 16},                                      -- set slot
    [0x17] = {13, 13},                                        -- set cooldown
    [0x18] = {},
    [0x19] = {10, 13, 6, 6, 6, 8, 8},                         -- nameed sound effect
    [0x1A] = {11},                                            -- disconnect
    [0x1B] = {6, 2},                                          -- entity status
    [0x1C] = {},
    [0x1D] = {6, 6},                                          -- unload chunk
    [0x1E] = {3, 8},                                          -- change game state (multiple uses)
    [0x1F] = {7},                                             -- keep-alive
    [0x20] = {},
    [0x21] = {6, 18, 6, 1},                                   -- effect (multiple uses)
    [0x22] = {},
    [0x23] = {6, 3, 6, 3, 3, 10, 1},                          -- join game
    [0x24] = {},
    [0x25] = {13},                                            -- entity init / player no pos/look change
    [0x26] = {13, 4, 4, 4, 1},                                -- entity relative move
    [0x27] = {13, 4, 4, 4, 19, 19, 1},                        -- entity look and relative move
    [0x28] = {13, 19, 19, 1},                                 -- entity look
    [0x29] = {9, 9, 9, 8, 8},                                 -- vechicle move
    [0x2A] = {18},                                            -- open sign editor
    [0x2B] = {2, 13},                                         -- craft recipe response (reciepe book i think)
    [0x2C] = {2, 8, 8},                                       -- player abilities
    [0x2D] = {},
    [0x2E] = {},
    [0x2F] = {9, 9, 9, 8, 8, 2, 13},                          -- player pos and look
    [0x30] = {13, 18},                                        -- use bed
    [0x31] = {},
    [0x32] = {},
    [0x33] = {13, 2},                                         -- remove entity effect
    [0x34] = {10, 10},                                        -- resouce pack send
    [0x35] = {6, 3, 3, 10},                                   -- respawn
    [0x36] = {13, 19},                                        -- entity head look
    [0x37] = {1, 10},                                         -- select advancement tab (??)
    [0x38] = {},
    [0x39] = {13},                                            -- camera(spectator)
    [0x3A] = {2},                                             -- held item change
    [0x3B] = {2, 10},                                         -- display scoreboard
    [0x3C] = {13, 15},                                        -- entity metadata
    [0x3D] = {6, 6},                                          -- attach entity
    [0x3E] = {13, 4, 4, 4},                                   -- entity velocity
    [0x3F] = {13, 13, 16},                                    -- entity equipment
    [0x40] = {8, 13, 13},                                     -- set experience
    [0x41] = {8, 13, 8},                                      -- update health
    [0x42] = {},
    [0x43] = {},
    [0x44] = {},
    [0x45] = {},
    [0x46] = {18},                                            -- spawn position (for compass)
    [0x47] = {7, 7},                                          -- time update
    [0x48] = {},
    [0x49] = {13, 13, 6, 6, 6, 8, 8},                         -- sound effect
    [0x4A] = {11, 11},                                        -- Player List Header And Footer (TAB list)
    [0x4B] = {13, 13, 13},                                    -- collect item
    [0x4C] = {13, 9, 9, 9, 19, 19, 1},                        -- entity teleport
    [0x4D] = {},
    [0x4E] = {},
    [0x4F] = {13, 2, 2, 13, 2},                               -- entity effect
}

return {handshake_packets, status_packets , login_packets, play_packets}