local CryptoFolder = game.ReplicatedStorage.Crypto

local Base32 = require(CryptoFolder.Base32)
local Base58 = require(CryptoFolder.Base58)
local Base64 = require(CryptoFolder.Base64)
local Base100 = require(CryptoFolder.Base100)

print("1 = Base32")
print("2 = Base58")
print("3 = Base64")
print("4 = Base100")

local encoding = tonumber(io.read())

print("E = Encrypt")
print("D = Decrypt")

local mode = string.upper(io.read())

print("Text:")
local text = io.read()

local result

if encoding == 1 then

	if mode == "E" then
		result = Base32.Encode(text)
	else
		result = Base32.Decode(text)
	end

elseif encoding == 2 then

	if mode == "E" then
		result = Base58.Encode(text)
	else
		result = Base58.Decode(text)
	end

elseif encoding == 3 then

	if mode == "E" then
		result = Base64.Encode(text)
	else
		result = Base64.Decode(text)
	end

elseif encoding == 4 then

	if mode == "E" then
		result = Base100.Encode(text)
	else
		result = Base100.Decode(text)
	end

else
	error("Invalid encoding")
end

print("Result:")
print(result)
