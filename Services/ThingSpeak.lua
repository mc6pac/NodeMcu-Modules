-- Set module --
local modname = ...
local M = {}
_G[modname] = M

local apikey = {}
local hostname = "api.thingspeak.com"

function M.Init(writekey)
  apikey = writekey
end

function M.Speak(eventstr)
  conn = nil
  conn = net.createConnection(net.TCP, 0)

  conn:on("connection", function(c)
    print("POST: "..eventstr)
    c:send("POST /update HTTP/1.1\r\n"
    .."X-THINGSPEAKAPIKEY: "..apikey.."\r\n"
    .."Host: "..hostname.."\r\n"
    .."Content-Type: application/x-www-form-urlencoded\r\n"
    .."Content-Length: "..string.len(eventstr).."\r\n"
    .."\r\n"
    ..eventstr.."\r\n"
    .."\r\n")
  end)

  conn:on("sent", function(c) 
    print("POST sent") 
  end)

  conn:on("disconnection", function(c) 
    print("Disconnected") 
    conn = nil 
  end)

  conn:on("receive", function(c, payload) 
    local response = string.find(payload, "HTTP/1.1 200 OK")
    if response == 1 then
	  print("POST succeded")
	else
	  print("POST failed")
	end
    conn:close() 
  end)
  
  if wifi.sta.getip() then
	print("Connecting to "..hostname)
    conn:connect(80, hostname)
  else
    print("No network!")
  end
end

return M
