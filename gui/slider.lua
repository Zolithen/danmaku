gui.Slider = {}

set_union(gui.Slider, gui.Events);

function gui.Slider.new(x, y, w, h)
	local self = {
		x = x,
		y = y,
		w = math.max(16, w),
		h = math.max(16, h),
		boxx = 0,
		boxy = 0,
		boxw = 16,
		boxh = 16,

		-- Used to correctly call the slide event 
		last_boxx = 0,
		last_boxy = 0,

		focused = false, -- Focused here is the same as dragging
		dox = 0,
		doy = 0;
	};

	setmetatable(self, {
		__index = gui.Slider
	})
	self:setup_events();

	return self;
end

function gui.Slider:update(dt, mx, my)
	if self.focused then
		--[[self.boxx = math.clamp((mx - self.x) - self.dox, 0, self.w-self.boxw);
		self.boxy = math.clamp((my - self.y) - self.doy, 0, self.h-self.boxh);]]
		self.boxx = math.clamp(mx + self.dox, 0, self.w-self.boxw);
		self.boxy = math.clamp(my + self.doy, 0, self.h-self.boxh);

		if self.last_boxx ~= self.boxx or self.last_boxy ~= self.boxy then
			self.last_boxx = self.boxx;
			self.last_boxy = self.boxy;			
		end
	end
end

-- TODO: Fix weird highlighting
function gui.Slider:draw(mx, my)
	lg.setColor(gui.Skin.back3);
	lg.rectangle("fill", self.x, self.y, self.w, self.h);
	if self.focused then
		lg.setColor(gui.Skin.back_highlight2);
	elseif (self.parent:is_mouse_over() and self.parent.focused and math.point_in_box(mx, my, self:box_slider())) then
		lg.setColor(gui.Skin.back_highlight);
	else
		lg.setColor(gui.Skin.back_light);
	end
	lg.rectangle("fill", self.x+self.boxx, self.y+self.boxy, self.boxw, self.boxh);
end

function gui.Slider:mousepressed(x, y, b)
	if (b == 1 and self.parent.focused and math.point_in_box(x, y, self:box_slider())) then
		self.focused = true;
		--[[self.dox = (x - self.x) - self.boxx;
		self.doy = (y - self.y) - self.boxy;]]
		self.dox = self.boxx - x;
		self.doy = self.boxy - y;

		self.last_boxx = self.boxx;
		self.last_boxy = self.boxy;
	end
end

function gui.Slider:mousereleased(x, y, b)
	--[[if self.focused then
		self:call("press");
	end]]
	self.focused = false;
end

function gui.Slider:box_full()
	return self.x, self.y, self.w, self.h
end

function gui.Slider:box_slider()
	return self.x + self.boxx, self.y + self.boxy, self.boxw, self.boxh
end