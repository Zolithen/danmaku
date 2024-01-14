# Concepts
We use 30log for classes. The main building block is the `Node` class. Each node can have as many `children` as wanted and only up to one `parent`. These basically constitutes an scene graph: each isolated collection of nodes which are related by being children or parent is called a `tree`. A node that has no parent is called a `root` node, and each tree has exactly one root node. When we talk about the tree under a node which has a parent, we are talking about the collection of nodes under the current node. An `event` is simply a function on a node that will be called with one of the two event propagating methods. This event can return either `nil` or one of the values of the `NodeResponse` enum, these last ones will stop the event propagating to certain nodes.

# API Reference
## Node
### Fields
- `x, y : Numbers` - Position
- `parent : Node` - A node can only have one parent
- `name : String` - Useful for identifying nodes
- `uuid : String` - Useful for identifying nodes when name is not a viable option
- `child_index : Number` - Position of the node in the parent's children array
- `children : List<Node>` - Contains all the Node's for which this Node is parent
### Methods
- `init(parent : Node, name : String, x : Number, y : Number) : Node`  
-> Class constructor

- `get_root_attr(name : String) : Value`  
-> Returns a variable named `name` from the current root of the tree.

- `add(n : Node)`  
-> Adds the given node to the children list of the node. This also updates the `child_index` and `parent` variables correctly.

- `propagate_event(name : String, ... : Varargs)`  
-> Propagates the event `name` to the whole tree under the current node. Passes in to the event the arguments `...`.

- `propagate_event_reverse(name : String, ... : Varargs)`  
-> Propagates the event `name` to the whole tree under the current node, but instead of doing `ipairs` on the children list of each node, it uses an iterator `r_ipairs` which traverses the children list in reversal. Passes in to the event the arguments `...`.

- `find(cond : Function) : List<Node>`  
-> Finds all nodes under the given node (not including itself) that return `true` when passed in to the `cond` function.

- `find_name(a : String) : Node`  
-> Special case of the `find` function for when we want to find a node with the given name `a`. Returns only one `Node` or `nil` if no node was found.

- `find_name_in_children(n : String) : Node`  
-> Special case of the `find_name` function that returns the first node named `n` in the `children` list. Can return `nil`.

- `delete()`  
-> Deletes the node, updates all internals of the `parent` and also deletes all the nodes in the `children` list.

- `delete_all_children()`  
-> Deletes all the children of the node without deleting the node. Due to how `Node:delete` works, also deletes all the children of the children and so on.

- `remove_from_parent()`  
-> Removes the node from the parent's `children` list, but doesn't delete the node.

- `get_root() : Node`  
-> Gets the root of the node's tree.

### Virtual methods
These methods are not implemented on the `Node` class, but will get called if they exist on an instance when the thing listed happens.

- `on_add_children(child : Node, child_index : Number)`  
-> Called on a node when a node is added to it's `children` list.

- `on_delete()`  
-> Called when `Node:delete` has been called before actually deleting the node.

## NodeResponse
An enum to control how `Node:propagate_event` and `Node:propagate_event_reverse` iterate over the node tree.
- `stop = 1`  
-> Signifies that the event must not be propagated any further.

- `hwall = 2`  
-> Signifies that the event must not be propagated to the remaining children of the parent node, but it should be propagated to the children of the current node.

- `vwall = 3`  
-> Signifies that event must not be propagated to the children of the current node, but it should be propagated to the remaining children of the parent node.

# Examples