# Lua-Table-Extension
## Welcome!
This is a library to extend lua's table to enable tables to work like objects, and give more premade code to speed up development.

Welcome to this Lua Table extention library Readme.  My goal of this was to make tables easier to work with and give more functions to work with.
This is still in active development, and is still a **work in progress**.
This Readme currently only applies to tableExt.  New data structures have been added since.

## Installation
Drop your [tableExt.lua](tableExt.lua?raw=1) into your project and require it directly.
```lua
require "tableExt"
```


### table.new(a)
This makes your table an object.  Making a standard table such as `x = {}` will not inherit the benefits of this library.  Use `x = table.new{}`.

This will allow all table functions, including LUA naitive functions, to use the colon operator.

`a` defaults to an empty table.
```lua
local x = table.new{1,2,3}
print(x:concat(","))
-- prints 1,2,3

-- without this you would have to use
print(table.concat(x, ","))
```

### table.isArray(a)
- This returns true if the keys of the array are ordered with no gaps, starting at 1.
- If the table has keys that are not numerical, this will return false.

`{1,2,3,4}` returns true.
`{[1] = 1, [3] = 2}` returns false; there is a gap in the keys
`{["hello"] = "world", 1,2}` returns false; there is a string key.

### table.size(a)
This gets the real size of the table.  This counts string keys, and tables that aren't ordered.  Most the time you should not use this.  I highly recommend trying to arrange your code to avoid a mismatch, and avoid an uncondensed array.  If you need, condense your table first, then use #table.

### table.swap(a)
This will swap two elements inside a table.
- Note: this will not return a new table, it swaps it directly.

```lua
local x = table.new {1,2,3}
x:swap(1,2)
-- x is now == {2,1,3}
```

### table.qclone(a)
This is a quick clone of a table.  This allows you to modify the clone without modifying the original table.  What makes this quick is it only clones one layer deep.  If you need to clone a nested table, use table.clone.

```lua
local a = table.new{1,2,3}
local b = a
b[1] = "hello"
print(a[1]) -- prints "hello", not 1 because changing b changes a too.
```
Instead qclone simple tables with qclone
```lua
local a = table.new{1,2,3}
local b = a:qclone()
b[1] = "hello"
print(a[1]) -- prints 1
print(b[1]) -- prints "hello"
```

### table.clone(a)
This works much like table.qclone, but will also clone nested tables.

```lua
local a = {1,2,3, {x = 4, y = 5} }
local b = a:clone()
b[4].x = 6

print(a[4].x) -- prints 4
print(b[4].x) -- prints 6
```

### table.join(a, ...)
Joins multiple tables together.  Numerically indexed keys will append onto `a` otherwise the rightmost table will overwrite items in tables to the left.
```lua
local x = table.new{1,2,3, hello = "you!"}
local y = table.new{4,5,6, hello = "Is this even a greeting?"}
local z = table.new{7,8,9, hello = "world"}

local new = x:join(y, z)
-- new == {1,2,3,4,5,6,7,8,9, hello = "world"}
```

### table.slice(a, start[, finish])
This will extract items from `a[start]` to `a[finish]` and return a new table object with those items.  This is inclusive of start and finish.  Finish defaults to the end of the array.
```lua
local x = table.new{1,2,3,4,5,6,7,8,9}
local y = x:slice(3,6)
-- y == {3,4,5,6}
```
```lua
local x = table.new{1,2,3,4,5,6,7,8,9}
local y = x:slice(6)
-- y == {6,7,8,9}
```

### table.splice(a, index, howmany, ...)
This function derives from javascript's [array.splice](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/splice) function.

The splice method returns a new array without `a[index]` through `a[index + howmany]`.  if `...` is provided, it will replace `a[index]` through `a[index + howmany]` with contents of `...`.  `a[index]` will remain inside the array.

```lua
	local x = {1,2,3,4,5,6,7,8,9}
	local y = table.splice(x, 3, 5)
	-- y == {1,2,3,9}
```
```lua
	local x = {1,2,3,4,5,6}
	local y = table.splice(x, 3, 1,"banana", "apple", "orange")
	--- y == {1,2,3,"banana", "apple", "orange", 5,6}
```

### table.last(a)
Simply returns the last element of an array.  'nuff said.  Can make some code easier to read.

### table.find(a, value)
Iterates over `a` to find `value` and returns the index that it was found.  This iterates over all items until it finds the item.  If your array values are in ordered, use table.binarySearch for a faster search.

### table.binarySearch(a, value)
Uses a [binary search](https://en.wikipedia.org/wiki/Binary_search_algorithm) to find value inside ordered array, `a`.  If your array is not ordered then this search may produce incorrect results.

```lua
local x = table.new{1,3,4,5,7,8,9,12,15,16,17} -- this is in order
print(x:binarySearch(12)) -- prints 8
```

### table.compare(a, b)
This will check if a and b contain exactly the same information.  This doesn't rely on the table addresses being the same.

```lua
local x = table.new{1,2,3, hello = "world"}
local y = table.new{1,2,3, hello = "world"}
print( x:compare(y) ) -- returns true
y.hello = "universe"
print( x:compare(y) ) -- returns false
```

### table.unique(a)
This will reduce the array into only their unique values.
```lua
local x = table.new{1,1,1,2,3,4,4,6,6}
local y = x:unique()
-- y = {1,2,3,4,6}
```

### table.gCondense(a[, remove])
This function will return a new array without any objects that match `remove`.  This is useful when needing to keep a tidy array without any gaps.
```lua
local x = table.new{1,2,3,4,5,6,7,8}
x[4] = nil
x = x:condense()
-- x = {1,2,3,5,6,7,8}
```

### table.condense(a[, remove])
This is experimental! This uses a technique that alters a table whilst iterating it.  This may not work exactly as intended.  It works like table.gCondense, except it condenses the table directly, without changing the table address.

I have tested it heavily in [löve2d](love2d.org) version 11.4 without any issues.
```lua
local x = table.new{1,2,3,4,5,6,7,8}
x[4] = nil
x:condense()
-- x = {1,2,3,5,6,7,8}
```

### table.every(a, test)
Iterates over the array and passes element to `test`.  It will return true if the test passes on all elements in array.
```lua
	local x = {1,2,3,4,5,6,7,8,9}
	table.every(x, function(v) return v % 2 == 0 end) -- false
```
``` lua
	local x = {1,2,3,4,5,6,7,8,9}
	table.every(x, function(v) return v > 0 end) -- true
```

### table.filter(a, test)
Returns a new array containing all elements of `a` for which the provided test returns true.
```lua
	local x = {1,2,3,4,5,6,7,8,9}
	local y = table.filter(x, function(k, v) return v < 3 end)
	-- y == {1,2}
```

### table.invert(a)
Reverses order of array `a` directly.  Retains table address.
```lua
	local x = {1,2,3,4,5}
	table.reverse(x)
	-- x = {5,4,3,2,1}
```

### table.shuffle(a)
Uses the [Fisher-Yates shuffle](https://en.wikipedia.org/wiki/Fisher%E2%80%93Yates_shuffle) to shuffle the table without changing the table address.

### table.arrayIter(a[, remove])
This is an iterator, use similar to pairs.  This condenses the array afterward using table.condense.  This comes with the same warnings as that function has.
This is useful when needing to delete things from an array, leaving no gaps.
```lua
local x = table.new{1,2,3,4,5,6,7,8,9}
for k,v in x:arrayIter() do
	if v % 2 == 1 then -- only odd values
		x[k] = nil -- cannot make v nil.  It has to directly reference x
	end
end
-- x = {2,4,6,8}
```

### table.reverse(a)
This is an iterater that will loop over the table in reverse.
```lua
local x = table.new{1,2,3,4,5,6,7,8,9}
local s = ""
for k,v in x:reverse() do
	s = s..v
end
-- s == 987654321
```
