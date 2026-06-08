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

-- INPUTS (replace these with GUI values later)
local encoding = 1 -- 1=Base32, 2=Base58, 3=Base64, 4=Base100
local mode = "E"   -- "E" = Encode, "D" = Decode
local text = "Hello World"

-- Get selected module
local module = Crypto[encoding]

-- Safety check 1: valid encoding selection
if not module then
	error("❌ Invalid encoding selected (must be 1-4)")
end

-- Safety check 2: Encode/Decode functions exist
if type(module.Encode) ~= "function" then
	error("❌ Selected module is missing Encode function")
end

if type(module.Decode) ~= "function" then
	error("❌ Selected module is missing Decode function")
end

-- Safety check 3: valid mode
mode = string.upper(mode)

if mode ~= "E" and mode ~= "D" then
	error("false\ Mode must be 'E' (Encode) or 'D' (Decode)")
end

-- Optional safety check 4: empty input
if text == nil or text == "" then
	error("false\ Input text cannot be empty")
end

-- Execute
local result

local success, err = pcall(function()
	if mode == "E" then
		result = module.Encode(text)
	else
		result = module.Decode(text)
	end
end)

-- Final safety wrapper
if not success then
	error("false\ Encoding/Decoding failed: " .. tostring(err))
end

print("✔ Result:")
print(result)
