local maxHeap = require "maxHeap"

local supressPasses = ... == "true" and true or false
local tests = require "tests.baseTest"
local test = tests.test
tests.supressPasses = tests.supressPasses or supressPasses
local file = debug.getinfo(1).short_src

print("testing " .. file)

test(
	"newEmpty",
	function()
		local s = maxHeap.new()
		return #s == 0
	end
)

test(
	"newWithElements",
	function()
		local s = maxHeap.new{1,-10,0}
		return s[1] == 1 and s[2] == -10 and s[3] == 0 and not s[4]
	end
)

test(
	"insert",
	function()
		local s = maxHeap.new{5,3,1}
		s:insert(2)
		return s[1] == 5 and s[2] == 3 and s[3] == 1, s[4] == 2
	end
)

test(
	"pop/poll",
	function()
		local s = maxHeap.new{5,3,1}
		return s:pop() == 5 and s:pop() == 3 and s:pop() == 1
	end
)

test(
	"pop/poll2",
	function()
		math.randomseed(os.time())
		local randomized = {}
		local ordered = {}
		for i = 1, 1000 do
			local n = math.random(-10000, 10000)
			table.insert(randomized, n)
			table.insert(ordered, n)
		end
		table.sort(ordered)
		local s = maxHeap.new(randomized)
		for i = #s, 1, -1 do
			local pop = s:pop()
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
		local s = maxHeap.new{5,3}
		s:discard()
		s:discard()
		s:discard()
		return #s == 0
	end
)

test(
	"peek",
	function()
		return maxHeap.new{1}:peek() == 1
	end
)

test(
	"merge",
	function()
		local a = maxHeap.new{5, 1}
		local b = maxHeap.new{3}
		local n = a:merge(b)
		return #n == 3 and n[1] == 5
	end
)

test(
	"getLeftChildIndex",
	function()
		local h = maxHeap.new()
		return h:getLeftChildIndex(1) == 2
		and h:getLeftChildIndex(29) == 58
		and h:getLeftChildIndex(30) == 60
	end
)

test(
	"getRightChildIndex",
	function()
		local h = maxHeap.new()
		return h:getRightChildIndex(1) == 2 + 1
		and h:getRightChildIndex(29) == 58 + 1
		and h:getRightChildIndex(30) == 60 + 1
	end
)

test(
	"getParentIndex",
	function()
		local h = maxHeap.new()
		return h:getParentIndex(1) == 0
		and h:getParentIndex(29) == 14
		and h:getParentIndex(30) == 15
	end
)

test(
	"hasLeftChild",
	function()
		local h = maxHeap.new{1,2,3,4,5,6,7,8,9,0}
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
		local h = maxHeap.new{1,2,3,4,5,6,7,8,9,0}
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
		local h = maxHeap.new{1,2,3,4,5,6,7,8,9,0}
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
		local h = maxHeap.new{9,8,7,6,5,4,3,2,1}
		return h:leftChild(1) == 8
		and h:leftChild(2) == 6
		and h:leftChild(4) == 2
		and h:leftChild(5) == nil
		and h:leftChild(10) == nil
	end
)

test(
	"rightChild",
	function()
		local h = maxHeap.new{9,8,7,6,5,4,3,2,1}
		return h:rightChild(1) == 7
		and h:rightChild(2) == 5
		and h:rightChild(4) == 1
		and h:rightChild(5) == nil
		and h:rightChild(9) == nil
	end
)

test(
	"parent",
	function()
		local h = maxHeap.new{9,8,7,6,5,4,3,2,1}
		return h:parent(1) == nil
		and h:parent(4) == 8
		and h:parent(5) == 8
		and h:parent(9) == 6
		and h:parent(10) == false
	end
)

test(
	"clone",
	function()
		local h = maxHeap.new{1,2,3,4,5,6,7,8,9}
		local p = h:clone()

		for i, v in ipairs(h) do
			if p[i] ~= v then return false end
		end
		return true
	end
)

test(
	"tableNew",
	function ()
		local h = maxHeap.new({{value = 4}, {value = 2}}, function(a,b) return a.value < b.value end)
		return h[1].value == 2, h[2].value == 4
	end
)

test(
	"tablepop",
	function ()
		local h = maxHeap.new({{value = 4}, {value = 2}}, function(a,b) return a.value < b.value end)
		return h[1].value == 2, h[1].value == 4
	end
)



if not tests.supressPasses then
	tests.dump()
end
