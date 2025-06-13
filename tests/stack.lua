local Stack = require "stack"

local supressPasses = ... == "true" and true or false
local tests = require "tests.baseTest"
local test = tests.test
tests.supressPasses = tests.supressPasses or supressPasses
local file = debug.getinfo(1).short_src

print("testing " .. file)

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
		return #s == 0
	end
)

test(
	"isNotEmpty",
	function()
		local s = Stack.new()
		s:push("HELLO")
		s:pop()
		s:push("WORLD")
		return #s ~= 0
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
		return #s == 5
	end
)


if not tests.supressPasses then
	tests.dump()
end
