dnkWindow = Node:extend("dnkWindow")
-- movable
-- expandable
-- minimizable

-- TODO: Conditions are getting worse over time by the amount
function dnkWindow:init(parent, x, y, w, h, skin, id, title)
	dnkWindow.super.init(self, parent, nil, x, y);
		
	self.w = w
	self.h = h
	self.title = title or ""
	self.skin = skin
	self.focused = false -- TODO: Make it so we can focus windows without them bugging out
	self.show = true
	self.minim = false -- Is the window minimized? (minim bcs I can't write minimized)

	self.minimizable = true
	self.movable = true
	self.expandable = true -- Can the window be resized?
	self.expanding = false -- Is the window being resized?
	self.expand_box_size = 16
	self.dragging = false -- Is the window being dragged by the user?
	self.bar_height = 16
		
	-- Used for dragging the window around and expanding
	self.dox = 0
	self.doy = 0
		
	-- Window scroll
	self.transx = 0
	self.transy = 0

	-- Scrollbar parameters
	self.maxw = 0
	self.maxh = 0

	self.canvas = lg.newCanvas(w, h+self.bar_height);
end

-- To resize the window we also have to resize the canvas
-- TODO: Resizing could be done ¿better? if instead of drawing the whole canvas we draw a quad
function dnkWindow:resize(new_w, new_h)
	self.w = math.max(self.expand_box_size, new_w);
	self.h = math.max(self.expand_box_size, new_h);
	self.canvas:release();
	self.canvas = lg.newCanvas(self.w, self.h+self.bar_height);
end

-- Border calculations
-- local border_width = 4;
-- x_ = x - border_width
-- y_ = y - border_width
-- w_ = w + border_width*2
-- h_ = h + 16 + border_width*2
-- Canvas switches are expensive! Try switching canvases as least as possible
function dnkWindow:draw()
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

	lg.setCanvas(self.canvas);
		lg.clear();
		-- Draw the bar
		-- TODO: I don't want to put every box (what the fuck did he mean by this)
		if (math.point_in_box(mx, my, self:box_bar()) and not math.point_in_box(mx, my, self:box_minimize())) then
			lg.setColor(gui.Skin.bar_light);
		else
			lg.setColor(gui.Skin.bar);
		end
		lg.rectangle("fill", 0, 0, self.w, self.bar_height);

		-- Draw the title
		lg.setColor(1, 1, 1, 1);
		lg.print(self.title, 0, 0);

		-- Draw the minimize box
		if self.minimizable then
			if (self.focused and math.point_in_box(mx, my, self:_box_minimize())) then
				lg.setColor(gui.Skin.back_highlight);
			else
				lg.setColor(gui.Skin.back_light);
			end
			lg.rectangle("fill", self:_box_minimize());
		end

		if not self.minim then
			-- Draw the main window
			lg.setColor(gui.Skin.back);
			lg.rectangle("fill", self:_box_main());

		end

		if self.minim then -- If we have the window minimized we don't want to draw any of the children
			lg.setCanvas(); -- TODO: Should we reset the canvas every time we switch drawing windows?
			return NodeResponse.vwall;
		else
			lg.translate(0, self.bar_height);
		end
end

function dnkWindow:postdraw()
		local mx, my = love.mouse.getX(), love.mouse.getY();
		if not self.minim then
			lg.translate(0, -self.bar_height);
		end
		
		-- Draw the expand box
		if not self.minim and self.expandable then
			-- The box has to be highlitable even if we are not focusing the window
			if math.point_in_box(mx, my, self:_box_expand()) then
				lg.setColor(gui.Skin.back_highlight)
			else
				lg.setColor(gui.Skin.back_light)
			end
			lg.rectangle("fill", self:_box_expand());
		end
	lg.setCanvas();
	lg.setColor(1, 1, 1, 1);
	lg.draw(self.canvas, self.x, self.y);
end

function dnkWindow:update(dt)
	if self.focused then -- If the windows is focused then we can move it
		if self.dragging and self.movable then
			self.x = love.mouse.getX() - self.dox;
			self.y = love.mouse.getY() - self.doy;
		--[[elseif self.expanding then
			self.w = math.max(self.expand_box_size, love.mouse.getX() + self.dox);
			self.h = math.max(self.expand_box_size, love.mouse.getY() + self.doy);]]
		end
	end

	if self.minim then return end;
end

function dnkWindow:mousemoved(x, y, dx, dy)
	if self.focused then
		if self.expanding then
			self:resize(x + self.dox, y + self.doy);
		else
			if self.minim then return end;
			--self.panel:mousemoved(x, y, dx, dy);
		end
	end
end

function dnkWindow:mousepressed(x, y, b)
	if not math.point_in_box(x, y, self:box_full()) then
		return;
	end

	if (self.minimizable and b == 1 and math.point_in_box(x, y, self:box_minimize())) then
		self.minim = not self.minim;
	end

	if not self.focused then -- We check first if its not focused so that if we click on an unfocused window we actually process stuff instead of having to click again
		if b == 1 then
			self.parent:focus_window(self.child_index);
			--self.controller:focus_window(self.child_index);
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

		--self.panel:mousepressed(x, y, b);
	end

	if self.focused then
		return true; -- Cancel passing the event onto other windows if we clicked the focused window
	end
end

function dnkWindow:mousereleased(x, y, b)
	
	self.dragging = false;
	self.expanding = false;


	if self.minim then return end;
	if self.focused then
		--self.panel:mousereleased(x, y, b);
	end
end

function dnkWindow:keypressed(key, scancode, is_repeat)
	if self.minim then return end;
	if self.focused then
		--self.panel:keypressed(key, scancode, is_repeat)

		return true;
	end
end

function dnkWindow:textinput(t)
	if self.minim then return end;
	if self.focused then
		--self.panel:textinput(t);

		return true;
	end
end


function dnkWindow:relative_mouse_pos()
	-- TODO: add transx here??¿?¿??
	return self:to_local_cs(love.mouse.getX(), love.mouse.getY());
end

-- Turns the given vector to relative window coordinates
function dnkWindow:to_local_cs(x, y)
	return x - self.x - self.transx, y - self.y - self.bar_height + self.transy
end

function dnkWindow:is_mouse_over()
	return math.point_in_box(love.mouse.getX(), love.mouse.getY(), self:box_full());
end

-- Window boxes functions
function dnkWindow:box_bar()
	return self.x, self.y, self.w, self.bar_height
end

function dnkWindow:box_main()
	return self.x, self.y+self.bar_height, self.w, self.h
end

function dnkWindow:_box_main()
	return 0, self.bar_height, self.w, self.h
end

function dnkWindow:box_full()
	return self.x, self.y, self.w, self.h+self.bar_height
end

function dnkWindow:box_expand() -- Size of the slip
	return self.x + self.w - self.expand_box_size, 
		   self.y + self.bar_height + self.h - self.expand_box_size,
		   self.expand_box_size,
		   self.expand_box_size
end

function dnkWindow:_box_expand() -- Size of the slip
	return self.w - self.expand_box_size, 
		   self.bar_height + self.h - self.expand_box_size,
		   self.expand_box_size,
		   self.expand_box_size
end

function dnkWindow:box_close()
	return self.x + self.w - self.bar_height-2,
		   self.y,
		   self.bar_height,
		   self.bar_height
end

function dnkWindow:_box_close()
	return self.w - self.bar_height-2,
		   0,
		   self.bar_height,
		   self.bar_height
end

function dnkWindow:box_minimize()
	return self.x + self.w - 2*self.bar_height-4,
		   self.y,
		   self.bar_height,
		   self.bar_height
end

function dnkWindow:_box_minimize()
	return self.w - 2*self.bar_height-4,
		   0,
		   self.bar_height,
		   self.bar_height
end