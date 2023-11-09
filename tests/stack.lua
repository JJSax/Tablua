local Stack = require "stack"
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
	"new",
	function()
		local s = Stack.new{1,2,3,4}
		return s[1] == 1 and s[2] == 2 and s[3] == 3 and s[4] == 4
	end
)

test(
	"push",
	function()
		local s = Stack.new{"hello"}
		s:push("world")
		return s[1] == "hello" and s[2] == "world"
	end
)

test(
	"pop",
	function()
		local s = Stack.new()
		s:push("HELLO")
		s:push("WORLD")
		local o = s:pop()
		return s[1] == "HELLO" and not s[2] and o == "WORLD"
	end
)

test(
	"peek",
	function()
		local s = Stack.new()
		s:push("HELLO")
		s:push("WORLD")
		local o = s:peek()
		return o == "WORLD"
	end
)

test(
	"isEmpty",
	function()
		local s = Stack.new()
		s:push("HELLO")
		s:pop()
		return s:isEmpty()
	end
)

test(
	"isNotEmpty",
	function()
		local s = Stack.new()
		s:push("HELLO")
		s:pop()
		s:push("WORLD")
		return not s:isEmpty()
	end
)

test(
	"getSize",
	function()
		local s = Stack.new{"a","b","c"}
		s:push("d")
		s:push("e")
		s:pop()
		s:push("g")
		return s:getSize() == 5
	end
)





for k,v in ipairs(history) do
	print(k, v)
end
print()
print(("Total Successful: %d - Total Fails: %d"):format(totals[succeed], totals[fail]))
