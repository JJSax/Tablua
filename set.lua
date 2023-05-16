

local Set = {}
Set.__index = Set

function Set.new(start)
	local self = setmetatable({}, Set)
	for k, v in ipairs(start or {}) do
		self[v] = true
	end
	return self
end

function Set:add(key)
	if key == nil then return end
	self[key] = true
end

function Set:remove(key)
	if key == nil then return end
	self[key] = nil
end

 --? how can I cache this?
 --? caching outside will waste memory
 --? caching inside set will utilize a namespace
function Set:size()
	local s = 0
	for k,v in pairs(self) do s = s + 1 end
	return s
end

return Set