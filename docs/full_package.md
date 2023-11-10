
# Using full tablua

Usually you'd want to require each module individually, but if you have a file that uses several, it might be better to use this bundler.

## Initializing
```lua
local Tablua = require "path.to.tablua.folder"
-- if your file structure is 
--  main/libraries/tablua/init.lua then..
local Tablua = require "libraries.tablua"
```

## Aliasing

Each of the following show equivalencies from their respective files.

Tablua.Set = Set.new  
Tablua.Array = Array.new  
Tablua.Queue = Queue.new  
Tablua.Stack = Stack.new  
Tablua.Tablua = Tablua.new  

```lua
local mySet = Tablua.Set
local myArray = Tablua.Array
local myQueue = Tablua.Queue
local myStack = Tablua.Stack
local myTable = Tablua.Tablua
```

Each of these create a new set, array, queue etc. They are not the modules.