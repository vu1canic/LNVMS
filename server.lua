local uv = require('luv')
local json = require "libs.json"
v = require "libs.varlen"
p = require('libs.utils').prettyPrint

local packet_p = require 'libs.packet_parser'


ping_response = {description = {text = "           test \n 2nd test"}, players = {max = 420, online = 69}, version = {name = "1.12.2", protocol = 340} }

ping_response = json.encode(ping_response)
-- print(ping_response)
-- p_raw_data = ""
-- ping_response = string.char(0) .. v.intwrite(#ping_response) .. ping_response

local players_data = {}
local packet_state = {}


local server = uv.new_tcp()
server:bind("127.0.0.1", 25565)
server:listen(128, function (err)
    assert(not err, err)
    local client = uv.new_tcp()
    
    server:accept(client)


    -- local player_connection = 
    local port = uv.tcp_getpeername(client)["port"]
    p("Client port:", port)
    -- players_data[port] = {["state"]= 0}
    packet_state[port] = 1
    client:read_start(function (err, chunk)
        if err then
            print("Client read error: " .. err)
            client:close()
        end

        assert(not err, err)

        if chunk then

            -- p_data_print(chunk)
            -- p(packet_state[port])
            packet = packet_p.parse(packet_state[port], chunk)
            
            p(packet)

            if (packet_state[port] == 1) then
                if packet[5]==1 then
                    packet_state[port] = 2
                    p("state set to status")
                elseif packet[5]==2 then
                    packet_state[port] = 3
                p("state set to login")
                end
                return
            end



            if (packet_state[port] == 2) then
                if packet[1] == 0 then
                    client:write(packet_p.create(2, 0, {ping_response}))
                elseif packet[1] == 1 then
                    client:write(packet_p.create(2, 1, {packet[2]}))
                end
            end

            if (packet_state[port] == 3) then
                if packet[1] == 0 then
                    p("got login start packet")
                    client:write("\x2e\x02\x24\x66\x39\x33\x36\x38\x30\x31\x35\x2d\x33\x36\x62\x66\x2d\x33\x61\x61\x39\x2d\x62\x31\x64\x66\x2d\x61\x65\x32\x65\x37\x30\x30\x61\x31\x39\x63\x63\x07\x64\x7a\x77\x6f\x6e\x32\x31")
                end
                
            end
            -- -- print(player_data)
            -- -- p_data_print(chunk)
            -- p_id, p_data = p_decode(chunk)
            -- -- print(p_id)
            -- if p_id == 0 then p_00(client, p_data) end
            -- -- p_data_print(p_data)
            -- print("------")


        else
            

            p("connection closed", port)
            packet_state[port] = nil
            client:shutdown()
            client:close()
        end
    end)
end)


function p_decode(p_data)
    p_lenght, chars = v.intread(p_data)
    p_data = p_data:sub(1+chars, -1)
    p_id = string.byte(string.sub(p_data, 1, 1))
    return p_id, p_data:sub(2, -1)
end

function p_print(p_id, p_raw_data)
    local p_data =""
    for i=1, #p_raw_data do
        p_data = p_data .. string.format("%02x", string.byte(string.sub(p_raw_data, i, i))) .. " "
    end
    print("ID:" .. string.format("%02x", p_id), p_data)
end

function p_data_print(p_raw_data)
    local p_data =""
    for i=1, #p_raw_data do
        p_data = p_data .. string.format("%02x", string.byte(string.sub(p_raw_data, i, i))) .. " "
    end
    print(p_data)
end


-- function p_recieve()
-- end

uv.run()
