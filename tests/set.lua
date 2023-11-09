local Set = require "set"
print(_VERSION)
local history = {}
local fail = "%s test failed at line %d. Error: %s"
local succeed = "%s test successful"
local totals = {[fail] = 0, [succeed] = 0}

local function test(label, test, expect)
	expect = expect == nil and true or expect
	local status, msg = pcall(test)
	local phrase = (not status or msg ~= expect) and fail or succeed
	totals[phrase] = totals[phrase] + 1
	table.insert(history,
		string.format(phrase, label, debug.getinfo(2).currentline, msg)
	)
end

test(
	"newEmpty",
	function()
		local s = Set.new()
		return type(s) == "table" and s:size() == 0
	end
)

test(
	"newPopulated",
	function()
		local s = Set.new{1, 2, 3, "a", "b", "c"}
		return s:size() == 6
	end
)

test(
	"add",
	function()
		local s = Set.new()
		s:add("HELLO")
		return s["HELLO"]
	end
)

test(
	"add2",
	function()
		local s = Set.new()
		s:add("HELLO")
		s:add("HELLO")
		s:add("HELLO")
		return s["HELLO"] and s:size() == 1
	end
)

test(
	"padd",
	function()
		local s = Set.new()
		s:padd{1, 2, 3, "a", "b", "c"}
		return s:size() == 6
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
	"remove2",
	function()
		local s = Set.new{1,2,3,4,5,6}
		if s:size() ~= 6 then return false end
		s:remove(1)
		s:remove(3)
		s:remove(5)
		s:remove(5)
		s:remove(5)
		if s:size() ~= 3 then return false end
		return true
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
	"list",
	function()
		local s = Set.new{1,2,3,"a", "b", "c"}
		s:remove("c") -- ensure removing doesn't cause issues
		local control = {
			[1] = true,
			[2] = true,
			[3] = true,
			a = true,
			b = true
		}

		local l = s:list()
		for i, v in ipairs(l) do
			if not control[v] then return false end
			control[v] = false
		end
		for k,v in pairs(control) do
			if v then return false end
		end
		return true
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

test(
	"iterator",
	function ()
		local s = Set.new()
		local t = {}
		for i = 1, 20 do
			s:add(i)
			t[i] = true
		end

		for k in s:iter() do
			if type(k) == "table" then return false end
			t[k] = false
		end

		local total = 0
		for k,v in pairs(t) do
			if v then return false end
		end
		return true
	end
)





for k,v in ipairs(history) do
	print(k, v)
end
print()
print(("Total Successful: %d - Total Fails: %d"):format(totals[succeed], totals[fail]))
