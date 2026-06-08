local Base100 = {}

local Alphabet = {}
local Reverse = {}

for i = 0, 99 do
	local char = utf8.char(0x0100 + i)
	Alphabet[i] = char
	Reverse[char] = i
end

function Base100.Encode(text)
	local result = {}

	for i = 1, #text do
		local byte = string.byte(text, i)

		local high = math.floor(byte / 100)
		local low = byte % 100

		table.insert(result, Alphabet[high])
		table.insert(result, Alphabet[low])
	end

	return table.concat(result)
end

function Base100.Decode(encoded)
	local chars = {}

	for _, codepoint in utf8.codes(encoded) do
		table.insert(chars, utf8.char(codepoint))
	end

	if #chars % 2 ~= 0 then
		error("Invalid Base100 string")
	end

	local output = {}

	for i = 1, #chars, 2 do
		local high = Reverse[chars[i]]
		local low = Reverse[chars[i + 1]]

		if not high or not low then
			error("Invalid Base100 character")
		end

		local byte = high * 100 + low
		table.insert(output, string.char(byte))
	end

	return table.concat(output)
end

return Base100
