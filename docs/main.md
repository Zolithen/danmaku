# Introduction
**Danmaku** is a library made for GUI applications in the Löve framework. It uses my Stunenca library for a node tree based approach.
# Basics
After requiring the danmaku `gui` folder in your project, it will load all the classes to the global table, and create 3 instances: `gui`, `floatgui` and `auxgui`. These 3 objects are instances of the `Node` class and are root nodes. `gui`'s direct children are `dnkWindow`s. If you want an element to appear on screen, you should instatiate a `dnkWindow` with `gui` as it's parent and then create the element with that window as a parent or just under the window. `floatgui` is used for the floating GUI, which are elements that are on top of all the windows and don't obey any kind of window-focusing behaviour, like tooltips. `auxgui` is an utility node which is just used to store GUI elements temporalily.  
The parent class of all GUI elements even floating ones is `dnkElement`, which extends from `Node`. An element can be a holder, which means that it can have  `dnkElement` as children. An element is considered a holder if it's `is_holder` method returns `true`. Examples of holder elements are `dnkPanel` and `dnkGroup`. Examples of non-holder elements are `dnkButton` and `dnkTextInput`.  
GUI events are simple: if you want to run some function when a certain event of a certain element happens, run `dnkElement:connect` with the name of the event and the function you want to call.

# API Reference
Fields marked with `read-only` shouldn't be modified. Each class' methods list doesn't list Stunenca events, for example `draw` or `mousepressed`, as these should only be called via `Node:propagate_event` and `Node:propagate_event_reverse` in the root node. They also don't list inherited methods, except when they change signature. For ease of use, the `init` method is always included in each class' doc.

## dnkWindow
Extends from `Node`. Has box methods: `bar, main, full, expand, close, minimize`.
### Fields
- `minimizable : Bool` - WIP. Can the window be minimized? When I make it work it should control if the minimized button is on the window's bar.
- `movable : Bool` - Can the window be dragged around? This is useful setting to false if you want to make an application with a window that covers the whole screen.
- `expandable : Bool` - Can the window be resized? Controls if the resizing box appears at the bottom right corner of the window.
- `skin : Table` - WIP. Specifies the colors to be used for the window.
- `show : Bool` - Is the window visible? Do not use this: preferably put the window in the `auxgui` node.
- `w, h : Numbers <read-only>` - Width and height of the window's main area. If you want to modify them, use `dnkWindow:resize`.
- `focused : Bool <read-only>` - Is the window focused or not? If you want to change this, please use `gui:focus_window` instead.
- `minim : Bool <read-only>` - WIP. Is the window minimized? (minim bcs I can't write minimized).
- `expanding : Bool <read-only>` - Is the window being resized?
- `expand_box_size : Number <read-only>` - Stores the size of the resizing box. Modifying it is not intended, so it may work or it may not.
- `dragging : Bool <read-only>` - Is the window being dragged by the user?
- `bar_height : Number <read-only>` - Stores the height of the window's bar. Modifying it is not intended, so it may work or it may not.
- `highlight_time : Number <read-only>` - Stores how much time is left for which the window shall be highlighted. To control this, use `dnkWindow:highlight`.
- `dox, doy : Numbers <read-only>` - Variables used for dragging the window and expanding.
- `canvas : Love.Canvas <read-only>` - This canvas stores the window's main area where the elements are drawn and the window's bar. This is need to constrain the element's graphics to the window area.
- `title : String <read-only>` - The current title of the window as an string. If you want to modify this, use `dnkWindow:set_title`.
- `title_texture : Love.Text <read-only>` - Stores the title as a `Love.Text` object for drawing. If you want to modify this, use `dnkWindow:set_title`.

### Methods
- `init(parent : Node, x : Number, y : Number, w : Number, h : Number, skin : Table, name : String, title : String) : dnkWindow`  
-> Class constructor. For the window to be onscreen, `parent` should be the `gui` node. `x, y, w, h` are pretty self-explanatory, for `skin` just put `gui.Skin` as the skin system is currently not implemented, `name` is the node's name and `title` is the title that shall appear on the window's bar. 

- `resize(new_w : Number, new_h : Number)`  
-> Resizes the window to the size `(new_w, new_h)`.

- `set_title(new_t : String)`  
-> Sets the window's title to `new_t`.

- `transform_vector_raw(x : Number, y : Number) : (Number, Number)`  
-> Transforms the given vector `(x, y)` in screen coordinates to the same vector in coordinates relative to the window's top left corner. This differs from `Node:transform_vector` as this method has been modified on `dnkWindow` to return the coordinates relative to the top left corner of the window's content area.

- `highlight(secs : Number)`  
-> Adds `secs` seconds to the window's highlight timer.



## dnkElement
Extends from `Node`. Has box methods: `full`

### Fields
- `events : Table<String, List> <read-only>` - Stores the functions bound to every event in the element. Key is the name of the event. If you want to add more functions to an event, use `dnkElement:connect`.
- `content_height : Number <read-only>` - This number is used to store the maximum scroll for scrollbars. It's on the `dnkElement` class for ease of use. Only use `dnkElement:calculate_content_height` on the `dnkPanel` you want to add scroll to to modify this value.

### Methods
- `init(parent : Node, name : String, x : Number, y : Number) : dnkElement`  
-> Class constructor.

- `connect(name : String, func : Function)`  
-> Will add `func` to the list of functions called when the GUI event `name` has happened.

- `call(name : String, ... : Varargs)`  
-> Will call all the functions in the `self.events[name]` list with the arguments `...`. This is to signify that the GUI event `name` has happened.

- `get_window() : dnkWindow`  
-> Returns the current window the element is residing in. This method may not work if the element isn't on a window or the window isn't on the `gui` node.

- `set_x(x : Number)`  
-> This function sets the `x` value of the element. This should only be used if we care about `content_height`, for example on scrolling panels.

- `set_y(y : Number)`  
-> This function sets the `y` value of the element. This should only be used if we care about `content_height`, for example on scrolling panels.


## dnkCanvas
Extends from `dnkElement`. Has box methods `full`.  
Canvas on which you can draw. This class is so you can extend it, but can also be used without having a subclass. 

### Fields
- `w, h : Numbers <read-only>` - Width and height. Change with `dnkCanvas:resize`
- `canvas : Love.Canvas <read-only>` - The canvas which will be used for drawing.

### Methods
- `init(parent : Node, name : String, x : Number, y : Number, w : Number, h : Number) : dnkCanvas`  
-> Class constructor, creates a canvas at position `(x, y)` and dimensions `(w, h)`.

- `resize(w : Number, h : Number)`  
-> Releases the current `self.canvas` and creates a new canvas with dimensions `(w, h)`.

### Virtual Methods
- `canvas_draw()`  
-> This method will be called each draw call when the canvas has been set up and is used to draw on it. If you want to start with a clean canvas each frame, start by calling `lg.clear()`.



## dnkClickableArea
Extends from `dnkElement`. Has box methods `full`.  
Represents a rectangle that you can click.

### Fields
- `w, h : Numbers <read-only>` - Width and height.
- `focused : Bool <read-only>` - Stores if the mouse has pressed the area. The event `press` is only triggered if the mouse is then released on the area.

### Methods
- `init(parent : Node, name : String, x : Number, y : Number, w : Number, h : Number) : dnkClickableArea`  
-> Class constructor.

### Events
- `press(self : dnkClickableArea)`  
-> Called when the area has been pressed



## dnkGroup
Extends from `dnkElement`. Has box methods `full`. Is a holder.  
This element does nothing on it's own, it's made to make it easier to make complex elements which need more than one instance of an element: it's useful for 'grouping' things together. When an element is children of one `dnkGroup`, the coordinates turn local to that group, which makes the job easier.

### Methods
- `init(parent : Node, name : String, x : Number, y : Number) : dnkGroup`  
-> Class constructor.



## dnkImage (WIP)
Extends from `dnkElement`. Has box methods `full`.  
Shows an image on screen. WIP, as it doesn't allow for much freedom (eg. creating images in software, scaling, etc...)

### Fields
- `w, h : Numbers <read-only>` - Width and height.
- `image : Love.Image <read-only>` - Image to show. Modify with `dnkImage:set_path`.

### Methods
- `init(parent : Node, name : String, x : Number, y : Number) : dnkImage`  
-> Class constructor.

- `set_image(path : String) : dnkImage`  
-> Loads the image in `path` and sets it as the image to be shown. Returns `self`.



## dnkCheckbox
Extends from `dnkElement`. Has box methods `full`.  
Represents a simple checkbox.

### Fields
- `on : Bool` - Represents if the checkbox has been checked or not.
- `focused : Bool <read-only>`

### Methods
- `init(parent : Node, name : String, x : Number, y : Number) : dnkCheckbox`  
-> Class constructor.

### Events
- `press(self : dnkCheckbox)`  
-> Called when the checkbox has pressed and so it has changed state.



## dnkPanel
Extends from `dnkElement`. Has box methods `full`. Is a holder.  
A panel is like a window inside a window, but can't be moved. This is similar to a `dnkGroup`, but provides visual cues about the elements being together in a collection, like a border around the panel. With this element you can make scrolling, for example.

### Fields
- `border : Bool` - Should the border of the panel be shown?
- `transx, transy : Number` - Amount for which to move the origin when drawing on the canvas.
- `w, h : Numbers <read-only>` - Width and height.
- `canvas : Love.Canvas <read-only>`
- `focused : Bool <read-only>`

### Methods
- `init(parent : Node, name : String, x : Number, y : Number, w : Number, h : Number) : dnkPanel`  
-> Class constructor.

- `resize(new_w : Number, new_h : Number)`  
-> Resizes the panel to dimensions `(new_w, new_h)`.



## dnkSlider
Extends from `dnkElement`. Has box methods `full`, `slider`.  
A simple slider which can work horizontally, vertically or both.

### Fields
- `w, h : Numbers` - Width and height.
- `boxw, boxh : Numbers` - Dimensions of the box inside the slider.
- `go_to_click : Bool` - If when clicking inside the slider, if we have not clicked the box make the box instantly go there. WIP.
- `boxx, boxy : Numbers <read-only>` - Position of the box inside the slider. Use `dnkSlider:instant_move` to modify these.
- `last_boxx, last_boxy : Numbers <read-only>`
- `focused : Bool <read-only>`
- `dox, doy : Numbers <read-only>`
- `bound_to : dnkPanel <read-only>` - Panel the slider has been bound to. Modify with `dnkSlider:bind` or `dnkSlider:rebind`.

### Methods
- `init(parent : Node, name : String, x : Number, y : Number, w : Number, h : Number) : dnkSlider`  
-> Class constructor.

- `bind(p : dnkPanel)`  
-> Binds the slider to the panel `p`. This makes it so the panel's `transy` is connected to the slider's `boxy`, so that when the slider is scrolling down the panel is also scrolling down (going up). This takes into account the slider's `h` and the panel's `content_height`, so we may not scroll out of bounds.  
- `rebind(p: dnkPanel)` 
-> Variant of `dnkSlider:bind` that should be used when the given panel's `transy` is not 0.

### Events
- `move(self : dnkSlider)`  
-> Called when the box of the slider has been moved.
- `press(self : dnkSlider)`  
-> Called when the box the slider has been held and then released.



## dnkButton
Extends from `dnkElement`. Has box methods `full`.  
Simple button which can be clicked and has text.

### Fields
- `w, h : Numbers <read-only>` - Width and height. Adjusted automatically when `dnkButton:set_text` is called.
- `focused : Bool <read-only>`
- `text : String <read-only>` - Modify with `dnkButton:set_text`.
- `texture : Love.Text <read-only>`

### Methods
- `init(parent : Node, name : String, x : Number, y : Number, text : String) : dnkButton`  
-> Class constructor, creates a text button at `(x, y)` with the text `text`. Auto-sizes the button to contain the text.

- `set_text(t : String)`  
-> Sets the text of the button to be `t`.

### Events
- `press(self : dnkButton)`  
-> Called when the button has been pressed



## dnkTextInput (WIP)
Extends from `dnkElement`. Has box methods `full`.  
Simple one line text input. WIP, as it crashes sometimes.

### Fields
- `w, h : Numbers <read-only>` - Width and height. Adjusted automatically when `dnkButton:set_text` is called.
- `scroll_w : Number <read-only>` - Stores the horizontal scroll.
- `cursor_pos : Number <read-only>`
- `focused : Bool <read-only>`
- `text : String <read-only>` - Contains the text the used has entered. You can modify it with `dnkTextInput:set_text`.
- `text_drawable : Love.Text <read-only>`
- `text_at_cursor : Love.Text <read-only>`
- `canvas : Love.Canvas <read-only>`

### Methods
- `init(parent : Node, name : String, x : Number, y : Number, w : Number, h : Number) : dnkTextInput`  
-> Class constructor.

- `set_text(t : String)`  
-> Sets the text of the input to be `t`. This overwrites anything the user has written.

### Events
- `update_text(self : dnkTextInput)`  
-> Called whenever the user changes the text.
- `finish_text(self : dnkTextInput)`  
-> Called whenever the user presses enter after writing or when clicking outside of the input's `box_full` when the input is focused.



## dnkFmtLabel (WIP)
Extends from `dnkElement`. Has box methods `full`.  
Text label which can display colors and different text decorations like bold or underlined. WIP, as the skin system is not done so we can't add fonts for bold or italics, and Unifont doesn't have support for these.

### Fields
- `textures : Table<Love.Font> <read-only>` - The list of textures used to render the whole text.
- `text_w : Number <read-only>` - Width of the text

### Methods
- `init(parent : Node, name : String, x : Number, y : Number) : dnkFmtLabel`  
-> Class constructor.

- `set_text(text_table : Table) : dnkFmtLabel`  
-> Sets the text of the formatted label.