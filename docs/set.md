

# Set Module
This Lua module provides a simple implementation of the set data structure.

A set is a way that you can


## Installation
You can use the module by putting the repo into your project, and require it with:
```lua
Set = require "tablua.set"
```

## Constructor

### Set.new([keys]):
Creates a new instance of the Set class.  
If table:'*keys*' is passed, that will be the initial keys the set will have.

## Methods
All of these functions can be called with either:

### Table.isArray(a):
Checks if the table:`a` is an ordered array.  
Returns: true if `a` is an array, false otherwise. 



### Set:add(key)
Adds a new any:`key` item to the set
```lua
local s = Set.new("a", "b", "c")
s:add("d")
```

### Set:padd(keys)
Adds multiple any:`keys` to the set

```lua
local s = Set.new()
s:padd("a", "b", "c")
```

### Set:remove(key)
Removes an any:`key` item from the set.

```lua
local s = Set.new("hello")
s:remove("hello")
print(s["hello"]) -- nil
```

### Set:toggle(key)
Toggles the key from nil/false to true and vice versa.

```lua
local s = Set.new("hello")
print(s.hello) -- true
s:toggle("hello") -- changes it to nil
s:toggle("hello") -- changes it to true
```


### Set:size()
Returns the total items in the set.

```lua
local s = Set.new("hello") -- size of 1
s:padd("world", "tablua")
print(s:size) -- prints 3
```

### Set:list()
Returns an array of all they keys.  Keys will be the values of this array.
```lua
local s = Set.new("hello", "world", "of", "worlds")
for k,v in ipairs(s:list()) do
	print(v) -- Order not guaranteed
end
-- Prints some order of keys such as..
-- "hello", "world", "worlds", "of"
```


### Set:clone()
Returns a new Set with all the same keys
```lua
local s = Set.new("hello", "world", "of", "worlds")
local t = s:clone()
```

### Set:iter()
Works like list, except it is an iterator.
```lua
local s = Set.new("sets", "are", "really", "cool")
for k in s:iter() do
	print(k) -- Order not guaranteed
end
-- Prints some order of keys such as..
-- "sets", "are", "cool", "really"
```


### Set:__len()
This is a shortcut to the size method.  It works like the vanilla way to find array sizes.
```lua
local s = Set.new("sets", "are", "really", "cool")
print(#s) -- prints 4
```


### Set:__eq(other)
This allows you to easily check if two sets contain the same keys.
```lua
local s = Set.new("sets", "are", "really", "cool")
local t = Set.new("really", "sets", "are", "cool")
local diff = Set.new("arrays", "are", "cool", "too")
print(s == t) -- prints true
print(s ~= diff) -- ~= works too.  Prints true
```
