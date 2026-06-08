local CryptoFolder = game.ReplicatedStorage:WaitForChild("Crypto")

local Base32 = require(CryptoFolder:WaitForChild("Base32"))
local Base58 = require(CryptoFolder:WaitForChild("Base58"))
local Base64 = require(CryptoFolder:WaitForChild("Base64"))
local Base100 = require(CryptoFolder:WaitForChild("Base100"))

-- Dispatcher table
local Crypto = {
	[1] = Base32,
	[2] = Base58,
	[3] = Base64,
	[4] = Base100,
}

local encoding = 1 -- 1=Base32, 2=Base58, 3=Base64, 4=Base100
local mode = "E"   -- "E" = Encode, "D" = Decode
local text = "Hello World"

local module = Crypto[encoding]

if not module then
	error("f\ Invalid encoding selected (must be 1-4)")
end

if type(module.Encode) ~= "function" then
	error("f\ Selected module is missing Encode function")
end

if type(module.Decode) ~= "function" then
	error("f\ Selected module is missing Decode function")
end

mode = string.upper(mode)

if mode ~= "E" and mode ~= "D" then
	error("false\ Mode must be 'E' (Encode) or 'D' (Decode)")
end

if text == nil or text == "" then
	error("false\ Input text cannot be empty")
end

local result

local success, err = pcall(function()
	if mode == "E" then
		result = module.Encode(text)
	else
		result = module.Decode(text)
	end
end)

if not success then
	error("false\ Encoding/Decoding failed: " .. tostring(err))
end

print("true\ Result:")
print(result)
