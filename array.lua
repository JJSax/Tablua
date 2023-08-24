
local array = table
array.__index = array
array.__extVersion = "0.1.55"

-- This version has not been fully tested.
-- Since it alters lua's default table namespace, use at your own risk.
-- It is very possible that this may break tables and a custom namespace will be used instead.


local function assert(condition, message, stack)
	if not condition then
		error(message, stack)
	end
end

local function assertTable(t)
	assert(type(t) == "table",
		'Parameter type needs to be of type "table".  Passed type: '..type(t), 4)
end

-------------------------------------------------

function array.new(t)
	return setmetatable(t or {}, array)
end

function array.isArray(a)

	--[[
	Returns if the table is an ordered array.
	This does iterate through all items in the table to get the count.
	]]

	assertTable(a)
	return #a == array.size(a)

end

function array.size(a)

	--[[
	Works like #table but works for tables with string keys and non sequence number keys
	If the table is an array, use #tableName
	]]

	assertTable(a)

	local count = 0
	for k,v in pairs(a) do
		count = count + 1
	end
	return count

end

function array.swap(a, first, second)

	--[[
	This will swap two elements in the table.
	]]

	assertTable(a)

	local cache = a[first]
	a[first] = a[second]
	a[second] = cache

end

function array.qclone(a)

	--[[
	This function is a simple clone.  Only meant for single layer tables and arrays.
	Passed a table with a nested table, original references to subsequent table could interfere.
	If you are unsure if you should use this function, or table.clone, use table.clone.
	]]

	assertTable(a)

	local output = {}
	for k,v in pairs(a) do
		output[k] = v
	end
	return array.new(output)

end

function array.clone(a)

	--[[
	This function will create copy of the passed table, and will clone any nested tables.
	]]

	if type(a) ~= "table" then return a end
	local output = {}
	for k, v in pairs(a) do
		if type(v) == "table" then
			output[k] = array.clone(v)
		else
			output[k] = v
		end
	end
	return array.new(output)

end

function array.join(a, ...)

	--[[
	This function will join multiple tables together.
 	Tables with string keys will set a[key] to b[key] value.
	]]

	assertTable(a)

	local output = array.clone(a)
	for i = 1, select("#", ...) do
		local t = select(i, ...)
		assertTable(t)
		for k,v in pairs(t) do
			if type(k) == "number" then
				output:insert(v)
			else
				output[k] = v
			end
		end
	end
	return array.new(output)
end

function array.slice(a, start, finish)

	--[[
	Returns a new array from a from numerical index start to finish.
	]]

	assertTable(a)

	if not finish then finish = #a end

	local out = {}
	for i = start, finish do
		if not a[i] then break end
		array.insert(out, a[i])
	end
	return array.new(out)

end

function array.splice(a, index, howmany, ...)
	--[[
	This function will remove a range of elements from a table.
	... will insert at index
	developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/splice
	]]

	assertTable(a)

	if not howmany then howmany = 0 end
	local out = {}
	for i = 1, index do
		array.insert(out, a[i])
	end
	for k,v in ipairs({...}) do
		array.insert(out, v)
	end
	for i = index + howmany + 1, #a do
		array.insert(out, a[i])
	end

	return array.new(out)
end

function array.last(a)

	--This will return the last item in a sorted array
	return a[#a]

end

function array.choice(a)

	--Returns a random item from the table.

	assert(type(a) == "table",
		"Parameter type needs to be of type 'table'.  Passed type: " .. type(a), 3)

	local choice = math.random(#a)
	return a[choice], choice

end

function array.choices(a, count)

	--Returns count number of random items from the table.

	assert(type(a) == "table",
		"Parameter type needs to be of type 'table'.  Passed type: " .. type(a), 3)

	local out = {}
	local cache = array.clone(a)
	for i = 1, count do
		local choice, key = array.choice(cache)
		array.insert(out, choice)
		array.remove(cache, key)
	end
	return array.new(out)

end

function array.find(a, value)

	--[[
	This function will search a table for a value and return the index of the value.
	If the value is not found, it will return nil.
	]]

	assertTable(a)

	for k,v in pairs(a) do
		if v == value then
			return k
		end
	end
	return nil

end

function array.binarySearch(a, value)

	--[[
	This function will search a table for a value and return the index of the value.
	If the value is not found, it will return nil.
	@Ensure a is sorted before using this function.
	]]

	assertTable(a)

	local low = 1
	local high = #a
	while low <= high do
		local mid = math.floor((low + high) / 2)
		if a[mid] == value then
			return mid
		elseif a[mid] < value then
			low = mid + 1
		else
			high = mid - 1
		end
	end
	return nil

end

function array.compare(a, b)

	--[[
	This function will compare two tables and return true if they are the same.
	]]

	assertTable(a)
	assertTable(b)

	if a == b then return true end
	if #a ~= #b then return false end

	local clone = array.clone(b)
	for k,v in pairs(a) do
		if clone[k] ~= v then
			return false
		end
		clone[k] = nil
	end

	return array.size(clone) == 0

end

function array.unique(a)

	--[[
	This will reduce a into it's unique values
	]]

	local unique = {}
	local uniqueSet = {}
	for k,v in pairs(a) do
		if not uniqueSet[v] then
			uniqueSet[v] = true
			array.insert(unique, v)
		end
	end
	return array.new(unique)

end

function array.gCondense(a, remove)

	--[[
	This will go through an array and remove all that match [remove].
	This one returns the result of this.  table.condense will set the table to the result.
	]]

	local out = {}
	for k,v in pairs(a) do
		if v ~= remove then
			array.insert(out, v)
		end
	end
	return array.new(out)

end

function array.condense(a, remove)

	--[[
	This will go through an array and remove all that match [remove].
	This one will condense table passed.  table.gCondense will return a new table.
	This will not work with tables with sparse indices (AKA tables like a = {}; a[2] = true)

	I chose to use this algorithm to preserve table address and prevent iterating
	  over the table twice.

	Credit
	https://stackoverflow.com/questions/12394841/safely-remove-items-from-an-array-table-while-iterating

	]]

	local j, n = 1, #a;
	for i = 1, n do
		if a[i] ~= remove then
			if (i ~= j) then
				-- Keep i's value, move it to j's pos.
				a[j] = a[i];
				a[i] = nil;
			end
			j = j + 1;
		else
			a[i] = nil;
		end
	end

end

function array.every(a, test)

	--[[
	Returns true if every element in this array satisfies the testing function.

	example:
	t = table.new({6,7,8})
	print(t:every(function(v) return v > 4 end)) -- returns true
		OR
	print(table.every(t, function(v) return v == 1 end)) -- returns false

	]]

	for k,v in pairs(a) do
		if not test(v) then
			return false
		end
	end
	return true

end

function array.filter(a, test)

	--[[
	Returns a new array containing all elements of the calling array
	  for which the provided filtering function returns true.
	]]

	local out = array.new()
	for k,v in pairs(a) do
		if test(k, v) then
			out:insert(v)
		end
	end
	return out

end

function array.invert(a)

	--[[
	Reverses the order of a
	]]

	for i = 1, math.floor(#a/2) do
		array.swap(a, i, #a-(i-1))
	end

end

function array.shuffle(a)

	--[[
		Implements Fisher-Yates Shuffle algorithm.
		This directly shuffles table a
	]]

	local length = #a
	while length > 1 do
		local i = math.random(1, length)
		length = length - 1

		array.swap(a, length, i)
	end

end

function array.iterate(a, remove)

	--[[
	This is a custom iterator that will return each item in the array for you to alter as needed.
	Upon finishing the iterator, it will run through and delete [remove] items safely and efficiently.
	]]

	local i = 0
	local size = #a
	return function()
		i = i + 1
		if i <= size then return i, a[i] end
		array.condense(a, remove)
	end

end

function array.reverse(a)

	--[[
	This is an iterator that iterates backwards through the array
	]]

	local i = #a+1
	return function()
		i = i - 1
		if i > 0 then
			return i, a[i]
		end
	end

end

function array.mipairs(array, mi)

	--[[
	This is an iterator that wraps back to the start to complete the iteration.
	Works like ipairs, but you can start in the middle.
	@mi is the part of the array you wish to start at.
	{1,2,3,4,5} with mi = 3 would iterate as [3,4,5,1,2]
	]]

	assert(mi <= #array and mi > 0, "Attempt to start iteration out of bounds.")
	local iterations = -1
	return function()
		iterations = iterations + 1
		if iterations < #array then
			local pos = (mi + iterations - 1) % #array + 1
			return pos, array[pos]
		end
	end

end

return array