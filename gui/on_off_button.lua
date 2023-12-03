dnkCheckbox = dnkElement:extend("dnkCheckbox");

function dnkCheckbox:init(parent, name, x, y)
	dnkCheckbox.super.init(self, parent, name, x, y);
	self.on = false;
	self.focused = false;
end

function dnkCheckbox:draw()
	local mx, my = self:transform_vector(love.mouse.getX(), love.mouse.getY());
	if self.on then
		lg.setColor(gui.Skin.green);
	else
		lg.setColor(gui.Skin.red);
	end
	lg.rectangle("fill", self.x-2, self.y-2, 36, 20);
	if (self.parent:is_mouse_over() and (self.parent.focused and self.focused)) then
		lg.setColor(gui.Skin.back_highlight2);
	elseif self.parent:is_mouse_over() and (self.parent.focused and math.point_in_box(mx, my, self:box_full())) then
		lg.setColor(gui.Skin.back_highlight);
	else
		lg.setColor(gui.Skin.back_light);
	end

	if self.on then
		lg.rectangle("fill", self.x+16, self.y, 16, 16);
	else
		lg.rectangle("fill", self.x, self.y, 16, 16);
	end
end

function dnkCheckbox:mousepressed(x, y, b)
	local mx, my = self:transform_vector(love.mouse.getX(), love.mouse.getY())
	if (self.parent:is_mouse_over() and b == 1 and self.parent.focused and math.point_in_box(mx, my, self:box_full())) then
		self.focused = true;
	end
end

function dnkCheckbox:mousereleased(x, y, b)
	if self.focused then
		self:call("press");
		self.on = not self.on;
	end
	self.focused = false;
end

function dnkCheckbox:box_full()
	return 0, 0, 32, 16
end