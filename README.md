# Tablua
## Welcome!
This Lua library provides a set of modules for common data structures, designed to simplify and enhance your Lua projects. Each module focuses on a specific data structure, making it easy to integrate and use the functionalities you need. Most users will find it convenient to require individual files, and only opt to require the whole folder when working with multiple data structures in a single file.

## Modules
### array.lua:  
Manages proper arrays in Lua.
Simplifies array operations and ensures consistent array behavior.

### queue.lua:  
Implements the queue data structure.  
Enables efficient first-in, first-out (FIFO) operations.  

### set.lua:
Provides functionality for managing sets.  
Simplifies set operations for improved code clarity.  

### stack.lua:
Implements the stack data structure.  
Facilitates last-in, first-out (LIFO) operations.  

### tablua.lua:
Extends Lua's default tables with additional functionalities.  
Enhances table operations for cleaner and more efficient code.  

### minHeap.lua:
Implements a heap data structure.
Efficiently get the smallest element from a group of items.

## Getting Started
### Installation

Clone this into your project, use a submodule or download Tablua directly.
Put it in your project at the location you like.

To use this library, you can simply require the specific module(s) you need in your Lua project.

```lua
-- Example: Require the array module
local Array = require("tablua.array")
```

If you need multiple data structures from the library in a single file, you can require the entire folder:

```lua
-- Example: Require the entire data_structures folder
local Tablua = require("tablua")
```

## Project Goal
The primary goal of this library is to provide clean and efficient implementations of common data structures in Lua. By using these modules, you can streamline your code, enhance project organization, and significantly speed up development.

Feel free to explore the documentation for each module to understand their specific functionalities and how they can benefit your projects.

## Documentation

[array.lua](docs/array.md)  
[queue.lua](docs/queue.md)  
[set.lua](docs/set.md)  
[stack.lua](docs/stack.md)  
[tablua.lua](docs/table.md)  
[minHeap.lua](docs/minHeap.md)

## Contribution

If you encounter any issues, have suggestions, or want to contribute, please feel free to open an issue or submit a pull request.

Happy coding!