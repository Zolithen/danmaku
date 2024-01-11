dnkWindow = dnkElement:extend("dnkWindow")
-- movable
-- expandable
-- minimizable

-- TODO: Conditions are getting worse over time by the amount
function dnkWindow:init(parent, x, y, w, h, skin, id, title)
	dnkWindow.super.init(self, parent, id, x, y);
		
	self.w = w
	self.h = h
	self:set_title(title or "");
	self.skin = skin
	self.focused = false -- TODO: Make it so we can focus windows without them bugging out
	self.show = true
	self.minim = false -- Is the window minimized? (minim bcs I can't write minimized)

	self.minimizable = true
	self.movable = true
	self.expandable = true -- Can the window be resized?
	self.expanding = false -- Is the window being resized?
	--self.closable = false; -- Can the window be closed?
	self.expand_box_size = 16
	self.dragging = false -- Is the window being dragged by the user?
	self.bar_height = 16

	self.highlight_time = 0;
		
	-- Used for dragging the window around and expanding
	self.dox = 0
	self.doy = 0

	-- Scrollbar parameters
	self.maxw = 0
	self.maxh = 0

	self.canvas = lg.newCanvas(w, h+self.bar_height);
end

-- To resize the window we also have to resize the canvas
-- TODO: Resizing could be done ¿better? if instead of drawing the whole canvas we draw a quad
function dnkWindow:resize(new_w, new_h)
	-- The minimum width of the window is the width of the title + width of the minim box + marging between border and minim box 
	self.w = math.max(2*self.bar_height-4 + self.bar_height + self.title_texture:getWidth(), new_w);
	self.h = math.max(self.expand_box_size, new_h);
	self.canvas:release();
	self.canvas = lg.newCanvas(self.w, self.h+self.bar_height);
end

-- Updates the title of the window
-- Needed to make the drawable update
function dnkWindow:set_title(new_t)
	self.title = new_t;
	self.title_texture = lg.newText(gui.Skin.font, new_t); 
end

-- Border calculations
-- local border_width = 4;
-- x_ = x - border_width
-- y_ = y - border_width
-- w_ = w + border_width*2
-- h_ = h + 16 + border_width*2
-- Canvas switches are expensive! Try switching canvases as least as possible
function dnkWindow:draw()
	local mx, my = self:transform_vector_raw(love.mouse.getX(), love.mouse.getY());
	-- Draw the window border
	if self.focused then
		lg.setColor(self:highlight_color(gui.Skin.green));
	else
		lg.setColor(self:highlight_color(gui.Skin.red));
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
		if (math.point_in_box(mx, my, self:box_bar()) and not math.point_in_box(mx, my, self:box_minimize())) then
			lg.setColor(gui.Skin.bar_light);
		else
			lg.setColor(gui.Skin.bar);
		end
		lg.rectangle("fill", 0, 0, self.w, self.bar_height);

		-- Draw the title
		lg.setColor(1, 1, 1, 1);
		lg.draw(self.title_texture, 0, 0);

		-- Draw the minimize box
		if self.minimizable then
			if (self.focused and math.point_in_box(mx, my, self:box_minimize())) then
				lg.setColor(gui.Skin.back_highlight);
			else
				lg.setColor(gui.Skin.back_light);
			end
			lg.rectangle("fill", self:box_minimize());
		end

		if not self.minim then
			-- Draw the main window
			lg.setColor(gui.Skin.back);
			lg.rectangle("fill", self:box_main());

		end

		if self.minim then -- If we have the window minimized we don't want to draw any of the children
			lg.setCanvas(); -- TODO: Should we reset the canvas every time we switch drawing windows?
			return NodeResponse.vwall;
		else
			lg.translate(0, self.bar_height);
		end
end

function dnkWindow:draw_after_children()
		local mx, my = self:transform_vector_raw(love.mouse.getX(), love.mouse.getY());
		if not self.minim then
			lg.translate(0, -self.bar_height);
		end
		
		-- Draw the expand box
		if not self.minim and self.expandable then
			-- The box has to be highlitable even if we are not focusing the window
			if math.point_in_box(mx, my, self:box_expand()) then
				lg.setColor(gui.Skin.back_highlight)
			else
				lg.setColor(gui.Skin.back_light)
			end
			lg.rectangle("fill", self:box_expand());
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

	self.highlight_time = math.max(0, self.highlight_time - dt);
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

-- TODO: Ensure absolutely every GUI element that uses mousepresses doesn't get called when clicking outside the window.
function dnkWindow:mousepressed(x, y, b)
	local mx, my = self:transform_vector_raw(love.mouse.getX(), love.mouse.getY());
	if not math.point_in_box(mx, my, self:box_full()) then
		return NodeResponse.vwall;
	end

	if self.minim and math.point_in_box(mx, my, self:box_main()) then
		return NodeResponse.vwall;
	end

	if (self.minimizable and b == 1 and math.point_in_box(mx, my, self:box_minimize())) then
		self.minim = not self.minim;
	end

	-- We check first if its not focused so that if we click on an unfocused window we actually process stuff instead of having to click again
	if (not self.focused) and not (self.minim and math.point_in_box(mx, my, self:box_main()))  then 
		if b == 1 then
			self.parent:focus_window(self.child_index);
		end
	end

	local must_update = false;
	if self.focused then
		if b == 1 then -- TODO: Make this work with all buttons pleaseeeee
			-- Dragging the window around
			if math.point_in_box(mx, my, self:box_bar()) then
				self.dragging = true;
				self.dox = x - self.x; -- TODO: This may be a bit funky if we have multiple coordinate systems
				self.doy = y - self.y;
			end

			if self.minim then
				return NodeResponse.stop;
			end

			-- Resizing the window
			if math.point_in_box(mx, my, self:box_expand()) and self.expandable then
				self.expanding = true;
				self.dox = self.w - x;
				self.doy = self.h - y;
			else
				must_update = true;
			end
		end

		--self.panel:mousepressed(x, y, b);
	end

	if self.minim then
		return NodeResponse.stop;
	end

	if self.focused then
		return NodeResponse.hwall; -- Cancel passing the event onto other windows if we clicked the focused window
	end
end

function dnkWindow:mousereleased(x, y, b)
	
	self.dragging = false;
	self.expanding = false;


	if self.minim then return NodeResponse.vwall end;
	if self.focused then
		--self.panel:mousereleased(x, y, b);
	end
end

function dnkWindow:keypressed(key, scancode, is_repeat)
	if self.minim then 
		return NodeResponse.vwall; 
	end;
end

function dnkWindow:textinput(t)
	if self.minim then return end;
end

function dnkWindow:is_holder()
	return true;
end

-- Turns the given vector into the window's content's CS
function dnkWindow:transform_vector(x, y)
	local nx, ny = dnkWindow.super.transform_vector(self, x, y);
	return nx, ny - self.bar_height;
end

-- Turns the given vector into the window's CS
function dnkWindow:transform_vector_raw(x, y)
	local nx, ny = dnkWindow.super.transform_vector(self, x, y);
	return nx, ny;
end

-- TODO: Shouldn't we check for is_mouse_over in some events to know if this has happened or some bullshit
function dnkWindow:is_mouse_over()
	local mx, my = self:transform_vector_raw(love.mouse.getX(), love.mouse.getY());
	return math.point_in_box(mx, my, self:box_full());
end

-- Window boxes functions
-- They are in local coordinates, which means that the left upper corner of the window is (0, 0)
function dnkWindow:box_bar()
	return 0, 0, self.w, self.bar_height
end

function dnkWindow:box_main()
	return 0, self.bar_height, self.w, self.h
end

function dnkWindow:box_full()
	return 0, 0, self.w, self.h+self.bar_height
end

function dnkWindow:box_expand() -- Size of the slip
	return self.w - self.expand_box_size, 
		   self.bar_height + self.h - self.expand_box_size,
		   self.expand_box_size,
		   self.expand_box_size
end

function dnkWindow:box_close()
	return self.w - self.bar_height-2,
		   0,
		   self.bar_height,
		   self.bar_height
end

function dnkWindow:box_minimize()
	return self.w - 2*self.bar_height-4,
		   0,
		   self.bar_height,
		   self.bar_height
end

-- TODO: Finish & Optimize
function dnkWindow:highlight(secs)
	self.highlight_time = self.highlight_time + secs;
end

function dnkWindow:highlight_color(col)
	local r, g, b, a = col[1], col[2], col[3], col[4];
	local mod = math.min(1, self.highlight_time)*math.abs(math.sin(self.highlight_time*4));
	return r+1*mod, g+0.94*mod, b, a; 
end