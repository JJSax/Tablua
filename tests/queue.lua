local queue = require "queue"

local supressPasses = ... == "true" and true or false
local tests = require "tests.baseTest"
local test = tests.test
tests.supressPasses = tests.supressPasses or supressPasses
local file = debug.getinfo(1).short_src

print("testing " .. file)

local function arraysAreEqual(x, original)
	if x == original then return true end
	for i, v in ipairs(x) do
		if original[i] ~= v then
			return false
		end
	end
	return true
end

test(
	"enqueue",
	function()
		local q = queue.new{1,2,3}
		q:enqueue(5)
		return q[1] == 1 and q[2] == 2 and q[3] == 3 and q[4] == 5
	end
)

test(
	"add",
	function()
		local q = queue.new{1,2,3}
		q:add(5)
		return q[1] == 1 and q[2] == 2 and q[3] == 3 and q[4] == 5
	end
)

test(
	"dequeue",
	function()
		local q = queue.new{1,2,3}
		q:dequeue()
		return q[1] == 2 and q[2] == 3
	end
)

test(
	"remove",
	function()
		local q = queue.new{1,2,3}
		q:dequeue()
		return q[1] == 2 and q[2] == 3
	end
)

test(
	"peek",
	function()
		local q = queue.new{1,2,3}
		return q:peek() == 1
	end
)

test(
	"front",
	function()
		local q = queue.new{1,2,3}
		return q:peek() == 1
	end
)

test(
	"sizeFromStart",
	function()
		local q = queue.new{1,2,3}
		return #q == 3
	end
)

test(
	"sizeAfterStart",
	function()
		local q = queue.new{}
		for i = 1, 3 do
			q:add(i)
		end
		return #q == 3
	end
)

test(
	"clear",
	function()
		local q = queue.new{1,2,3}
		q:clear()
		local items = false
		for k,v in ipairs(q) do
			items = true
			break
		end
		return #q == 0 and not items
	end
)

test(
	"contains",
	function()
		local q = queue.new{2,4,5,6}
		return q:contains(4)
	end
)

test(
	"not_contains",
	function()
		local q = queue.new{2,4,5,6}
		return not q:contains(1)
	end
)

test(
	"iterate",
	function()
		local q = queue.new{1,2,3,4,5,6,7}
		local it = 1
		for i,v in q:iterate() do
			if i ~= it or v ~= it then
				return false
			end
			it = it + 1
		end
		return it == #q + 1 -- account for last +1
	end
)

test(
	"clone",
	function()
		local q = queue.new{1,2,3,4,5}
		local z = q:clone()
		return q ~= z and arraysAreEqual(q, z)
	end
)

test(
	"toString",
	function()
		local q = queue.new{"this", "string"}
		return q:toString(", ") == "this, string"
	end
)

test(
	"empty",
	function()
		local q = queue.new{"this", "string"}
		return q:isEmpty() == false
	end
)

test(
	"empty2",
	function()
		local q = queue.new{}
		return q:isEmpty()
	end
)

test(
	"empty3",
	function()
		local q = queue.new { "this", "string" }
		q:dequeue()
		q:dequeue()
		return q:isEmpty()
	end
)


if not tests.supressPasses then
	tests.dump()
end
