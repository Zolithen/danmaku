-- TODO: Should we use a component system to handle this kinda stuff or wut
-- i literally have no idea what i'm doing

dnkClickableArea = dnkElement:extend("dnkClickableArea")

function dnkClickableArea:init(parent, name, x, y, w, h)
	dnkClickableArea.super.init(self, parent, name, x, y);

	self.w = w;
	self.h = h;
	self.focused = false;
end

function dnkClickableArea:update(dt)
	local mx, my = self:transform_vector(love.mouse.getX(), love.mouse.getY());
	if self.focused then
		if not math.point_in_box(mx, my, self:box_full()) then
			self.focused = false;
		end
	end
end

function dnkClickableArea:draw()
	local mx, my = self:transform_vector(love.mouse.getX(), love.mouse.getY());
	if (self.parent:is_mouse_over() and (self.parent.focused and self.focused)) then
		lg.setColor(gui.Skin.back_highlight2);
	elseif self.parent:is_mouse_over() and (self.parent.focused and math.point_in_box(mx, my, self:box_full())) then
		lg.setColor(gui.Skin.back_highlight);
	else
		lg.setColor(gui.Skin.back_light);
	end
	lg.rectangle("fill", self.x, self.y, self.w, self.h);
	lg.setColor(1, 1, 1, 1);
end

function dnkClickableArea:mousepressed(x, y, b)
	local mx, my = self:transform_vector(love.mouse.getX(), love.mouse.getY())
	if (b == 1 and self.parent.focused and math.point_in_box(mx, my, self:box_full())) then
		self.focused = true;
	end
end

function dnkClickableArea:mousereleased(x, y, b)
	if self.focused then
		self:call("press");
	end
	self.focused = false;
end

function dnkClickableArea:box_full()
	return 0, 0, self.w, self.h
end