---@deprecated
--[[
Copyright <2022-2023> <COPYRIGHT Jared Augerot (JJSax)>

Redistribution and use in source and binary forms, with or without modification,
are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice,
this list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright notice, this list of
conditions and the following disclaimer in the documentation and/or other materials provided with
the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR
IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR
CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER
IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT
OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
]]

table.__index = table
table.__extVersion = "0.1.51"

--! This file is depreciating!!
--! Use [library].tablua instead.
--! This one overwrites lua's table
--! Better practice is to use it locally when needed, which tablua offers

local function assert(condition, message, stack)
	if not condition then
		error(message, stack)
	end
end

local function assertTable(t)
	assert(type(t) == "table",
		"Parameter type needs to be of type \"table\".  Passed type: "..type(t), 4)
end

-------------------------------------------------

function table.new(t)
	return setmetatable(t or {}, table)
end

function table.isArray(a)

	--[[
	Returns if the table is an ordered array.
	This does iterate through all items in the table to get the count.
	]]

	assertTable(a)
	return #a == table.size(a)

end

function table.size(a)

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

function table.swap(a, first, second)

	--[[
	This will swap two elements in the table.
	]]

	assertTable(a)

	local cache = a[first]
	a[first] = a[second]
	a[second] = cache

end

function table.qclone(a)

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
	return table.new(output)

end

function table.clone(a)

	--[[
	This function will create copy of the passed table, and will clone any nested tables.
	]]

	if type(a) ~= "table" then return a end
	local output = {}
	for k, v in pairs(a) do
		if type(v) == "table" then
			output[k] = table.clone(v)
		else
			output[k] = v
		end
	end
	return table.new(output)

end

function table.join(a, ...)

	--[[
	This function will join multiple tables together.
 	Tables with string keys will set a[key] to b[key] value.
	]]

	assertTable(a)

	local output = table.clone(a)
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
	return table.new(output)
end

function table.slice(a, start, finish)

	--[[
	Returns a new array from a from numerical index start to finish.
	]]

	assertTable(a)

	if not finish then finish = #a end

	local out = {}
	for i = start, finish do
		if not a[i] then break end
		table.insert(out, a[i])
	end
	return table.new(out)

end

function table.splice(a, index, howmany, ...)
	--[[
	This function will remove a range of elements from a table.
	... will insert at index
	developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/splice
	]]

	assertTable(a)

	if not howmany then howmany = 0 end
	local out = {}
	for i = 1, index do
		table.insert(out, a[i])
	end
	for k,v in ipairs({...}) do
		table.insert(out, v)
	end
	for i = index + howmany + 1, #a do
		table.insert(out, a[i])
	end

	return table.new(out)
end

function table.last(a)

	--This will return the last item in a sorted array
	return a[#a]

end

function table.choice(a)

	--Returns a random item from the table.

	assert(type(a) == "table",
		"Parameter type needs to be of type 'table'.  Passed type: " .. type(a), 3)

	local choice = math.random(#a)
	return a[choice], choice

end

function table.choices(a, count)

	--Returns count number of random items from the table.

	assert(type(a) == "table",
		"Parameter type needs to be of type 'table'.  Passed type: " .. type(a), 3)

	local out = {}
	local cache = table.clone(a)
	for i = 1, count do
		local choice, key = table.choice(cache)
		table.insert(out, choice)
		table.remove(cache, key)
	end
	return table.new(out)

end

function table.find(a, value)

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

function table.binarySearch(a, value)

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

function table.compare(a, b)

	--[[
	This function will compare two tables and return true if they are the same.
	]]

	assertTable(a)
	assertTable(b)

	if a == b then return true end
	if #a ~= #b then return false end

	local clone = table.clone(b)
	for k,v in pairs(a) do
		if clone[k] ~= v then
			return false
		end
		clone[k] = nil
	end

	return table.size(clone) == 0

end

function table.unique(a)

	--[[
	This will reduce a into it's unique values
	]]

	local unique = {}
	local uniqueSet = {}
	for k,v in pairs(a) do
		if not uniqueSet[v] then
			uniqueSet[v] = true
			table.insert(unique, v)
		end
	end
	return table.new(unique)

end

function table.gCondense(a, remove)

	--[[
	This will go through an array and remove all that match [remove].
	This one returns the result of this.  table.condense will set the table to the result.
	]]

	local out = {}
	for k,v in pairs(a) do
		if v ~= remove then
			table.insert(out, v)
		end
	end
	return table.new(out)

end

function table.condense(a, remove)
	--[[
	This will go through an array and remove all that match [remove].
	This one will condense table passed.  table.gCondense will return a new table.
	*This will work with tables with sparse indices (AKA tables like a = {}; a[2] = true)

	I chose to use this algorithm to preserve table address and prevent iterating
	  over the table twice.
	]]

	local newTab = {}
	for k, v in pairs(a) do
		if v ~= remove then
			table.insert(newTab, v)
		end
		a[k] = nil
	end

	for k,v in pairs(newTab) do
		a[k] = v
	end


end


function table.every(a, test)

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

function table.filter(a, test)

	--[[
	Returns a new array containing all elements of the calling array
	  for which the provided filtering function returns true.
	]]

	local out = table.new()
	for k,v in pairs(a) do
		if test(k, v) then
			out:insert(v)
		end
	end
	return out

end

function table.invert(a)

	--[[
	Reverses the order of a
	]]

	for i = 1, math.floor(#a/2) do
		table.swap(a, i, #a-(i-1))
	end

end

function table.shuffle(a)

	--[[
		Implements Fisher-Yates Shuffle algorithm.
		This directly shuffles table a
	]]

	local length = #a
	while length > 1 do
		local i = math.random(1, length)
		length = length - 1

		table.swap(a, length, i)
	end

end

function table.arrayIter(a, remove)

	--[[
	This is a custom iterator that will return each item in the array for you to alter as needed.
	Upon finishing the iterator, it will run through and delete [remove] items safely and efficiently.
	]]

	local i = 0
	local size = #a
	return function()
		i = i + 1
		if i <= size then return i, a[i] end
		table.condense(a, remove)
	end

end

function table.reverse(a)

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
