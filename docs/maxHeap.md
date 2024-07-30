# maxHeap Module
This Lua module provides the data structure for a maxHeap.  A maxHeap structure is designed to easily get the largest element in a list.


## Installation
You can use the module by putting the repo into your project, and require it with:
```lua
local maxHeap = require "tablua.maxHeap"
```

## Constructor

### maxHeap.new([[t], compare]):
Creates a new instance of the maxHeap class.  
If table:'*t*' is passed, they will be the initial heap values.
function:'*compare*' can be passed as the custom compare function.  Useful for table elements.  This will need to be `a > b` return; be sure not to use a less than symbol. i.e. `<`

```lua
	local h = maxHeap.new(
		{value = 4}, {value = 2}
	,
		function(a, b) return a.value > b.value end
	)
```

It is possible to define the compare function after the heap is made, but you cannot add the elements upon construction.

```lua
local h = maxHeap.new()
h.compare = function(a, b) return a.value > b.value end

-- now you can add the values.
h:insert({value = 4})
```

## Methods

### maxHeap:merge(b):
Takes elements from heap or array:`b` and combines them into an output heap.  
This will not destroy the original tables.  
Returns: A heap with all the element of `a` and the elements of `b`.  


### maxHeap:insert(element)
Add an element into the maxHeap and maintains the heap properties.  
Alias: maxHeap:add

### maxHeap:poll()
Remove an object from the maxHeap and returns it.
Alias: maxHeap:pop

### maxHeap:discard()
Discards the first items and does not return it.

### maxHeap:peek()
Returns the smallest object in heap, but doesn't remove it.

### Get relative index
Get the key of the index given
- getLeftChildIndex(parentIndex)  
- getRightChildIndex(parentIndex)  
- getParentIndex(childIndex)  

### Get boolean if child or parent exists to a known index
Returns true if that child/parent exists.
- hasLeftChild(index)
- hasRightChild(index)
- hasParent(index)

### Get values relative to a known index
Get the value of child/parent.
- leftChild(index)
- rightChild(index)
- parent(index)

### maxHeap:clone()
Copies the maxHeap and returns a new cloned maxHeap.