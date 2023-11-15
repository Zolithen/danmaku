gui.Window = {}
-- movable
-- expandable
-- minimizable

-- TODO: Conditions are getting worse over time by the amount
function gui.Window.new(x, y, w, h, skin, id, title, controller)
	
	local self = {
		x = x,
		y = y,
		w = w,
		h = h,
		id = id or math.uuid(),
		title = title or "",
		skin = skin,
		controller = controller, -- Window controller to which this window is attached to
		child_index = 0, -- Index of the window in the parent controller. Is set in the gui:new_window function
		focused = false, -- TODO: Make it so we can focus windows without them bugging out
		show = true,
		minim = false, -- Is the window minimized? (minim bcs I can't write minimized)

		minimizable = true,
		movable = true,
		expandable = true, -- Can the window be resized?
		expanding = false, -- Is the window being resized?
		expand_box_size = 16,
		dragging = false, -- Is the window being dragged by the user?
		bar_height = 16,
		
		-- Used for dragging the window around and expanding
		dox = 0,
		doy = 0,
		
		-- Window scroll
		transx = 0,
		transy = 0,

		-- Scrollbar parameters
		maxw = 0,
		maxh = 0
	};

	self.panel = gui.ProtoPanel.new(x, y+self.bar_height, w, h-self.bar_height);
	self.panel.parent = self;
	self.elements = self.panel.elements;
	self.canvas = self.panel.canvas; -- userdata is not copied, but passed by reference
	--set_union_ignore_dupes(self, gui.ProtoPanel.new(x, y+self.bar_height, w, h-self.bar_height));

	--[[self.panel = gui.ProtoPanel.new(x, y+self.bar_height, w, h-self.bar_height);
	self.panel.elements = self.elements; ]]

	setmetatable(self, {
		__index = gui.Window
	});

	return self;
end

function gui.Window:add_element(el, id)
	return self.panel:add_element(el, id);
end

function gui.Window:remove_element(id)
	return self.panel:remove_element(id);
end

-- To resize the window we also have to resize the canvas
-- TODO: Resizing could be done ¿better? if instead of drawing the whole canvas we draw a quad
function gui.Window:resize(new_w, new_h)
	self.w = math.max(self.expand_box_size, new_w);
	self.h = math.max(self.expand_box_size, new_h);
	self.panel:resize(new_w, new_h);

	-- We have released the original reference, we need to get the new one back
	self.canvas = self.panel.canvas;
end

-- Border calculations
-- local border_width = 4;
-- x_ = x - border_width
-- y_ = y - border_width
-- w_ = w + border_width*2
-- h_ = h + 16 + border_width*2
-- Canvas switches are expensive! Try switching canvases as least as possible
function gui.Window:draw()

	local mx, my = love.mouse.getX(), love.mouse.getY();
	-- Draw the window border
	if self.focused then
		lg.setColor(gui.Skin.green);
	else
		lg.setColor(gui.Skin.red);
	end
	local bw = gui.Skin.window_border_width;
	if self.minim then
		lg.rectangle("fill", self.x-bw, self.y-bw, self.w+bw*2, self.bar_height+bw*2);
	else
		lg.rectangle("fill", self.x-bw, self.y-bw, self.w+bw*2, self.h+self.bar_height+bw*2);
	end

	-- Draw the bar
	-- TODO: I don't want to put every box (what the fuck did he mean by this)
	if (math.point_in_box(mx, my, self:box_bar()) and not math.point_in_box(mx, my, self:box_minimize())) then
		lg.setColor(gui.Skin.bar_light);
	else
		lg.setColor(gui.Skin.bar);
	end
	lg.rectangle("fill", self:box_bar());

	-- Draw the title
	lg.setColor(1, 1, 1, 1);
	lg.print(self.title, self.x, self.y);

	--[[
	if (self.window.focused and self.focused) then
		lg.setColor(gui.Skin.back_highlight2);
	elseif (self.window.focused and math.point_in_box(mx, my, self:box_full())) then
		lg.setColor(gui.Skin.back_highlight);
	else
		lg.setColor(gui.Skin.back_light);
	end
	]]
	-- Draw the minimize box
	if self.minimizable then
		if (self.focused and math.point_in_box(mx, my, self:box_minimize())) then
			lg.setColor(gui.Skin.back_highlight);
		else
			lg.setColor(gui.Skin.back_light);
		end
		lg.rectangle("fill", self:box_minimize());
	end
	--lg.rectangle("fill", self:box_close());

	if not self.minim then
		-- Draw the main window
		lg.setColor(gui.Skin.back);
		lg.rectangle("fill", self:box_main());

		-- Draw the elements
		self.panel:draw(mx, my);

		-- Draw the expand box
		if self.expandable then
			-- The box has to be highlitable even if we are not focusing the window
			if math.point_in_box(mx, my, self:box_expand()) then
				lg.setColor(gui.Skin.back_highlight)
			else
				lg.setColor(gui.Skin.back_light)
			end
			lg.rectangle("fill", self:box_expand());
		end
	end
end

function gui.Window:update(dt)

	if self.focused then -- If the windows is focused then we can move it
		if self.dragging and self.movable then
			self.x = love.mouse.getX() - self.dox;
			self.y = love.mouse.getY() - self.doy;
		--[[elseif self.expanding then
			self.w = math.max(self.expand_box_size, love.mouse.getX() + self.dox);
			self.h = math.max(self.expand_box_size, love.mouse.getY() + self.doy);]]
		end
	end

	-- Proxy the proto panel
	self.panel.x = self.x;
	self.panel.y = self.y + self.bar_height;
	self.panel.transx = self.transx;
	self.panel.transy = self.transy 
	--self.panel.w = self.w;
	--self.panel.h = self.h;

	if self.minim then return end;
	self.panel:update(dt, love.mouse.getX(), love.mouse.getY());
end

function gui.Window:mousemoved(x, y, dx, dy)
	if self.focused then
		if self.expanding then
			self:resize(x + self.dox, y + self.doy);
		else
			if self.minim then return end;
			self.panel:mousemoved(x, y, dx, dy);
		end
	end
end

function gui.Window:mousepressed(x, y, b)
	if not math.point_in_box(x, y, self:box_full()) then
		return;
	end

	if (self.minimizable and b == 1 and math.point_in_box(x, y, self:box_minimize())) then
		self.minim = not self.minim;
	end

	if not self.focused then -- We check first if its not focused so that if we click on an unfocused window we actually process stuff instead of having to click again
		if b == 1 then
			self.controller:focus_window(self.child_index);
		end
	end
	local must_update = false;
	if self.focused then
		if b == 1 then -- TODO: Make this work with all buttons pleaseeeee
			-- Dragging the window around
			if math.point_in_box(x, y, self:box_bar()) then
				self.dragging = true;
				self.dox = x - self.x; -- TODO: This may be a bit funky if we have multiple coordinate systems
				self.doy = y - self.y;
			end
			if self.minim then return self.focused end;
			-- Resizing the window
			if math.point_in_box(x, y, self:box_expand()) and self.expandable then
				self.expanding = true;
				self.dox = self.w - x;
				self.doy = self.h - y;
			else
				must_update = true;
			end
		end

		self.panel:mousepressed(x, y, b);
	end

	if self.focused then
		return true; -- Cancel passing the event onto other windows if we clicked the focused window
	end
end

function gui.Window:mousereleased(x, y, b)
	
	self.dragging = false;
	self.expanding = false;


	if self.minim then return end;
	if self.focused then
		self.panel:mousereleased(x, y, b);
	end
end

function gui.Window:keypressed(key, scancode, is_repeat)
	if self.minim then return end;
	if self.focused then
		self.panel:keypressed(key, scancode, is_repeat)

		return true;
	end
end

function gui.Window:textinput(t)
	if self.minim then return end;
	if self.focused then
		self.panel:textinput(t);

		return true;
	end
end


function gui.Window:relative_mouse_pos()
	-- TODO: add transx here??¿?¿??
	return self:to_local_cs(love.mouse.getX(), love.mouse.getY());
end

-- Turns the given vector to relative window coordinates
function gui.Window:to_local_cs(x, y)
	return x - self.x - self.transx, y - self.y - self.bar_height + self.transy
end

function gui.Window:is_mouse_over()
	return math.point_in_box(love.mouse.getX(), love.mouse.getY(), self:box_full());
end

-- Window boxes functions
function gui.Window:box_bar()
	return self.x, self.y, self.w, self.bar_height
end

function gui.Window:box_main()
	return self.x, self.y+self.bar_height, self.w, self.h
end

function gui.Window:box_full()
	return self.x, self.y, self.w, self.h+self.bar_height
end

function gui.Window:box_expand() -- Size of the slip
	return self.x + self.w - self.expand_box_size, 
		   self.y + self.bar_height + self.h - self.expand_box_size,
		   self.expand_box_size,
		   self.expand_box_size
end

function gui.Window:box_close()
	return self.x + self.w - self.bar_height-2,
		   self.y,
		   self.bar_height,
		   self.bar_height
end

function gui.Window:box_minimize()
	return self.x + self.w - 2*self.bar_height-4,
		   self.y,
		   self.bar_height,
		   self.bar_height
end