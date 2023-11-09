local Button = {}

function Button.new(x, y, text)
	local self = {
		x = x,
		y = y,
		text = text,
		w = 0,
		h = 0,
		focused = false;
	};

	setmetatable(self, {
		__index = Button
	})
	self:setup_events();

	return self;
end

function Button:load(skin, id, window)
	self.skin = skin;
	self.id = id or math.uuid();
	self.window = window;

	self:set_text(self.text);
end

function Button:update(dt, mx, my)
	if self.focused then
		if not math.point_in_box(mx, my, self:box_full()) then
			self.focused = false;
		end
	end
end

function Button:draw(mx, my)
	if (self.window:is_mouse_over() and (self.window.focused and self.focused)) then
		lg.setColor(self.skin.back_highlight2);
	elseif self.window:is_mouse_over() and (self.window.focused and math.point_in_box(mx, my, self:box_full())) then
		lg.setColor(self.skin.back_highlight);
	else
		lg.setColor(self.skin.back_light);
	end
	lg.rectangle("fill", self.x, self.y, self.w, self.h);
	lg.setColor(1, 1, 1, 1);
	lg.draw(self.texture, self.x+4, self.y+2);
end

function Button:mousepressed(x, y, b)
	if (b == 1 and self.window.focused and math.point_in_box(x, y, self:box_full())) then
		self.focused = true;
	end
end

function Button:mousereleased(x, y, b)
	if self.focused then
		self:call("press");
	end
	self.focused = false;
end

function Button:set_text(t)
	self.text = t;
	if self.texture then self.texture:release() end;
	self.texture = love.graphics.newText(self.skin.font, self.text);

	self.w = self.texture:getWidth()+8;
	self.h = self.texture:getHeight()+4;
end

function Button:box_full()
	return self.x, self.y, self.w, self.h
end

return Button;