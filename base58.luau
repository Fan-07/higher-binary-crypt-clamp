local Base58 = {}

local Alphabet = "123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz"

local Reverse = {}
for i = 1, #Alphabet do
	Reverse[Alphabet:sub(i, i)] = i - 1
end

local function toBytes(str)
	local bytes = {}
	for i = 1, #str do
		bytes[i] = string.byte(str, i)
	end
	return bytes
end

local function divmod(number, divisor)
	local remainder = 0
	local result = {}

	for i = 1, #number do
		local value = remainder * 256 + number[i]
		local digit = math.floor(value / divisor)
		remainder = value % divisor

		if #result > 0 or digit ~= 0 then
			table.insert(result, digit)
		end
	end

	return result, remainder
end

function Base58.Encode(data)
	local bytes = toBytes(data)

	local zeros = 0
	for i = 1, #bytes do
		if bytes[i] == 0 then
			zeros = zeros + 1
		else
			break
		end
	end

	local num = bytes
	local encoded = {}

	while #num > 0 do
		num, remainder = divmod(num, 58)
		table.insert(encoded, 1, Alphabet:sub(remainder + 1, remainder + 1))
	end

	for i = 1, zeros do
		table.insert(encoded, 1, "1")
	end

	return table.concat(encoded)
end

function Base58.Decode(data)
	local num = {0}

	local zeros = 0
	for i = 1, #data do
		if data:sub(i, i) == "1" then
			zeros = zeros + 1
		else
			break
		end
	end

	for i = 1, #data do
		local char = data:sub(i, i)
		local value = Reverse[char]

		if value == nil then
			error("Invalid Base58 character: " .. char)
		end

		local carry = value
		for j = #num, 1, -1 do
			local total = num[j] * 58 + carry
			num[j] = total % 256
			carry = math.floor(total / 256)
		end

		while carry > 0 do
			table.insert(num, 1, carry % 256)
			carry = math.floor(carry / 256)
		end
	end

	for i = 1, zeros do
		table.insert(num, 1, 0)
	end

	local result = {}
	for i = 1, #num do
		result[i] = string.char(num[i])
	end

	return table.concat(result)
end

return Base58
