local Table = require "Tablua"
print(_VERSION)
local history = {}
local fail = "%s test failed at line %d. Error: %s"
local succeed = "%s test successful"
local totals = {[fail] = 0, [succeed] = 0}

local function test(label, test, expect)
	if expect == nil then expect = true end
	local status, msg = pcall(test)
	local phrase = (not status or msg ~= expect) and fail or succeed
	totals[phrase] = totals[phrase] + 1
	table.insert(history,
		string.format(phrase, label, debug.getinfo(2).currentline, msg)
	)
end

test(
	"isArray_true",
	function()
		return Table.isArray{1,2,3}
	end,
	true
)

test(
	"isArray_false",
	function()
		return not Table.isArray{['x'] = 5, 1,2,3}
	end
)

test(
	"tableSize1",
	function()
		return Table.size{['x'] = 5, 1,2,3}
	end,
	4
)

test(
	"tableSize2",
	function()
		return Table.size{1,2,3}
	end,
	3
)

test(
	"swap1",
	function()
		local x = {1,2,3}
		Table.swap(x, 1, 2)
		return x[1] == 2 and x[2] == 1 and x[3] == 3
	end,
	true
)

test(
	"swap2",
	function()
		local x = {a = 1, b = 2,3}
		Table.swap(x, "a", "b")
		return x.a == 2 and x.b == 1 and x[1] == 3
	end,
	true
)

test(
	"qclone1",
	function()
		local x = {1,2,3}
		local y = Table.qclone(x)
		return x ~= y and x[1] == y[1] and x[2] == y[2] and x[3] == y[3]
	end,
	true
)

test(
	"qclone2",
	function()
		local x = {1,2,3}
		local y = Table.qclone(x)
		y[1] = 4
		return x ~= y and x[1] == y[1] and x[2] == y[2] and x[3] == y[3]
	end,
	false
)

test(
	"clone1",
	function()
		local x = {1,2,3}
		local y = Table.clone(x)
		return x ~= y and x[1] == y[1] and x[2] == y[2] and x[3] == y[3]
	end
)

test(
	"clone2",
	function()
		local x = {1,2,{3,4}}
		local y = Table.clone(x)
		return  x ~= y and x[1] == y[1] and x[2] == y[2] and
				x[3][1] == y[3][1] and x[3][2] == y[3][2]
	end,
	true
)

test(
	"join1",
	function()
		local x = {1,2,3}
		local y = Table.join(x, {4,5,6})
		return x ~= y and x[1] == y[1] and x[2] == y[2] and x[3] == y[3] and
				y[4] == 4 and y[5] == 5 and y[6] == 6
	end,
	true
)

test(
	"join2",
	function()
		local x = Table.new{1,2,3}
		local y = Table.join(x, {4,5,6}, {7,8,9})
		return x ~= y and x[1] == y[1] and x[2] == y[2] and x[3] == y[3] and
				y[4] == 4 and y[5] == 5 and y[6] == 6 and
				y[7] == 7 and y[8] == 8 and y[9] == 9
	end,
	true
)

test(
	"slice",
	function()
		local x = {1,2,3,4,5,6,7,8,9}
		local y = Table.slice(x, 3, 6)
		return y[1] == 3 and y[2] == 4 and y[3] == 5 and y[4] == 6
	end,
	true
)

test(
	"slice2",
	function()
		local x = {1,2,3,4,5,6}
		local y = Table.slice(x, 3)
		return y[1] == 3 and y[2] == 4 and y[3] == 5 and y[4] == 6
	end,
	true
)

test(
	"splice1",
	function()
		local x = {1,2,3,4,5,6,7,8,9}
		local y = Table.splice(x, 3, 5)
		return y[1] == 1 and y[2] == 2 and y[3] == 3 and y[4] == 9
	end,
	true
)

test(
	"splice2",
	function()
		local x = {1,2,3,4,5,6}
		local y = Table.splice(x, 3, 1,"banana", "apple", "orange")
		return y[1] == 1
		and y[2] == 2
		and y[3] == 3
		and y[4] == "banana"
		and y[5] == "apple"
		and y[6] == "orange"
		and y[7] == 5
		and y[8] == 6
	end,
	true
)

test(
	"choice1",
	function()
		-- there is a 0.00000000001% chance this will choose the same choice all 11 times
		-- if that happens this will be a false negative
		math.randomseed(os.time())
		local x = {0,1,2,3,4,5,6,7,8,9}

		local firstChoice = Table.choice(x)
		for i = 1, 10 do
			local secondChoice = Table.choice(x)
			if firstChoice ~= secondChoice then
				return true
			end
		end

		return false
	end,
	true
)

-- currently no monkey test for choices method.

test(
	"find1",
	function()
		local x = {1,2,3,4,5,6,7,8,9}
		return Table.find(x, 3) == 3
	end,
	true
)

test(
	"find2",
	function()
		local x = {4,2,1,5,8,7,6,9,3}
		return Table.find(x, 3) == 9
	end,
	true
)

test(
	"binarySearch1",
	function()
		local x = {1,2,4,5,6,7,8,9,11,12,14,15}
		return Table.binarySearch(x, 11) == 9
	end,
	true
)

test(
	"binarySearch2",
	function()
		local x = {1,2,4,5,6,7,8,9,11,12,13,14,15}
		return Table.binarySearch(x, 1) == 1
	end,
	true
)

test(
	"binarySearch3",
	function()
		local x = {1,2,4,5,6,7,8,9,11,12,13,14,15}
		return Table.binarySearch(x, 12) == 10
	end,
	true
)

test(
	"unique",
	function()
		local x = {1,1,5,6,7,7,8,4,7,9}
		local y = Table.unique(x)
		return y[1] == 1 and y[2] == 5 and y[3] == 6 and y[4] == 7
			and y[5] == 8 and y[6] == 4 and y[7] == 9
	end,
	true
)

test(
	"gCondense1",
	function()
		local x = {1,2,nil,4,5,nil,7,8,9}
		local y = Table.gCondense(x)
		return y[1] == 1 and y[2] == 2 and y[3] == 4 and y[4] == 5
			and y[5] == 7 and y[6] == 8 and y[7] == 9
	end,
	true
)

test(
	"gCondense2",
	function()
		local x = {false,2,false,4,5,false,7,8,9}
		local y = Table.gCondense(x, false)
		return y[1] == 2 and y[2] == 4 and y[3] == 5 and y[4] == 7
			and y[5] == 8 and y[6] == 9
	end,
	true
)

test(
	"condense",
	function()
		local x = {}
		for i = 1, 30 do x[i] = i % 2 == 0 and i or nil end
		Table.condense(x)
		if #x ~= 15 then return false end
		for k,v in ipairs(x) do
			if type(v) ~= "number" then return false end
		end
		return true
	end,
	true
)

test(
	"every1",
	function()
		local x = {1,2,3,4,5,6,7,8,9}
		return Table.every(x, function(v) return v % 2 == 0 end)
	end,
	false
)

test(
	"every2",
	function()
		local x = {1,2,3,4,5,6,7,8,9}
		return Table.every(x, function(v) return type(v) == "number" end)
	end,
	true
)

test(
	"every3",
	function()
		local x = {"test", 1,2,3,4,5,6,7,8,9}
		return Table.every(x, function(v) return type(v) == "number" end)
	end,
	false
)

test(
	"filter1",
	function()
		local x = {1,2,3,4,5,6,7,8,9}
		local y = Table.filter(x, function(k, v) return v < 3 end)
		return y[1] == 1 and y[2] == 2 and #y == 2
	end,
	true
)

test(
	"filter2",
	function()
		local x = {1,2,3,4,5,6,7,8,9}
		local y = Table.filter(x, function(k, v) return v > 5 end)
		return y[1] == 6 and y[2] == 7 and y[3] == 8 and y[4] == 9
	end,
	true
)

test(
	"filter3",
	function()
		local x = {1,3,5,7,9}
		local y = Table.filter(x, function(k, v) return v % 2 == 0 end)
		return #y == 0
	end,
	true
)

test(
	"invert1",
	function()
		local x = {1,2,3,4,5}
		Table.invert(x)
		return x[1] == 5 and x[2] == 4 and x[3] == 3
			and x[4] == 2 and x[5] == 1
	end,
	true
)

test(
	"invert2",
	function()
		local x = {1,2,3,4,5}
		Table.invert(x)
		return x[1] == 5 and x[2] == 4 and x[3] == 3
			and x[4] == 2 and x[5] == 1
	end,
	true
)

test(
	"shuffle",
	function()
		local x = {1,2,3,4,5}
		Table.shuffle(x)
		return x[1] ~= 1 or x[2] ~= 2 or x[3] ~= 3 or x[4] ~= 4 or x[5] ~= 5
	end,
	true
)

test(
	"arrayIter1",
	function()
		local x = {1,2,3,4,5}
		local i = 0
		for k,v in Table.arrayIter(x) do
			i = i + 1
			if i == 1 then
				if k ~= 1 or v ~= 1 then return false end
			elseif i == 2 then
				if k ~= 2 or v ~= 2 then return false end
			elseif i == 3 then
				if k ~= 3 or v ~= 3 then return false end
			elseif i == 4 then
				if k ~= 4 or v ~= 4 then return false end
			elseif i == 5 then
				if k ~= 5 or v ~= 5 then return false end
			else
				return false
			end
		end
		return i == 5
	end,
	true
)

test(
	"arrayIter2",
	function()
		local x = {1,2,3,4,5}
		for k,v in Table.arrayIter(x) do
			if k == 3 then x[k] = nil end
		end
		return #x == 4 and x[1] == 1 and x[2] == 2 and x[3] == 4 and x[4] == 5
	end,
	true
)

test(
	"reverse",
	function()
		local x = Table.new{1,2,3,4,5}
		local i = 5
		for k,v in x:reverse() do
			if i == 5 then
				if k ~= 5 or v ~= 5 then return false end
			elseif i == 4 then
				if k ~= 4 or v ~= 4 then return false end
			elseif i == 3 then
				if k ~= 3 or v ~= 3 then return false end
			elseif i == 2 then
				if k ~= 2 or v ~= 2 then return false end
			elseif i == 1 then
				if k ~= 1 or v ~= 1 then return false end
			else
				return false
			end
			i = i - 1
		end
		return true
	end,
	true
)

test(
	"compare1",
	function()
		local x = {1,2,3,4,5}
		local y = {1,2,3,4,5}
		return Table.compare(x, y)
	end,
	true
)

test(
	"compare2",
	function()
		local x = {1,2,3,4,5}
		local y = {1,2,3,4,6}
		return not Table.compare(x, y)
	end,
	true
)

test(
	"compare3",
	function()
		local x = {1,2,3,4,5}
		local y = {["x"] = 1, 1,2,3,4,6}
		return not Table.compare(x, y)
	end,
	true
)

test(
	"nonvanilla",
	function()
		local newFuncs = {
			"new", "isArray", "size", "swap",
			"qclone", "clone", "join", "slice",
			"splice", "last", "choice", "choices",
			"find", "binarySearch", "compare",
			"unique", "gCondense", "condense",
			"every", "filter", "invert", "shuffle",
			"arrayIter", "reverse"
		}

		for i, v in ipairs(newFuncs) do
			assert(not table[v], v.." should not be in lua's default table.")
		end
		return true
	end
)

for k,v in ipairs(history) do
	print(k, v)
end
print()
print(("Total Successful: %d - Total Fails: %d"):format(totals[succeed], totals[fail]))
