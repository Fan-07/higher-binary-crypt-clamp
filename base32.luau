local Base32 = {}

local Alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ234567"

local Reverse = {}
for i = 1, #Alphabet do
	Reverse[Alphabet:sub(i, i)] = i - 1
end

-- strings to bit arrays
local function toBits(str)
	local bits = {}

	for i = 1, #str do
		local byte = string.byte(str, i)

		for j = 7, 0, -1 do
			table.insert(bits, math.floor(byte / 2^j) % 2)
		end
	end

	return bits
end

--  bits to string
local function fromBits(bits)
	local result = {}

	for i = 1, #bits - 7, 8 do
		local byte = 0

		for j = 0, 7 do
			byte = byte + bits[i + j] * 2^(7 - j)
		end

		result[#result + 1] = string.char(byte)
	end

	return table.concat(result)
end

function Base32.Encode(data)
	local bits = toBits(data)

	-- pad to multiple of 5
	while #bits % 5 ~= 0 do
		table.insert(bits, 0)
	end

	local output = {}

	for i = 1, #bits, 5 do
		local value = 0

		for j = 0, 4 do
			value = value + bits[i + j] * 2^(4 - j)
		end

		output[#output + 1] = Alphabet:sub(value + 1, value + 1)
	end

	-- RFC 4648 padding '=' to multiple of 8 chars
	while #output % 8 ~= 0 do
		output[#output + 1] = "="
	end

	return table.concat(output)
end

function Base32.Decode(data)
	data = data:gsub("=", "")

	local bits = {}

	for i = 1, #data do
		local char = data:sub(i, i)
		local value = Reverse[char]

		if value == nil then
			error("Invalid Base32 character: " .. char)
		end

		for j = 4, 0, -1 do
			table.insert(bits, math.floor(value / 2^j) % 2)
		end
	end

	return fromBits(bits)
end

return Base32
