local luasql = require "luasql.mysql"
local db_host = "127.0.0.1"  
local db_user = "freeswitch"
local db_password = "freeswitch"
local db_name = "caller_id_list"


local env = luasql.mysql()
if not env then
    freeswitch.consoleLog("ERR", "Failed to initialize LuaSQL environment.\n")
    return
end

local conn, err = env:connect(db_name, db_user, db_password, db_host)
if not conn then
    freeswitch.consoleLog("ERR", "Failed to connect mariadb: " .. (err or "unknown error") .. "\n")
    return
end

local caller_ids = {}
local cur, query_err = conn:execute("SELECT phone_number FROM caller_id_list")
if not cur then
    freeswitch.consoleLog("ERR", "Failed to execute query: " .. (query_err or "unknown error") .. "\n")
    conn:close()
    env:close()
    return
end

local row = cur:fetch({}, "a")
while row do
    table.insert(caller_ids, row.phone_number)
    row = cur:fetch(row, "a")
end

cur:close()
conn:close()
env:close()

if #caller_ids == 0 then
    freeswitch.consoleLog("ERR", "Caller ID list is null!\n")
    return
end

math.randomseed(os.time())
local random_index = math.random(1, #caller_ids)
local selected_caller_id = caller_ids[random_index]

session:setVariable("effective_caller_id_number", selected_caller_id)
session:setVariable("effective_caller_id_name", selected_caller_id)
freeswitch.consoleLog("INFO", "Selected Caller ID: " .. selected_caller_id .. "\n")