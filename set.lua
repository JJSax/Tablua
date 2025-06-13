
---@class Set
local Set = {}
Set.__extVersion = "0.0.8"
Set.__index = Set
local setsize = {} -- use in key of the set to store it's size.

---@return Set
function Set.new(keys)
	local self = setmetatable({[setsize] = 0}, Set)
	self:padd(keys)
	return self
end

function Set:add(key)
	assert(key ~= setsize, "Attempt to use protected key.")
	if key == nil or self[key] then return end
	self[setsize] = self[setsize] + 1
	self[key] = true
end

function Set:padd(keys)
	if keys == nil then return end
	for _, v in ipairs(keys) do self:add(v) end
end

function Set:remove(key)
	assert(key ~= setsize, "Attempt to use protected key.")
	if key == nil or not self[key] then return end
	self[setsize] = self[setsize] - 1
	self[key] = nil
end

function Set:toggle(key)
	assert(key ~= setsize, "Attempt to use protected key.")
	local sz, to = 1, true ---@type number,boolean|nil
	if self[key] then
		sz, to = -1, nil
	end
	self[key] = to
	self[setsize] = self[setsize] + sz
end

function Set:list()
	local out = {}
	for k in pairs(self) do
		if k ~= setsize then
			table.insert(out, k)
		end
	end
	return out
end

function Set:clone()
	local out = {}
	for k,v in pairs(self) do
		out[k] = v
	end
	return setmetatable(out, Set)
end

function Set:iter()
	local key
	return function()
		key = next(self, key)
		if key == setsize then key = next(self, key) end
		return key
	end
end

function Set:union(other)
	for k in pairs(other) do
		self[k] = true
	end
end

function Set:difference(other)
	local clone = self:clone()
	for k in other:iter() do
		if clone[k] then
			clone:remove(k)
		else
			clone:add(k)
		end
	end
	return clone
end

function Set:intersection(other)
	local out = Set.new()
	for k in self:iter() do
		if other[k] then
			out:add(k)
		end
	end
	return out
end

function Set:joint(b)
	for k in self:iter() do
		if b[k] then return true end
	end
	return false
end

function Set:isSubset(b)
	for k in self:iter() do
		if not b[k] then return false end
	end
	return true
end

function Set:isSuperset(b)
	for k in b:iter() do
		if not self[k] then return false end
	end
	return true
end

function Set:__sub(other)
	return self:difference(other)
end

function Set:__len()
	return self[setsize]
end

function Set:__eq(other)
	if other[setsize] and #other ~= #self then return false end

	for k in self:iter() do
		if not other[k] then
			return false
		end
	end
	return true
end

return Set