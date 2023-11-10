# Table Module
This Lua module provides additional functionalities for working with tables. It extends the default table operations and includes utility functions for common tasks.


## Installation
You can use the module by putting the repo into your project, and require it with:
```lua
tablua = require "tablua.tablua"
```

## Constructor

### Table.new([t]):
Creates a new instance of the Table class.  
If table:'*t*' is passed, that will be the initial table that is used.

## Methods
All of these functions can be called with either:
```lua 
local t = tablua.new()
print(t:isArray())
-- or 
print(tablua.isArray(t))
```
### Table.isArray(a):
Checks if the table:`a` is an ordered array.  
Returns: true if `a` is an array, false otherwise. 

### Table.size(a):
Returns the size of the table:`a`, considering both array and non-array elements.  
Returns: The full size of the `a`.

### Table.swap(a, first, second):
Swaps two elements in the table:`a`.  
number:`first` Index of the first element to be swapped.  
number:`second` Index of the second element to be swapped.  

### Table.shallowClone(a):
Creates a shallow clone of the table:`a`.  
Returns: A new table containing the same elements as `a`.  

### Table.clone(a):
Creates a deep clone of the table:`a`, including nested tables.  
Returns: A new table with cloned elements.

### Table.join(a, ...)
Joins multiple tables together with table:`a`.  
`...` (tables): Additional tables to join.  
Returns: A new table containing elements from all input tables.

```lua
a = tablua.new{"a"}
b = tablua.new{"b"}
c = a:join(b) -- returns {"a", "b"}
```

### Table.slice(a, start[, finish]):
Returns a new array from the specified range of indices in table:`a`.  
number: `start` Starting index.  
number: `finish` Ending index. If not provided, the length of `a` is used.

```lua
local a = tablua.new{1,2,3,4,5,6,7,8,9}
local b = a:slice(3, 6) -- {3,4,5,6}
```

### Table.splice(a, index[, howmany, ...])
Removes a range of elements from the table:`a` and inserts new elements at the specified index.  
number: `index` Index at which to start changing the table.  
number?: `howmany` Number of elements to remove. If not provided, defaults to 0.  
any?: `...` Values to insert at the specified index.

```lua
local x = tablua.new{1,2,3,4,5,6,7,8,9}
local y = x:splice(3, 5) -- {1, 2, 3, 9}
```

### Table.last(a):
Returns the last numerically ordered item in table: `a`.  
Returns: The last element in the table: `a`.

### Table.choice(a):
Returns a random item from the table: `a`.  
Returns: A randomly selected element.

### Table.choices(a, count):
Returns a specified number of random items from the table: `a`.  
number: `count` Number of elements to return.  
Returns: A new table containing randomly selected elements.

### Table.find(a, value):
Searches the table: `a` for a value and returns its index.  
any: `value` Value to search for.  
Returns: The index of the value, or nil if not found.

```lua
local a = tablua.new{2,4,6,8,10}
print(a:find(4)) -- prints 2
```

### Table.binarySearch(a, value):
Searches a *sorted* table:`a` for a value using binary search and returns its index.  
This tends to be faster than find.  
table:`a` must be sorted.  
any:`value` Value to search for.  
Returns: The index of the value, or nil if not found.

```lua
local a = tablua.new{1,2,3,4,5,6,7,8,9,10} -- note: the contents are ordered
print(a:binarySearch(3)) -- prints 3 for index 3
```

This will not work as the contents need to be in order.
```lua
local a = tablua.new{10,12,54,2,7,6,92,7,324,19}
```

### Table.compare(a, b):
Compares table:`a` and table:`b` and returns true if they are the same.  
Returns: true if tables are equal, false otherwise.

```lua
local a = tablua.new{"hello", "world"}
local b = tablua.new{"hello", "world"}
local c = tablua.new{"hello", "there"}
print(a:compare(b)) -- prints true
print(a:compare(c)) -- prints false
```

### Table.unique(a):
Reduces the table:`a` to its unique values.  
Returns: A new table containing unique values.

```lua
local a = tablua.new{1,2,3,3,4,5,5,5,5,6,7}
local b = a:unique() -- {1,2,3,4,5,6,7}
```

### Table.gCondense(a, remove):
Removes all elements in the array:`a` that match a specified value.  
any?: `remove` Value to remove.  
Returns: A new table with the matching elements removed.

```lua
local a = tablua.new{1,2,3,4,5}
a[3] = nil
local b = a:gCondense() -- {1,2,4,5}
print(a == b) -- false, as it's a new table
```

### Table.condense(a, remove):
Condenses the table:`a` by removing all elements that match a specified value.  
any?: `remove` Value to remove.

```lua
local a = tablua.new{1,2,3,4,5}
a[3] = nil
a:gCondense() -- {1,2,4,5}, no need to say x = a:gCondense()
```

### Table.every(a, test):
Returns true if every element in the table:`a` satisfies the testing function.  
function: `test` Testing function.  
Returns: true if all elements pass the test, false otherwise.

```lua
t = tablua.new{1,2,3,4,5}
print(
	t:every(function(e) return type(e) == "number" end)
) -- true since all are numbers
```

### Table.filter(a, test):
Returns a new array with elements from table:`a` that satisfies a `test` function.  
function: `test` Filtering function.  
Returns: A new table with filtered elements.

```lua
local a = tablua.new{1,2,3,4,5,6,7,8,9,10}
local b = a:filter(function(e) return e <= 5 end) -- {1,2,3,4,5}
```

### Table.invert(a):
Reverses the order of number keyed elements in the table:`a`.  

```lua
local a = tablua.new{1,2,3,4,5,6,7,8,9,10}
a:invert() -- {10,9,8,7,6,5,4,3,2,1}
```

### Table.shuffle(a):
Shuffles the elements in the table:`a` using the Fisher-Yates Shuffle algorithm.  

```lua 
local a = tablua.new{1,2,3,4,5}
a:shuffle() -- randomized {2,1,5,3,4}
```

### Table.arrayIter(a, remove):
Custom iterator that returns each item in the table:`a` for modification.  
This works only with numerically ordered keys, skipping other keys.  
Upon completion, it removes specified items efficiently.  
any: `remove` Value to remove.

### Table.reverse(a):
Iterator that iterates backward through the array:`a`.  