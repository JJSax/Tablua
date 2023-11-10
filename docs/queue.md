# Queue Module
This Lua module provides the data structure for a queue.  A queue structure works like a line to get into the movies.  It works in a first in, first out way.  First element added to the queue gets out first.


## Installation
You can use the module by putting the repo into your project, and require it with:
```lua
queue = require "tablua.queue"
```

## Constructor

### queue.new([t]):
Creates a new instance of the Queue class.  
If table:'*t*' is passed, that will be the initial table that is used.

## Methods

### Table.isArray(a):
Checks if the table:`a` is an ordered array.  
Returns: true if `a` is an array, false otherwise. 


### queue:enqueue(value)
Add an object into the queue.
any: `value` The object to add.

### queue:dequeue()
Remove an object from the queue and returns it.

### queue:peek()
Returns the first object in line, but doesn't remove it.

### queue:clear()
Clears the queue.  This retains the same address as the original.  
If you don't care about retaining the same address, then create a new queue.

```lua
local queue = queue.new{1,2,3,4,5}
queue:clear() -- same table is now empty
local queue = queue.new{1,2,3,4,5}
queue = queue.new{} -- faster, but a new table
```

### queue:contains(value)
Returns true if any:`value` is found inside the queue, otherwise false.

### queue:iterate()
Returns an iterator of the queue.

### queue:clone()
Copies the queue and returns a new cloned queue.

### queue:toString(delimiter)
Works like Lua's table.concat.