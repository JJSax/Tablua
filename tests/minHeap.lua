local minHeap = require "minHeap"
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
		local s = minHeap.new()
		return #s == 0
	end
)

test(
	"newWithElements",
	function()
		local s = minHeap.new{1,-10,0}
		return s[1] == -10 and s[2] == 1 and s[3] == 0 and not s[4]
	end
)

test(
	"insert",
	function()
		local s = minHeap.new{5,3,1}
		s:insert(2)
		return s[1] == 1 and s[2] == 2 and s[3] == 3 and s[4] == 5
	end
)

test(
	"insert2",
	function()
		local s = minHeap.new{5,3,1}
		s:insert(1)
		return s[1] == 1 and s[2] == 1 and s[3] == 3 and s[4] == 5
	end
)

test(
	"pop/poll",
	function()
		local s = minHeap.new{5,3,1}
		local o = s:pop()
		return s[1] == 3 and s[2] == 5 and o == 1
	end
)

test(
	"pop/poll2",
	function()
		-- math.randomseed(os.time())
		local randomized = {}
		local ordered = {}
		for i = 1, 1000 do
			local n = math.random(-10000, 10000)
			table.insert(randomized, n)
			table.insert(ordered, n)
		end
		table.sort(ordered)
		-- print(table.concat(ordered, ": "))
		local s = minHeap.new(randomized)
		for i = 1, #s do
			local pop = s:pop()
			-- print(pop, ordered[i])
			if pop ~= ordered[i] then
				return false
			end
		end
		return true
	end
)

test(
	"over pop",
	function()
		local s = minHeap.new{5,3}
		s:discard()
		s:discard()
		s:discard()
		return #s == 0
	end
)

test(
	"peek",
	function()
		return minHeap.new{1}:peek() == 1
	end
)

test(
	"merge",
	function()
		local a = minHeap.new{5, 1}
		local b = minHeap.new{3}
		local n = a:merge(b)
		return #n == 3 and n[1] == 1
	end
)

test(
	"getLeftChildIndex",
	function()
		local h = minHeap.new()
		return h:getLeftChildIndex(1) == 2
		and h:getLeftChildIndex(29) == 58
		and h:getLeftChildIndex(30) == 60
	end
)

test(
	"getRightChildIndex",
	function()
		local h = minHeap.new()
		return h:getRightChildIndex(1) == 2 + 1
		and h:getRightChildIndex(29) == 58 + 1
		and h:getRightChildIndex(30) == 60 + 1
	end
)

test(
	"getParentIndex",
	function()
		local h = minHeap.new()
		return h:getParentIndex(1) == 0
		and h:getParentIndex(29) == 14
		and h:getParentIndex(30) == 15
	end
)

test(
	"hasLeftChild",
	function()
		local h = minHeap.new{1,2,3,4,5,6,7,8,9,0}
		return h:hasLeftChild(1) == true
		and h:hasLeftChild(29) == false
		and h:hasLeftChild(10) == false
		and h:hasLeftChild(5) == true
		and h:hasLeftChild(6) == false
	end
)

test(
	"hasRightChild",
	function()
		local h = minHeap.new{1,2,3,4,5,6,7,8,9,0}
		return h:hasRightChild(1) == true
		and h:hasRightChild(29) == false
		and h:hasRightChild(10) == false
		and h:hasRightChild(4) == true
		and h:hasRightChild(5) == false
	end
)

test(
	"hasParent",
	function()
		local h = minHeap.new{1,2,3,4,5,6,7,8,9,0}
		return h:hasParent(1) == false
		and h:hasParent(29) == false
		and h:hasParent(10) == true
		and h:hasParent(4) == true
		and h:hasParent(5) == true
	end
)

test(
	"leftChild",
	function()
		local h = minHeap.new{1,2,3,4,5,6,7,8,9,0}
		return h:leftChild(1) == 1
		and h:leftChild(2) == 4
		and h:leftChild(4) == 8
		and h:leftChild(5) == 5
		and h:leftChild(10) == nil
	end
)

test(
	"rightChild",
	function()
		local h = minHeap.new{1,2,3,4,5,6,7,8,9}
		return h:rightChild(1) == 3
		and h:rightChild(2) == 5
		and h:rightChild(4) == 9
		and h:rightChild(5) == nil
		and h:rightChild(9) == nil
	end
)

test(
	"parent",
	function()
		local h = minHeap.new{1,2,3,4,5,6,7,8,9}
		return h:parent(1) == nil
		and h:parent(4) == 2
		and h:parent(5) == 2
		and h:parent(9) == 4
		and h:parent(10) == false
	end
)

test(
	"clone",
	function()
		local h = minHeap.new{1,2,3,4,5,6,7,8,9}
		local p = h:clone()

		for i, v in ipairs(h) do
			if p[i] ~= v then return false end
		end
		return true
	end
)

for k,v in ipairs(history) do
	print(k, v)
end
print()
print(("Total Successful: %d - Total Fails: %d"):format(totals[succeed], totals[fail]))
