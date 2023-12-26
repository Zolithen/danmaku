dnkSlider = dnkElement:extend("dnkSlider")

function dnkSlider:init(parent, name, x, y, w, h)
	dnkSlider.super.init(self, parent, name, x, y, w, h);
	self.w = math.max(16, w);
	self.h = math.max(16, h);
	self.boxx = 0;
	self.boxy = 0;
	self.boxw = 16;
	self.boxh = 32;

	-- Used to correctly call the slide event
	self.last_boxx = 0;
	self.last_boxy = 0;

	self.focused = false; -- Focused here is the same as dragging
	self.dox = 0;
	self.doy = 0;

	return self;
end

function dnkSlider:update(dt)
	dnkElement.update(self, dt);
	local mx, my = self:transform_vector(love.mouse.getX(), love.mouse.getY());
	if self.focused then
		self.boxx = math.clamp(mx + self.dox, 0, self.w-self.boxw);
		self.boxy = math.clamp(my + self.doy, 0, self.h-self.boxh);

		if self.last_boxx ~= self.boxx or self.last_boxy ~= self.boxy then
			self.last_boxx = self.boxx;
			self.last_boxy = self.boxy;			

			-- TODO: Put all the code here
			if self.bound_to then -- Update the displacement of the bound to panel
				-- TODO: Check if the floor here gives no errors over all and consider putting the floor in the lg.translate in panel&window draw funcs

				self.bound_to.transy = math.floor(
					((math.max(self.bound_to.h, self.bound_to.content_height) - self.bound_to.h) / (self.h - self.boxh)) * -self.boxy
				)
			end
		end
	end

	if self.bound_to then
		self:state_from_bound()
	end
end

-- TODO: Fix weird highlighting
function dnkSlider:draw()
	lg.setColor(gui.Skin.back3);
	lg.rectangle("fill", self.x, self.y, self.w, self.h);
	if self.focused then
		lg.setColor(gui.Skin.back_highlight2);
	--elseif (self.parent:is_mouse_over() and self.parent.focused and math.point_in_box(mx, my, self:box_slider())) then
	--	lg.setColor(gui.Skin.back_highlight);
	else
		lg.setColor(gui.Skin.back_light);
	end
	lg.rectangle("fill", self.x+self.boxx, self.y+self.boxy, self.boxw, self.boxh);
end

function dnkSlider:mousepressed(x, y, b)
	local mx, my = self:transform_vector(love.mouse.getX(), love.mouse.getY());
	if (b == 1 and self:get_root_(1).focused and math.point_in_box(mx, my, self:box_slider())) then
		self.focused = true;

		self.dox = self.boxx - mx;
		self.doy = self.boxy - my;

		self.last_boxx = self.boxx;
		self.last_boxy = self.boxy;
	end
end

function dnkSlider:mousereleased(x, y, b)
	if self.focused then
		self:call("press");
	end
	self.focused = false;
end

-- Binds the slider to a panel so that it scrolls down with the slider
function dnkSlider:bind(p)
	self.bound_to = p;
	if not p.instanceOf then
		error("Trying to bind non 30log object to slider.");
	else
		if not p:instanceOf(dnkPanel) then
			error("Trying to bind non dnkPanel to slider.");
		end
	end

	return self;
end

function dnkSlider:rebind(p)
	self.bound_to = p;
	if not p.instanceOf then
		error("Trying to bind non 30log object to slider.");
	else
		if not p:instanceOf(dnkPanel) then
			error("Trying to bind non dnkPanel to slider.");
		end
	end
	self:state_from_bound();

	return self;
end

function dnkSlider:state_from_bound()
	local newh_c = math.max(self.bound_to.h + 1, self.bound_to.content_height);
	local y_p = -self.bound_to.transy;
	local y_b = math.max(self.boxy, 0.1);
	local h_p = self.bound_to.h;
	local h_s = self.h;
	local h_b = self.boxh;
	local h_c = (y_p / y_b) * (h_s - h_b) + h_p;
	local newh_b = h_s * (h_p / newh_c)
	self.boxh = newh_b;
	self.boxy = math.max(1, ((h_s - newh_b) * (h_c - h_p)) / ((newh_c - h_p) * (h_s - h_b)) * y_b);
end

function dnkSlider:box_full()
	return 0, 0, self.w, self.h
end

function dnkSlider:box_slider()
	return self.boxx, self.boxy, self.boxw, self.boxh
end