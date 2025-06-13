local Set = require "set"
print(_VERSION)

local totalTests = 0
local passes = 0
local fails = 0
local errors = 0

local function test(name, func, expected)
	local function errorHandler(err)
		errors = errors + 1
		fails = fails + 1
		local trace = debug.traceback("", 2)
		local line = trace:match(":(%d+): in function") or "unknown"
		print(string.format("[ERROR] Test '%s' failed on line %s: %s", name, line, tostring(err)))
	end

	expected = expected or true
	totalTests = totalTests + 1
	local ok, result = xpcall(func, errorHandler)

	if ok then
		if result ~= expected then
			local info = debug.getinfo(2, "Sl")
			local line = info and info.currentline or "unknown"
			print(string.format("[FAIL] Test '%s' on line %s: expected '%s', got '%s'", name, line, tostring(expected),
				tostring(result)))
			fails = fails + 1
		else
			print(string.format("[PASS] Test '%s'", name))
			passes = passes + 1
		end
	end
end

test(
	"newEmpty",
	function()
		local s = Set.new()
		return type(s) == "table" and #s == 0
	end
)

test(
	"newPopulated",
	function()
		local s = Set.new{1, 2, 3, "a", "b", "c"}
		return #s == 6
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
		return s["HELLO"] and #s == 1
	end
)

test(
	"padd",
	function()
		local s = Set.new()
		s:padd{1, 2, 3, "a", "b", "c"}
		return #s == 6
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
		if #s ~= 6 then return false end
		s:remove(1)
		s:remove(3)
		s:remove(5)
		s:remove(5)
		s:remove(5)
		if #s ~= 3 then return false end
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

			if s["test"] == v[1] or #s ~= 20 + v[2] then
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
		return #s == 2
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
		return f == s
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

test(
	"lenOperator",
	function()
		local s = Set.new{1,2,3,"a", "b", "c"}
		return #s == 6
	end
)

test(
	"lenOperator",
	function()
		local s = Set.new{1,2,3,"a", "b", "c"}
		s:remove("c") -- ensure removing doesn't cause issues
		return #s == 5
	end
)

test(
	"eqOperator_true",
	function()
		local a = Set.new{1,2,3,"a", "b", "c"}
		local b = Set.new{1,2,3,"a", "b", "c"}
		return a == b
	end
)

test(
	"eqOperator_false",
	function()
		local a = Set.new{1,2,3,"a", "b", "c"}
		local b = Set.new{4,2,3,"a", "b", "c"}
		return a ~= b
	end
)

test(
	"union",
	function()
		local a = Set.new{"cherry", "apple", "orange"}
		local b = Set.new{"grape"}
		a:union(b)
		return a.cherry and a.apple and a.orange and a.grape
	end
)

test(
	"union2",
	function()
		local a = Set.new{"cherry", "apple", "orange"}
		local b = Set.new{"grape", "banana"}
		b:remove("banana")
		a:union(b)
		return a.cherry and a.apple and a.orange and a.grape and not a.banana
	end
)

test(
	"difference",
	function()
		local a = Set.new{"cherry", "apple", "orange"}
		local b = Set.new{"grape"}
		local c = a:difference(b)
		return c.cherry and c.apple and c.orange and c.grape
	end
)

test(
	"difference2",
	function()
		local a = Set.new{"cherry", "apple", "orange"}
		local b = Set.new{"grape", "apple"}
		local c = a:difference(b)
		return c.cherry and c.orange and c.grape
	end
)

test(
	"difference3",
	function()
		local a = Set.new{"apple", "grape"}
		local b = Set.new{"grape", "apple"}
		local c = a:difference(b)
		return not c.apple and not c.grape and #c == 0
	end
)

test(
	"intersection",
	function()
		local a = Set.new{"apple", "grape"}
		local b = Set.new{"grape", "apple"}
		local c = a:intersection(b)
		return c.apple and c.grape
	end
)

test(
	"intersection",
	function()
		local a = Set.new{"apple", "grape"}
		local b = Set.new{"grape", "apple", "orange"}
		local c = a:intersection(b)
		return c.apple and c.grape
	end
)

test(
	"intersection2",
	function()
		local a = Set.new{"apple", "grape"}
		local b = Set.new{"pineapple", "mango", "orange"}
		local c = a:intersection(b)
		return #c == 0
	end
)

test(
	"joint",
	function()
		local a = Set.new{"apple", "grape"}
		local b = Set.new{"pineapple", "mango", "orange"}
		local c = a:joint(b)
		return c == false
	end
)

test(
	"joint2",
	function()
		local a = Set.new{"apple", "grape"}
		local b = Set.new{"pineapple", "grape", "orange"}
		return a:joint(b)
	end
)

test(
	"subset",
	function()
		local a = Set.new{"apple", "grape"}
		local b = Set.new { "pineapple", "grape", "orange" }
		return not a:isSubset(b)
	end
)

test(
	"subset2",
	function()
		local a = Set.new { "grape", "apple" }
		local b = Set.new{"apple", "grape", "pineapple"}
		return a:isSubset(b)
	end
)

test(
	"subset_meta",
	function()
		local a = Set.new { "grape", "apple" }
		local b = Set.new{"apple", "grape", "pineapple"}
		return a <= b
	end
)

test(
	"superset",
	function()
		local a = Set.new{"apple", "grape"}
		local b = Set.new{"pineapple", "grape", "orange"}
		return not a:isSuperset(b)
	end
)

test(
	"superset2",
	function()
		local a = Set.new{"pineapple", "grape", "orange"}
		local b = Set.new {"orange", "grape"}
		return a:isSuperset(b)
	end
)
test(
	"superset_meta",
	function()
		local a = Set.new { "apple", "grape", "pineapple" }
		local b = Set.new { "grape", "apple" }
		return a >= b
	end
)



print("\nRESULTS:")
if fails > 0 then
	print(" -> One or more tests failed!")
else
	print(" -> All Tests Passed")
end

print("Tests ran: " .. totalTests)
print("Tests passed: " .. passes)
print("Tests failed: " .. fails)
print("Tests that errored: " .. errors)
