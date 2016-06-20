-- Set module --
local modname = ...
local M = {}
_G[modname] = M

-- Constant device address.
local MCP3426_ADDRESS = 0x68
-- Default value for i2c communication
local id = 0
local sda = 3
local scl = 4
-- Basic functions
local function Write(config)
  i2c.start(id)
  i2c.address(id,MCP3426_ADDRESS,i2c.TRANSMITTER)
  i2c.write(id,config)
  i2c.stop(id)
end

local function Read()
  i2c.start(id)
  i2c.address(id,MCP3426_ADDRESS,i2c.RECEIVER)
  local buffer = i2c.read(id,3)
  i2c.stop(id)
  return (256 * buffer:byte(1) + buffer:byte(2))
end

M.CONFIG1 = 0x80 --0b1.00.0.00.00 -- ch1, oneshot, 12bits, x1
M.CONFIG2 = 0xA0 --0b1.01.0.00.00 -- ch2, oneshot, 12bits, x1

function M.init()
  -- setup i2c
  i2c.setup(id,sda,scl,i2c.SLOW)
  -- i2c general reset
  i2c.start(id)
  i2c.address(id,0x00,i2c.TRANSMITTER)
  i2c.write(id,0x06)
  i2c.stop(id)
  tmr.delay(500)
end

function M.readADC(config)
  Write(config)
  tmr.delay(5000)
  return Read()
end

return M
