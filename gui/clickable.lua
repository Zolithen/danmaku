-- TODO: Should we use an ECS to handle this kinda stuff or wut
-- i literally have no idea what i'm doing

local Clickable = {}

function Clickable.new(x, y, w, h)
	local self = {
		x = x,
		y = y,
		w = w,
		h = h,
		focused = false;
	};

	setmetatable(self, {
		__index = Clickable
	})
	self:setup_events();

	return self;
end

function Clickable:load(skin, id, window)
	self.skin = skin;
	self.id = id or math.uuid();
	self.window = window;
end

function Clickable:update(dt, mx, my)
	if self.focused then
		if not math.point_in_box(mx, my, self:box_full()) then
			self.focused = false;
		end
	end
end

function Clickable:draw(mx, my)
	if (self.window:is_mouse_over() and (self.window.focused and self.focused)) then
		lg.setColor(self.skin.back_highlight2);
	elseif self.window:is_mouse_over() and (self.window.focused and math.point_in_box(mx, my, self:box_full())) then
		lg.setColor(self.skin.back_highlight);
	else
		lg.setColor(self.skin.back_light);
	end
	lg.rectangle("fill", self.x, self.y, self.w, self.h);
	lg.setColor(1, 1, 1, 1);
end

function Clickable:mousepressed(x, y, b)
	if (b == 1 and self.window.focused and math.point_in_box(x, y, self:box_full())) then
		self.focused = true;
	end
end

function Clickable:mousereleased(x, y, b)
	if self.focused then
		self:call("press");
	end
	self.focused = false;
end

function Clickable:box_full()
	return self.x, self.y, self.w, self.h
end

return Clickable;