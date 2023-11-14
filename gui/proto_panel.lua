gui.ProtoPanel = {}

-- To hide a panel you have to use minim not show, like a parent (xD)
function gui.ProtoPanel.new(x, y, w, h)
	local self = {
		x = x,
		y = y,
		w = w,
		h = h,
		transx = 0,
		transy = 0,
		id = math.uuid(),
		elements = {},
		show = true,
		minim = false, -- Is the Panel minimized? (minim bcs I can't write minimized)
		focused = false, -- Hack to allow elements to know when the parent parent is focused

		canvas = love.graphics.newCanvas(w, h) -- Canvas to draw the elements to
	};

	setmetatable(self, {
		__index = gui.ProtoPanel
	});

	return self;
end

function gui.ProtoPanel:add_element(el, id)
	table.insert(self.elements, el);
	el.id = id or math.uuid();
	el.parent = self; -- TODO: Do we have to change this?¿
	return el;
end

function gui.ProtoPanel:draw(mx, my)
	local tmx, tmy = self:to_local_cs(mx, my);
	-- Draw the elements
	lg.setColor(1, 1, 1, 1);
	lg.push("all");
		lg.setCanvas(self.canvas); -- TODO: Make it so we only draw to the canvas whenever we need updating the visual aspect
		lg.clear();
		lg.translate(self.transx, self.transy);
		for i, v in ipairs(self.elements) do
			if v.draw then
				v:draw(tmx, tmy); -- We pass in the transformed mouse coordinates
			end
		end
		lg.translate(-self.transx, -self.transy);
	lg.pop();

	lg.draw(self.canvas, self.x, self.y);
end

function gui.ProtoPanel:update(dt, mx, my)
	self.focused = self.parent.focused;
	local tmx, tmy = self:to_local_cs(mx, my);
	for i, v in ipairs(self.elements) do
		if v.update then
			v:update(dt, tmx, tmy);
		end
	end
end

function gui.ProtoPanel:mousemoved(x, y, dx, dy)
	local tmx, tmy = self:to_local_cs(x, y);
	for i, v in ipairs(self.elements) do
		if v.mousemoved then
			v:mousemoved(tmx, tmy, dx, dy)
		end
	end
end

function gui.ProtoPanel:mousepressed(x, y, b)
	if not math.point_in_box(x, y, self:box_full()) then
		return;
	end

	-- TODO: Make this work with all buttons pleaseeeee
	if b == 1 then
		local tmx, tmy = self:to_local_cs(x, y);
		for i, v in ipairs(self.elements) do
			if v.mousepressed then
				v:mousepressed(tmx, tmy, b);
			end
		end
	end
end

function gui.ProtoPanel:mousereleased(x, y, b)
	local tmx, tmy = self:to_local_cs(x, y);
	for i, v in ipairs(self.elements) do
		if v.mousereleased then
			v:mousereleased(tmx, tmy, b);
		end
	end
end

function gui.ProtoPanel:keypressed(key, scancode, is_repeat)
	for i, v in ipairs(self.elements) do
		if v.keypressed then
			v:keypressed(key, scancode, is_repeat);
		end
	end
end

function gui.ProtoPanel:textinput(t)
	for i, v in ipairs(self.elements) do
		if v.textinput then
			v:textinput(t);
		end
	end
end

--[[function Panel:is_mouse_over()
	return math.point_in_box(love.mouse.getX(), love.mouse.getY(), self:box_full());
end]]

function gui.ProtoPanel:is_mouse_over()
	local mx, my = self.parent:relative_mouse_pos();
	local x, y, w, h = self:box_full();
	return self.parent:is_mouse_over() and math.point_in_box(mx, my, x-self.parent.x, y-self.parent.y, w, h);
end

-- To resize the parent we also have to resize the canvas
-- TODO: Change the 16x16 bounds, they are stupid. Actually find a way of doing this correctly
function gui.ProtoPanel:resize(new_w, new_h)
	self.w = math.max(16, new_w);
	self.h = math.max(16, new_h);
	self.canvas:release();
	self.canvas = love.graphics.newCanvas(self.w, self.h);
end

function gui.ProtoPanel:relative_mouse_pos()
	-- TODO: add transx here??¿?¿??
	return self:to_local_cs(love.mouse.getX(), love.mouse.getY());
end

function gui.ProtoPanel:to_local_cs(x, y)
	return x - self.x - self.transx, y - self.y - self.transy
end

-- Panel boxes functions

function gui.ProtoPanel:box_main()
	return self.x, self.y, self.w, self.h
end

function gui.ProtoPanel:box_full()
	return self.x, self.y, self.w, self.h
end