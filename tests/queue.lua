local queue = require "queue"
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



for k,v in ipairs(history) do
	print(k, v)
end
print()
print(("Total Successful: %d - Total Fails: %d"):format(totals[succeed], totals[fail]))
