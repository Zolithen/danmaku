-- TODO: Should we use an ECS to handle this kinda stuff or wut
-- i literally have no idea what i'm doing

gui.ClickableArea = {}

set_union(gui.ClickableArea, gui.Events);

function gui.ClickableArea.new(x, y, w, h)
	local self = {
		x = x,
		y = y,
		w = w,
		h = h,
		focused = false;
	};

	setmetatable(self, {
		__index = gui.ClickableArea
	})
	self:setup_events();

	return self;
end

function gui.ClickableArea:update(dt, mx, my)
	if self.focused then
		if not math.point_in_box(mx, my, self:box_full()) then
			self.focused = false;
		end
	end
end

function gui.ClickableArea:draw(mx, my)
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

function gui.ClickableArea:mousepressed(x, y, b)
	if (b == 1 and self.parent.focused and math.point_in_box(x, y, self:box_full())) then
		self.focused = true;
	end
end

function gui.ClickableArea:mousereleased(x, y, b)
	if self.focused then
		self:call("press");
	end
	self.focused = false;
end

function gui.ClickableArea:box_full()
	return self.x, self.y, self.w, self.h
end