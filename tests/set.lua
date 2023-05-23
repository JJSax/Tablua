local Set = require "set"
print(_VERSION)
local history = {}
local fail = "%s test failed at line %d. Error: %s"
local succeed = "%s test successful"
local totals = {[fail] = 0, [succeed] = 0}

local function test(label, test, expect)
	expect = expect or true
	local status, msg = pcall(test)
	local phrase = (not status or msg ~= expect) and fail or succeed
	totals[phrase] = totals[phrase] + 1
	table.insert(history,
		string.format(phrase, label, debug.getinfo(2).currentline, msg)
	)
end

test(
	"add",
	function()
		local s = Set.new()
		s:add("HELLO")
		return s["HELLO"]
	end
)

test(
	"remove",
	function()
		local s = Set.new()
		s:add("HELLO")
		s:remove("HELLO")
		return s["HELLO"] == nil
	end
)

test(
	"toggle",
	function()
		local tests = {
			{false, 1}, -- shouldn't happen ever
			{nil,   1},
			{true, -1}
		}

		for k, v in pairs(tests) do
			local s = Set.new()
			for i = 1, 20 do
				s:add(i)
			end

			if v[1] then
				s:add("test")
			end
			s["test"] = v[1]

			s:toggle("test")

			if s["test"] == v[1] or s:size() ~= 20 + v[2] then
				return false
			end

			return true

		end
	end

)

test(
	"size",
	function()
		local s = Set.new()
		s:add("HELLO")
		s:add("WORLD")
		return s:size() == 2
	end
)

test(
	"clone",
	function()
		local s = Set.new()
		s:add("HELLO")
		s:add("WORLD")

		local f = s:clone()

		local sKeys = {}
		for k, v in pairs(s) do
			sKeys[k] = true
		end
		for k,v in pairs(f) do
			sKeys[k] = nil
		end

		for k,v in pairs(sKeys) do
			return false
		end
		return s ~= f
	end
)





for k,v in ipairs(history) do
	print(k, v)
end
print()
print(("Total Successful: %d - Total Fails: %d"):format(totals[succeed], totals[fail]))
