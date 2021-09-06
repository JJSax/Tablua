
--[[
Copyright <2021> <COPYRIGHT Jared Augerot (JJSax)>

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
table.__extVersion = "0.1.0"

-- This version has not been fully tested.
-- Since it alters lua's default table namespace, use at your own risk.
-- It is very possible that this may break tables and a custom namespace will be used instead.


local function assert(condition, message, stack)
	if not condition then
		error(message, stack)
	end
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

	assert(type(a) == "table",
		"Parameter type needs to be of type \"table\".  Passed type: "..type(a), 3)
	return #a == table.size(a)

end

function table.size(a)

	--[[
	Works like #table but works for tables with string keys and non sequence number keys
	If the table is an array, use #tableName
	]]

	assert(type(a) == "table",
		"Parameter type needs to be of type \"table\".  Passed type: "..type(a), 3)

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

	assert(type(a) == "table",
		"Parameter type needs to be of type \"table\".  Passed type: "..type(a), 3)

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

function table.join(a, b, new)

	--[[
	This function joins two tables together into new table.
	Joining two numerically indexed tables will just table.insert from b to a
	tables with string keys will set a[key] to b[key] value.
	]]

	local temp = a
	for k,v in pairs(b) do
		if type(k) == "number" then
			temp:insert(v)
		elseif type(k) == "string" then
			temp[k] = v
		end
	end
	if new then -- new dictates if it should return a new table or alter a
		return table.new(temp)
	end
	a = temp

end

function table.slice(a, start, finish)

	--[[
	Returns a new table from a from numerical index start to finish.
	]]

	assert(type(a) == "table",
		"Parameter type needs to be of type \"table\".  Passed type: "..type(a), 3)

	if not finish then
		finish = start
		start = 1
	end

	local out = {}
	for i = start, finish do
		if not a[i] then break end
		table.insert(out, a[i])
	end
	return table.new(out)

end

function table.splice(a, start, finish)

	--[[
	Change original to everything not removed from it
	return new array with all the removed items
	]]

	local out = {}
	for i = start, finish do
		table.insert(out, a[i])
		a[i] = nil
	end
	table.condense(a)
	return table.new(out)

end

function table.last(a)

	--[[
	This will return the last item in a sorted array
	]]

	return a[#a]

end

function table.first(a)

	--[[
	This will return the value at index 1.
	]]

	return a[1]

end

function table.find(a, value)

	--[[
	Searches table and returns true if the value was found
	]]

	for k,v in pairs(a) do
		if v == value then
			return k
		end
	end
	return false

end

function table.unique(a)

	--[[
	This will return unique values in a
	]]

	local unique = {}
	local uniqueSet = {}
	for k,v in pairs(a) do
		if not uniqueSet[v] then
			uniqueSet[v] = true
			table.insert(unique, v)
		end
	end
	return unique

end

function table.indexOf(a, value)

	--[[
	This will search the table/array until it finds something with the value and return that key
	]]

	for k,v in pairs(a) do
		if v == value then
			return k
		end
	end
	return false

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
	WARNING: this uses a technique that alters a table whilst iterating it.
	  I've tested this heavily, but more testing is needed to guarantee.
	  If you use this and find it's messing up your tables, open a Github issue.

	I chose to use this algorithm to preserve table address and prevent iterating
	  over the table twice.
	]]

	local nextAvailable = 1
	for k,v in pairs(a) do
		if v ~= remove then
			local cache = v
			a[k] = nil
			a[nextAvailable] = cache
			nextAvailable = nextAvailable + 1
		end
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
		if text(k, v) then
			out:insert(v)
		end
	end

end

function table.invert(a, new)

	--[[
	Sets or Returns a table that is in the reverse order of a
	]]

	for i = 1, math.floor(#a/2) do
		table.swap(a, i, #a-(i-1))
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
