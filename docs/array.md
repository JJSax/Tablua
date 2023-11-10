# Array module
The Array module offers a versatile set of functions designed for seamless array manipulation in Lua. It provides a range of features, including cloning, manipulation, and sorting, making it a powerful tool for working with arrays. In this context, arrays are treated as collections of elements, and the module facilitates efficient operations for various array-related tasks.

## Installation
You can use the module by putting the repo into your project, and require it with:
```lua
Array = require "tablua.array"
```

## Constructor
### array.new([t]):
Creates a new instance of the Table class.  
If table:'*t*' is passed, that will be the initial table that is used.


## Methods
All of these functions can be called with either:
```lua 
local t = Array.new()
print(t:isArray())
-- or 
print(tablua.isArray(t))
```
### array.swap(a, first, second):
Swaps two elements in the array:`a`.  
number:`first` Index of the first element to be swapped.  
number:`second` Index of the second element to be swapped.  

### array.shallowClone(a):
Creates a shallow clone of the array:`a`.  
Returns: A new array containing the same elements as `a`.  

### array.clone(a):
Creates a deep clone of the array:`a`, including nested arrays.  
Returns: A new array with cloned elements.

### array.join(a, ...)
Joins multiple arrays together with array:`a`.  
`...` (arrays): Additional arrays to join.  
Returns: A new array containing elements from all input arrays.

```lua
a = Array.new{"a"}
b = Array.new{"b"}
c = a:join(b) -- returns {"a", "b"}
```

### array.slice(a, start[, finish]):
Returns a new array from the specified range of indices in array:`a`.  
number: `start` Starting index.  
number: `finish` Ending index. If not provided, the length of `a` is used.

```lua
local a = Array.new{1,2,3,4,5,6,7,8,9}
local b = a:slice(3, 6) -- {3,4,5,6}
```

### array.splice(a, index[, howmany, ...])
Removes a range of elements from the array:`a` and inserts new elements at the specified index.  
number: `index` Index at which to start changing the array.  
number?: `howmany` Number of elements to remove. If not provided, defaults to 0.  
any?: `...` Values to insert at the specified index.

```lua
local x = Array.new{1,2,3,4,5,6,7,8,9}
local y = x:splice(3, 5) -- {1, 2, 3, 9}
```

### array.last(a):
Returns the last numerically ordered item in array: `a`.  
Returns: The last element in the array: `a`.

### array.choice(a):
Returns a random item from the array: `a`.  
Returns: A randomly selected element.

```lua
local x = Array.new{1,2,3,4,5,6,7,8,9}
print(x:choice()) -- prints a random value; 1-9.
```

### array.choices(a, count):
Returns a specified number of random items from the array: `a`.  
number: `count` Number of elements to return.  
Returns: A new array containing randomly selected elements.
```lua
local x = Array.new{1,2,3,4,5,6,7,8,9}
local c = x:choices(3) -- random values {4,9,1}
```


### array.find(a, value):
Searches the array: `a` for a value and returns its index.  
any: `value` Value to search for.  
Returns: The index of the value, or nil if not found.

```lua
local a = Array.new{2,4,6,8,10}
print(a:find(4)) -- prints 2
```

### array.binarySearch(a, value):
Searches a *sorted* array:`a` for a value using binary search and returns its index.  
This tends to be faster than find.  
array:`a` must be sorted.  
any:`value` Value to search for.  
Returns: The index of the value, or nil if not found.

```lua
local a = Array.new{1,2,3,4,5,6,7,8,9,10} -- note: the contents are ordered
print(a:binarySearch(3)) -- prints 3 for index 3
```

This will not work as the contents need to be in order.
```lua
local a = Array.new{10,12,54,2,7,6,92,7,324,19}
```

### array.compare(a, b):
Compares array:`a` and array:`b` and returns true if they are the same.  
Returns: true if arrays are equal, false otherwise.

```lua
local a = Array.new{"hello", "world"}
local b = Array.new{"hello", "world"}
local c = Array.new{"hello", "there"}
print(a:compare(b)) -- prints true
print(a == b) -- prints false, as they don't share their address.
print(a:compare(c)) -- prints false
```

### array.unique(a):
Reduces the array:`a` to its unique values.  
Returns: A new array containing unique values.

```lua
local a = Array.new{3,1,2,3,3,4,5,5,8,5,5,6,7}
local b = a:unique() -- {1,2,3,4,5,6,7}
```

### array.gCondense(a, remove):
Removes all elements in the array:`a` that match a specified value.  
any?: `remove` Value to remove.  
Returns: A new array with the matching elements removed.

```lua
local a = Array.new{1,2,3,4,5}
a[3] = nil
local b = a:gCondense() -- {1,2,4,5}
print(a == b) -- false, as it's a new array
```

### array.condense(a, remove):
Condenses the array:`a` by removing all elements that match a specified value.  
any?: `remove` Value to remove.

```lua
local a = Array.new{1,2,3,4,5}
a[3] = nil
a:condense() -- {1,2,4,5}, no need to say x = a:condense()
```

### array.every(a, test):
Returns true if every element in the array:`a` satisfies the testing function.  
function: `test` Testing function.  
Returns: true if all elements pass the test, false otherwise.

```lua
t = Array.new{1,2,3,4,5}
print(
	t:every(function(e) return type(e) == "number" end)
) -- true since all are numbers
```

### array.filter(a, test):
Returns a new array with elements from array:`a` that satisfies a `test` function.  
function: `test` Filtering function.  
Returns: A new array with filtered elements.

```lua
local a = Array.new{1,2,3,4,5,6,7,8,9,10}
local b = a:filter(function(e) return e <= 5 end) -- {1,2,3,4,5}
```

### array.invert(a):
Reverses the order of number keyed elements in the array:`a`.  

```lua
local a = Array.new{1,2,3,4,5,6,7,8,9,10}
a:invert() -- {10,9,8,7,6,5,4,3,2,1}
```

### array.shuffle(a):
Shuffles the elements in the array:`a` using the Fisher-Yates Shuffle algorithm.  

```lua 
local a = Array.new{1,2,3,4,5}
a:shuffle() -- randomized {2,1,5,3,4}
```

### array.iterate(a, remove):
Custom iterator that returns each item in the array:`a` for modification.  
This works only with numerically ordered keys, skipping other keys.  
Upon completion, it removes specified items efficiently.  
any: `remove` Value to remove.

Use Case - Bullet and Player Interaction
Consider a scenario where an array (bullets) contains bullet objects, and you want to check for collisions with a player object and remove the bullets upon collision. Using a conventional loop (ipairs), you might encounter issues:
```lua
local bullets = Array.new{}
-- lets imagine bullets is filled with bullet objects.
local player = player.new() -- imagine a player obect
for k,v in ipairs(bullets) do
	if v.collidesWith(player) then
		bullets[k] = nil -- This causes problems.
	end
end
```
#### The Problem
The above code attempts to remove bullets that collide with the player using bullets[k] = nil. However, this method leaves a hole in the array, disrupting the order and potentially causing unintended side effects. Additionally, relying on ipairs introduces complications when removing elements during iteration.

#### The Solution
```lua
local bullets = Array.new{}
-- Imagine bullets is filled with bullet objects.
local player = player.new() -- Imagine a player object

for k, bullet in array.iterate(bullets, false) do
    if bullet.collidesWith(player) then
        -- despawn bullet
		bullets[k] = false -- match with second argument in iterate.
    end
end
-- At this point in the code, bullets is a fully valid array, without holes.
```


### array.reverse(a):
Iterator that iterates backward through the array:`a`.  
```lua
local a = Array.new{1,2,3,4,5,6,7,8,9,10}
for i, v in a:reverse(5) do
	print(v) -- prints in this order. 10,9,8,7,6,5,4,3,2,1
end
```

### array.mipairs(a, mi)
An iterator that wraps back to the start of array:`a` to complete the iteration. Works like ipairs but allows starting from the middle.
integer: `mi` the index to start iteration at.

```lua
local a = Array.new{1,2,3,4,5,6,7,8,9,10}
for i, v in a:iterate(5) do
	print(v) -- prints in this order. 5,6,7,8,9,10,1,2,3,4
end
```