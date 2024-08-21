local W, F, E, L, V, P, G = unpack((select(2, ...)))

local error = error
local strbyte = strbyte
local strfind = strfind
local strlen = strlen
local strsub = strsub
local tinsert = tinsert
local type = type
local unpack = unpack

F.Strings = {}

function F.Strings.CharBytes(s, i)
	-- argument defaults
	i = i or 1

	-- argument checking
	if type(s) ~= "string" then
		error("bad argument #1 to 'F.CharBytes' (string expected, got " .. type(s) .. ")")
	end
	if type(i) ~= "number" then
		error("bad argument #2 to 'F.CharBytes' (number expected, got " .. type(i) .. ")")
	end

	local c = strbyte(s, i)

	-- determine bytes needed for character, based on RFC 3629
	-- validate byte 1
	if c > 0 and c <= 127 then
		-- UTF8-1
		return 1
	elseif c >= 194 and c <= 223 then
		-- UTF8-2
		local c2 = strbyte(s, i + 1)

		if not c2 then
			error("UTF-8 string terminated early")
		end

		-- validate byte 2
		if c2 < 128 or c2 > 191 then
			error("Invalid UTF-8 character")
		end

		return 2
	elseif c >= 224 and c <= 239 then
		-- UTF8-3
		local c2 = strbyte(s, i + 1)
		local c3 = strbyte(s, i + 2)

		if not c2 or not c3 then
			error("UTF-8 string terminated early")
		end

		-- validate byte 2
		if c == 224 and (c2 < 160 or c2 > 191) then
			error("Invalid UTF-8 character")
		elseif c == 237 and (c2 < 128 or c2 > 159) then
			error("Invalid UTF-8 character")
		elseif c2 < 128 or c2 > 191 then
			error("Invalid UTF-8 character")
		end

		-- validate byte 3
		if c3 < 128 or c3 > 191 then
			error("Invalid UTF-8 character")
		end

		return 3
	elseif c >= 240 and c <= 244 then
		-- UTF8-4
		local c2 = strbyte(s, i + 1)
		local c3 = strbyte(s, i + 2)
		local c4 = strbyte(s, i + 3)

		if not c2 or not c3 or not c4 then
			error("UTF-8 string terminated early")
		end

		-- validate byte 2
		if c == 240 and (c2 < 144 or c2 > 191) then
			error("Invalid UTF-8 character")
		elseif c == 244 and (c2 < 128 or c2 > 143) then
			error("Invalid UTF-8 character")
		elseif c2 < 128 or c2 > 191 then
			error("Invalid UTF-8 character")
		end

		-- validate byte 3
		if c3 < 128 or c3 > 191 then
			error("Invalid UTF-8 character")
		end

		-- validate byte 4
		if c4 < 128 or c4 > 191 then
			error("Invalid UTF-8 character")
		end

		return 4
	else
		error("Invalid UTF-8 character")
	end
end

function F.Strings.Replace(s, mapping)
	-- argument checking
	if type(s) ~= "string" then
		error("bad argument #1 to 'F.Replace' (string expected, got " .. type(s) .. ")")
	end
	if type(mapping) ~= "table" then
		error("bad argument #2 to 'F.Replace' (table expected, got " .. type(mapping) .. ")")
	end

	local pos = 1
	local bytes = strlen(s)
	local charbytes
	local newstr = ""

	while pos <= bytes do
		charbytes = F.Strings.CharBytes(s, pos)
		local c = strsub(s, pos, pos + charbytes - 1)

		newstr = newstr .. (mapping[c] or c)

		pos = pos + charbytes
	end

	return newstr
end

function F.Strings.Split(subject, delimiter)
	if not subject or subject == "" then
		return {}
	end

	local length = strlen(delimiter)
	local results = {}

	local i = 0
	local j = 0

	while true do
		j = strfind(subject, delimiter, i + length)
		if strlen(subject) == i then
			break
		end

		if j == nil then
			tinsert(results, strsub(subject, i))
			break
		end

		tinsert(results, strsub(subject, i, j - 1))
		i = j + length
	end

	return unpack(results)
end
