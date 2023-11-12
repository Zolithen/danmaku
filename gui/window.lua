local Window = {}
-- movable
-- expandable
-- minimizable

-- TODO: Conditions are getting worse over time by the amount
function Window.new(x, y, w, h, skin, id, title, controller)
	local self = {
		x = x,
		y = y,
		w = w,
		h = h,
		id = id or math.uuid(),
		title = title or "",
		elements = {},
		skin = skin,
		controller = controller, -- Window controller to which this window is attached to
		child_index = 0, -- Index of the window in the parent controller. Is set in the gui:new_window function
		focused = false, -- TODO: Make it so we can focus windows without them bugging out
		show = true,
		minim = false, -- Is the window minimized? (minim bcs I can't write minimized)

		canvas = love.graphics.newCanvas(w, h), -- Canvas to draw the elements to

		minimizable = true,
		movable = true,
		expandable = true, -- Can the window be resized?
		expanding = false, -- Is the window being resized?
		expand_box_size = 16,
		dragging = false, -- Is the window being dragged by the user?
		bar_height = 16,
		dox = 0,
		doy = 0, -- Stores the mouse's click position when the window starts being dragged
		transx = 0, -- Controls the scroll of the window!
		transy = 0,
	};

	setmetatable(self, {
		__index = Window
	});

	return self;
end

function Window:add_element(el, id)
	el:load(self.skin, id or nil, self);
	table.insert(self.elements, el);
	return el;
end

-- To resize the window we also have to resize the canvas
-- TODO: Resizing could be done ¿better? if instead of drawing the whole canvas we draw a quad
function Window:resize(new_w, new_h)
	self.w = math.max(self.expand_box_size, new_w);
	self.h = math.max(self.expand_box_size, new_h);
	self.canvas:release();
	self.canvas = love.graphics.newCanvas(self.w, self.h);
end

-- Border calculations
-- local border_width = 4;
-- x_ = x - border_width
-- y_ = y - border_width
-- w_ = w + border_width*2
-- h_ = h + 16 + border_width*2
-- Canvas switches are expensive! Try switching canvases as least as possible
function Window:draw()

	local mx, my = love.mouse.getX(), love.mouse.getY();
	-- Draw the window border
	if self.focused then
		lg.setColor(self.skin.green);
	else
		lg.setColor(self.skin.red);
	end
	local bw = self.skin.window_border_width;
	if self.minim then
		lg.rectangle("fill", self.x-bw, self.y-bw, self.w+bw*2, self.bar_height+bw*2);
	else
		lg.rectangle("fill", self.x-bw, self.y-bw, self.w+bw*2, self.h+self.bar_height+bw*2);
	end

	-- Draw the bar
	-- TODO: I don't want to put every box
	if (math.point_in_box(mx, my, self:box_bar()) and not math.point_in_box(mx, my, self:box_minimize())) then
		lg.setColor(self.skin.bar_light);
	else
		lg.setColor(self.skin.bar);
	end
	lg.rectangle("fill", self:box_bar());

	-- Draw the title
	lg.setColor(1, 1, 1, 1);
	lg.print(self.title, self.x, self.y);

	--[[
	if (self.window.focused and self.focused) then
		lg.setColor(self.skin.back_highlight2);
	elseif (self.window.focused and math.point_in_box(mx, my, self:box_full())) then
		lg.setColor(self.skin.back_highlight);
	else
		lg.setColor(self.skin.back_light);
	end
	]]
	-- Draw the minimize box
	if self.minimizable then
		if (self.focused and math.point_in_box(mx, my, self:box_minimize())) then
			lg.setColor(self.skin.back_highlight);
		else
			lg.setColor(self.skin.back_light);
		end
		lg.rectangle("fill", self:box_minimize());
	end
	--lg.rectangle("fill", self:box_close());

	if not self.minim then
		-- Draw the main window
		lg.setColor(self.skin.back);
		lg.rectangle("fill", self:box_main());

		-- Draw the elements
		lg.setColor(1, 1, 1, 1);
		lg.setCanvas(self.canvas); -- TODO: Make it so we only draw to the canvas whenever we need updating the visual aspect
		lg.clear();
		lg.translate(self.transx, self.transy);
		local tmx, tmy = self:to_window_cs(mx, my);
		for i, v in ipairs(self.elements) do
			if v.draw then
				v:draw(tmx, tmy); -- We pass in the transformed mouse coordinates
			end
		end
		lg.translate(-self.transx, -self.transy);
		lg.setCanvas();

		lg.draw(self.canvas, self.x, self.y+self.bar_height);

		-- Draw the expand box
		if self.expandable then
			-- The box has to be highlitable even if we are not focusing the window
			if math.point_in_box(mx, my, self:box_expand()) then
				lg.setColor(self.skin.back_highlight)
			else
				lg.setColor(self.skin.back_light)
			end
			lg.rectangle("fill", self:box_expand());
		end
	end
end

function Window:update(dt)
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
	local tmx, tmy = self:to_window_cs(love.mouse.getX(), love.mouse.getY());
	for i, v in ipairs(self.elements) do
		if v.update then
			v:update(dt, tmx, tmy);
		end
	end
end

function Window:mousemoved(x, y, dx, dy)
	if self.focused then
		if self.expanding then
			self:resize(x + self.dox, y + self.doy);
		else
			if self.minim then return end;
			local tmx, tmy = self:to_window_cs(x, y);
			for i, v in ipairs(self.elements) do
				if v.mousemoved then
					v:mousemoved(tmx, tmy, dx, dy)
				end
			end
		end
	end
end

function Window:mousepressed(x, y, b)
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

		local tmx, tmy = self:to_window_cs(x, y);
		for i, v in ipairs(self.elements) do
			if v.mousepressed then
				v:mousepressed(tmx, tmy, b);
			end
		end
	end

	if self.focused then
		return true; -- Cancel passing the event onto other windows if we clicked the focused window
	end
end

function Window:mousereleased(x, y, b)
	
	self.dragging = false;
	self.expanding = false;


	if self.minim then return end;
	if self.focused then
		local tmx, tmy = self:to_window_cs(x, y);
		for i, v in ipairs(self.elements) do
			if v.mousereleased then
				v:mousereleased(tmx, tmy, b);
			end
		end
	end
end

function Window:keypressed(key, scancode, is_repeat)
	if self.minim then return end;
	if self.focused then
		for i, v in ipairs(self.elements) do
			if v.keypressed then
				v:keypressed(key, scancode, is_repeat);
			end
		end

		return true;
	end
end

function Window:textinput(t)
	if self.minim then return end;
	if self.focused then
		for i, v in ipairs(self.elements) do
			if v.textinput then
				v:textinput(t);
			end
		end

		return true;
	end
end


function Window:relative_mouse_pos()
	-- TODO: add transx here??¿?¿??
	return self:to_window_cs(love.mouse.getX(), love.mouse.getY());
end

-- Turns the given vector to relative window coordinates
function Window:to_window_cs(x, y)
	return x - self.x - self.transx, y - self.y - self.bar_height + self.transy
end

function Window:is_mouse_over()
	return math.point_in_box(love.mouse.getX(), love.mouse.getY(), self:box_full());
end

-- Window boxes functions
function Window:box_bar()
	return self.x, self.y, self.w, self.bar_height
end

function Window:box_main()
	return self.x, self.y+self.bar_height, self.w, self.h
end

function Window:box_full()
	return self.x, self.y, self.w, self.h+self.bar_height
end

function Window:box_expand() -- Size of the slip
	return self.x + self.w - self.expand_box_size, 
		   self.y + self.bar_height + self.h - self.expand_box_size,
		   self.expand_box_size,
		   self.expand_box_size
end

function Window:box_close()
	return self.x + self.w - self.bar_height-2,
		   self.y,
		   self.bar_height,
		   self.bar_height
end

function Window:box_minimize()
	return self.x + self.w - 2*self.bar_height-4,
		   self.y,
		   self.bar_height,
		   self.bar_height
end

return Window;