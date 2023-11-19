-- To hide a panel you have to use minim not show, like a window (xD)
function gui.Panel.new(x, y, w, h)
	local self = {
		x = x,
		y = y,
		w = w,
		h = h,
		
		transx = 0,
		transy = 0,
		
		id = id or math.uuid(),
		skin = skin,
		show = true,
		minim = false, -- Is the Panel minimized? (minim bcs I can't write minimized)
		focused = true, -- Hack to allow elements to know when the parent window is focused

		canvas = love.graphics.newCanvas(w, h) -- Canvas to draw the elements to
	};

	self.panel = gui.ProtoPanel.new(x, y, w, h);
	self.panel.parent = self;
	self.elements = self.panel.elements;
	self.canvas = self.panel.canvas; -- userdata is not copied, but passed by reference

	setmetatable(self, {
		__index = gui.Panel
	});

	return self;
end

function gui.Panel:add_element(el, id)
	return self.panel:add_element(el, id);
end

function gui.Panel:remove_element(id)
	return self.panel:remove_element(id);
end

function gui.Panel:draw(mx, my)
	-- Draw the Panel border
	lg.setColor(gui.Skin.green);
	local bw = gui.Skin.window_border_width;
	if self.minim then
		--lg.rectangle("fill", self.x-bw, self.y-bw, self.w+bw*2, bw*2);
	else
		lg.rectangle("fill", self.x-bw, self.y-bw, self.w+bw*2, self.h+bw*2);
	end

	if not self.minim then
		local tmx, tmy = self:to_local_cs(mx, my);
		-- Draw the main Panel
		lg.setColor(gui.Skin.back);
		lg.rectangle("fill", self:box_main());

		self.panel:draw(mx, my);
	end
end

function gui.Panel:update(dt, mx, my)
	self.focused = self.parent.focused;
	self.panel.x = self.x;
	self.panel.y = self.y;
	self.panel.transx = self.transx;
	self.panel.transy = self.transy 
	if self.minim then return end;
	--[[local tmx, tmy = self:to_local_cs(mx, my);
	for i, v in ipairs(self.elements) do
		if v.update then
			v:update(dt, tmx, tmy);
		end
	end]]
	self.panel:update(dt, mx, my);
end

function gui.Panel:mousemoved(x, y, dx, dy)
	if self.minim then return end;
	--[[local tmx, tmy = self:to_local_cs(x, y);
	for i, v in ipairs(self.elements) do
		if v.mousemoved then
			v:mousemoved(tmx, tmy, dx, dy)
		end
	end]]
	self.panel:mousepressed(x, y, dx, dy);
end

function gui.Panel:mousepressed(x, y, b)
	if not math.point_in_box(x, y, self:box_full()) then
		return;
	end

	-- TODO: Make this work with all buttons pleaseeeee
	if b == 1 then
		if self.minim then return false end;
		--[[local tmx, tmy = self:to_local_cs(x, y);
		for i, v in ipairs(self.elements) do
			if v.mousepressed then
				v:mousepressed(tmx, tmy, b);
			end
		end]]
		self.panel:mousepressed(x, y, b);
	end
end

function gui.Panel:mousereleased(x, y, b)
	if self.minim then return end;
	local tmx, tmy = self:to_local_cs(x, y);
	--[[for i, v in ipairs(self.elements) do
		if v.mousereleased then
			v:mousereleased(tmx, tmy, b);
		end
	end]]
	self.panel:mousereleased(x, y, b);
end

function gui.Panel:keypressed(key, scancode, is_repeat)
	if self.minim then return end;
	--[[for i, v in ipairs(self.elements) do
		if v.keypressed then
			v:keypressed(key, scancode, is_repeat);
		end
	end]]
	self.panel:keypressed(key, scancode, is_repeat);
end

function gui.Panel:textinput(t)
	if self.minim then return end;
	--[[for i, v in ipairs(self.elements) do
		if v.textinput then
			v:textinput(t);
		end
	end]]
	self.panel:textinput(t);
end

--[[function Panel:is_mouse_over()
	return math.point_in_box(love.mouse.getX(), love.mouse.getY(), self:box_full());
end]]

-- TODO: Ensure this works with nested panels
function gui.Panel:relative_mouse_pos()
	-- TODO: add transx here??¿?¿??
	return self:to_local_cs(love.mouse.getX(), love.mouse.getY());
end

function gui.Panel:is_mouse_over()
	local mx, my = self.parent:relative_mouse_pos();
	local x, y, w, h = self:box_full();
	--return self.parent:is_mouse_over() and math.point_in_box(self.parent:relative_mouse_pos(), self:box_full());
	-- that line doesn't work for some reason? the my is completely ignored. i think this may be a luajit bug
	return self.parent:is_mouse_over() and math.point_in_box(mx, my, x, y, w, h);
end

-- To resize the window we also have to resize the canvas
-- TODO: Resizing could be done ¿better? if instead of drawing the whole canvas we draw a quad
function gui.Panel:resize(new_w, new_h)
	self.w = math.max(16, new_w);
	self.h = math.max(16, new_h);
	--self.canvas:release();
	--self.canvas = love.graphics.newCanvas(self.w, self.h);
	self.panel:resize(new_w, new_h);
	self.canvas = self.panel.canvas;
end

function gui.Panel:to_local_cs(x, y)
	return x - self.x - self.transx, y - self.y - self.transy
end

-- Panel boxes functions

function gui.Panel:box_main()
	return self.x, self.y, self.w, self.h
end

function gui.Panel:box_full()
	return self.x, self.y, self.w, self.h
end