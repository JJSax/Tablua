# Stack
## Overview
The Lua Stack module provides a simple and efficient implementation of a stack data structure. Stacks follow the Last-In, First-Out (LIFO) principle, making them suitable for various applications, including parsing expressions, managing function calls, and more.

## Methods

### Stack.new([input])
Creates a new instance of the Stack class.
any?: `input` Initial elements to be added to the stack.
Returns: A new Stack object.  

### stack:push(input)
Pushes any:`input` onto the stack.  

### stack:pop()
Removes and returns the top element from the stack.
Returns: The top element of the stack.

### stack:peek()
Returns the top element of the stack without removing it.
Returns: The top element of the stack.


## Example usage
```lua
local Stack = require("stack")

-- Create a new stack
local myStack = Stack.new()

-- Push elements onto the stack
myStack:push(10)
myStack:push(20)
myStack:push(30)

-- Peek at the top element
local topElement = myStack:peek() -- 30

-- Pop the top element
local poppedElement = myStack:pop() -- 30

-- Display the remaining elements
for _, element in ipairs(myStack) do
    print(element)
end
```