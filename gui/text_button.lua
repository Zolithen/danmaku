gui.Button = {}

set_union(gui.Button, gui.Events);

function gui.Button.new(x, y, text)
	local self = {
		x = x,
		y = y,
		text = text,
		w = 0,
		h = 0,
		focused = false;
	};

	setmetatable(self, {
		__index = gui.Button
	})
	self:setup_events();
	self:set_text(self.text);

	return self;
end

function gui.Button:update(dt, mx, my)
	if self.focused then
		if not math.point_in_box(mx, my, self:box_full()) then
			self.focused = false;
		end
	end
end

function gui.Button:draw(mx, my)
	if (self.parent:is_mouse_over() and (self.parent.focused and self.focused)) then
		lg.setColor(gui.Skin.back_highlight2);
	elseif self.parent:is_mouse_over() and (self.parent.focused and math.point_in_box(mx, my, self:box_full())) then
		lg.setColor(gui.Skin.back_highlight);
	else
		lg.setColor(gui.Skin.back_light);
	end
	lg.rectangle("fill", self.x, self.y, self.w, self.h);
	lg.setColor(1, 1, 1, 1);
	lg.draw(self.texture, self.x+4, self.y+2);
end

function gui.Button:mousepressed(x, y, b)
	if (b == 1 and self.parent.focused and math.point_in_box(x, y, self:box_full())) then
		self.focused = true;
	end
end

function gui.Button:mousereleased(x, y, b)
	if self.focused then
		self:call("press");
	end
	self.focused = false;
end

function gui.Button:set_text(t)
	self.text = t;
	if self.texture then self.texture:release() end;
	self.texture = love.graphics.newText(gui.Skin.font, self.text);

	self.w = self.texture:getWidth()+8;
	self.h = self.texture:getHeight()+4;
end

function gui.Button:box_full()
	return self.x, self.y, self.w, self.h
end