# minHeap Module
This Lua module provides the data structure for a minHeap.  A minHeap structure is designed to easily get the smallest element in a list.


## Installation
You can use the module by putting the repo into your project, and require it with:
```lua
local minHeap = require "tablua.minHeap"
```

## Constructor

### minHeap.new([t]):
Creates a new instance of the minHeap class.  
If table:'*t*' is passed, they will be the initial heap values.

## Methods

### minHeap:merge(b):
Takes elements from heap or array:`b` and combines them into an output heap.  
This will not destroy the original tables.  
Returns: A heap with all the element of `a` and the elements of `b`.  


### minHeap:insert(element)
Add an element into the minHeap and maintains the heap properties.  
Alias: minHeap:add

### minHeap:poll()
Remove an object from the minHeap and returns it.
Alias: minHeap:pop

### minHeap:discard()
Discards the first items and does not return it.

### minHeap:peek()
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

### minHeap:clone()
Copies the minHeap and returns a new cloned minHeap.