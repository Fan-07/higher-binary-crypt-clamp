local Base64 = {}

local Alphabet =
	"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"

function Base64.Encode(data)

	local bytes = {}

	for i = 1, #data do
		local byte = string.byte(data, i)

		for j = 7, 0, -1 do
			table.insert(bytes, math.floor(byte / 2^j) % 2)
		end
	end

	while (#bytes % 6) ~= 0 do
		table.insert(bytes, 0)
	end

	local result = ""

	for i = 1, #bytes, 6 do

		local value = 0

		for j = 0, 5 do
			value += bytes[i + j] * 2^(5 - j)
		end

		result ..= Alphabet:sub(value + 1, value + 1)
	end

	while (#result % 4) ~= 0 do
		result ..= "="
	end

	return result
end

function Base64.Decode(data)
	data = data:gsub("=", "")

	local bits = {}

	for i = 1, #data do

		local c = data:sub(i, i)
		local pos = Alphabet:find(c, 1, true)

		if pos then
			local value = pos - 1

			for j = 5, 0, -1 do
				table.insert(bits,
					math.floor(value / 2^j) % 2
				)
			end
		end
	end

	local result = ""

	for i = 1, #bits - 7, 8 do

		local value = 0

		for j = 0, 7 do
			value += bits[i + j] * 2^(7 - j)
		end

		result ..= string.char(value)
	end

	return result
end

return Base64
