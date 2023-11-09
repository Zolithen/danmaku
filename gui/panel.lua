local Panel = {}

-- To hide a panel you have to use minim not show, like a window (xD)
function Panel.new(x, y, w, h)
	local self = {
		x = x,
		y = y,
		w = w,
		h = h,
		id = id or math.uuid(),
		elements = {},
		skin = skin,
		show = true,
		minim = false, -- Is the Panel minimized? (minim bcs I can't write minimized)
		focused = true, -- Hack to allow elements to know when the parent window is focused

		canvas = love.graphics.newCanvas(w, h) -- Canvas to draw the elements to
	};

	setmetatable(self, {
		__index = Panel
	});

	return self;
end

function Panel:load(skin, id, window)
	self.skin = skin;
	self.id = id or math.uuid();
	self.window = window;
end

function Panel:add_element(el, id)
	el:load(self.skin, id or nil, self);
	table.insert(self.elements, el);
	return el;
end

function Panel:draw(mx, my)

	-- Draw the Panel border
	lg.setColor(self.skin.green);
	local bw = self.skin.window_border_width;
	if self.minim then
		--lg.rectangle("fill", self.x-bw, self.y-bw, self.w+bw*2, bw*2);
	else
		lg.rectangle("fill", self.x-bw, self.y-bw, self.w+bw*2, self.h+bw*2);
	end

	if not self.minim then
		-- Draw the main Panel
		lg.setColor(self.skin.back);
		lg.rectangle("fill", self:box_main());

		-- Draw the elements
		lg.setColor(1, 1, 1, 1);
		lg.push("all");
			lg.setCanvas(self.canvas); -- TODO: Make it so we only draw to the canvas whenever we need updating the visual aspect
			lg.clear();
			for i, v in ipairs(self.elements) do
				if v.draw then
					v:draw(mx - self.x, my - self.y); -- We pass in the transformed mouse coordinates
				end
			end
		lg.pop();

		lg.draw(self.canvas, self.x, self.y);
	end
end

function Panel:update(dt, mx, my)
	self.focused = self.window.focused;
	if self.minim then return end;
	for i, v in ipairs(self.elements) do
		if v.update then
			v:update(dt, mx - self.x, my - self.y);
		end
	end
end

function Panel:mousemoved(x, y, dx, dy)
	if self.minim then return end;
	for i, v in ipairs(self.elements) do
		if v.mousemoved then
			v:mousemoved(x-self.x, y-self.y, dx, dy)
		end
	end
end

function Panel:mousepressed(x, y, b)
	if not math.point_in_box(x, y, self:box_full()) then
		return;
	end

	-- TODO: Make this work with all buttons pleaseeeee
	if b == 1 then
		if self.minim then return false end;
		for i, v in ipairs(self.elements) do
			if v.mousepressed then
				v:mousepressed(x-self.x, y-self.y, b);
			end
		end
	end
end

function Panel:mousereleased(x, y, b)
	if self.minim then return end;
	for i, v in ipairs(self.elements) do
		if v.mousereleased then
			v:mousereleased(x-self.x, y-self.y, b);
		end
	end
end

function Panel:keypressed(key, scancode, is_repeat)
	if self.minim then return end;
	for i, v in ipairs(self.elements) do
		if v.keypressed then
			v:keypressed(key, scancode, is_repeat);
		end
	end
end

function Panel:textinput(t)
	if self.minim then return end;
	for i, v in ipairs(self.elements) do
		if v.textinput then
			v:textinput(t);
		end
	end
end

--[[function Panel:is_mouse_over()
	return math.point_in_box(love.mouse.getX(), love.mouse.getY(), self:box_full());
end]]

function Panel:is_mouse_over()
	local mx, my = self.window:relative_mouse_pos();
	local x, y, w, h = self:box_full();
	--return self.window:is_mouse_over() and math.point_in_box(self.window:relative_mouse_pos(), self:box_full());
	-- that line doesn't work for some reason? the my is completely ignored. i think this may be a luajit bug
	return self.window:is_mouse_over() and math.point_in_box(mx, my, x, y, w, h);
end

-- Panel boxes functions

function Panel:box_main()
	return self.x, self.y, self.w, self.h
end

function Panel:box_full()
	return self.x, self.y, self.w, self.h
end

return Panel;