-- We use HSV as an input method for the color picker to make the color space a bit more easy to traverse
-- If we were to use RGB then it would be harder to get to the desired color (ex. if i want an specific shade of magenta
-- i would need to mix red and blue and then modify all three to get the shade of magenta i want, with hsv
-- i can just pick an area around magenta on the diagram and then choose the brightness. much easier)

local ValueSlider = dnkSlider:extend("ValueSlider");
dnkColorPicker = dnkSlider:extend("dnkColorPicker");

function ValueSlider:init(parent, name, x, y, w, h, start_h, start_s)
	dnkSlider.init(self, parent, name, x, y, w, h);
	self.boxh = 16;
	self.boxw = 1;
	self.boxx = w;
	self.go_to_click = true;
	self._colors = love.image.newImageData(w, h);
	self._colors:mapPixel(function(x, y, r, g, b, a)
		local v = x/self.w;
		return math.hsv2rgb(start_h, start_s, v);
	end)
	self.colors = lg.newImage(self._colors);
end

-- TODO: Be careful. May leak memory (it's probably fixed)
function ValueSlider:update_color(h, s)
	self.colors:release();
	self._colors:mapPixel(function(x, y, r, g, b, a)
		local v = x/self.w;
		return math.hsv2rgb(h, s, v);
	end)
	self.colors = lg.newImage(self._colors);
end

function ValueSlider:draw()
	lg.setColor(1, 1, 1, 1);
	lg.draw(self.colors, self.x, self.y);
	lg.setColor(1, 1, 1, 1);
	lg.draw(self.colors, self.x, self.y);
	if self.focused then
		lg.setColor(gui.Skin.back_highlight2);
	else
		lg.setColor(gui.Skin.back_light);
	end
	lg.rectangle("fill", self.x+self.boxx, self.y+self.boxy, self.boxw, self.boxh);
end

-- TODO: The box_full method of this class only englobes the box of the h-s picker itself. It doesn't take into account the other slider
-- Consider if this is a problem for multi-element elements.
function dnkColorPicker:init(parent, name, x, y, w, h)
	dnkColorPicker.super.init(self, parent, name, x, y, 200, 200);
	self.boxh = 1;
	self.boxw = 1;
	self.go_to_click = true;
	self._colors = love.image.newImageData(w, h);
	self._colors:mapPixel(function(x, y, r, g, b, a)
		local tx, ty = (x/w) - (1/2), (y/h) - (1/2);
		local rr, gg, bb = math.hsv2rgb(tx + (1/2), ty + (1/2), 1);
		return rr, gg, bb, 1
	end)
	self.colors = lg.newImage(self._colors);
	self.value_slider = ValueSlider(self, "value_slider", 0, self.h+10, self.w, 16, self.boxx/self.w, self.boxy/self.h):connect("moved", function()
		self:call("color_change");
	end);

	self:connect("moved", function()
		self.value_slider:update_color(self.boxx/self.w, self.boxy/self.h);
		self:call("color_change");
	end)

	self.fields = {
		r = dnkField(self, "rfield", self.h+30, 0, "R", dnkField.type.number)
	}
end

function dnkColorPicker:draw()
	lg.setColor(1, 1, 1, 1);
	lg.draw(self.colors, self.x, self.y);
	if self.focused then
		lg.setColor(gui.Skin.back_highlight2);
	--elseif (self.parent:is_mouse_over() and self.parent.focused and math.point_in_box(mx, my, self:box_slider())) then
	--	lg.setColor(gui.Skin.back_h3ighlight);
	else
		lg.setColor(gui.Skin.back_light);
	end
	lg.rectangle("fill", self.x+self.boxx, self.y+self.boxy, self.boxw, self.boxh);
	lg.setColor(1, 0, 0, 1);

	local mx, my = self.x+self.boxx, self.y+self.boxy;
	lg.line(mx-10, my, mx+10, my);
	lg.line(mx, my-10, mx, my+10);

	lg.push("all");
		lg.setCanvas();
		lg.setColor(self:picked_color());
		lg.rectangle("fill", 0, 0, 32, 32);
	lg.pop();

	-- TODO: Search for an actual solution to the positioning that isn't bugged in subholders and stuff
	-- How the engine handles drawing coordinates and logic coordinates is different. This is fucking stupid
	-- So, to draw the value slider, due to the coordinates being in-window/in-graphic-holder instead of local we move the slider down via a graphics translation.
	-- This keeps the logic working correctly bcs it uses local coordinates and the graphics look correct too
	-- It would probably be a good idea to standarize the coordinate systems and use local for everything bcs what is this
	-- Having "global" coordinates for drawing allows for more powerful stuff when drawing, but this kind of things are needed rarely
	-- Having that need a workaround instead of this which is probably gonna be needed more commonly for sets of elements and stuff is better
	lg.translate(0, self.y);
end

function dnkColorPicker:draw_after_children()
	lg.translate(0, -self.y);
end

function dnkColorPicker:set_color(r, g, b)
	r, g, b = math.clamp(r, 0, 1), math.clamp(g, 0, 1), math.clamp(b, 0, 1);
	local h, s, v = math.rgb2hsv(r, g, b, 1);
	self.boxx = h*self.w;
	self.boxy = s*self.h;
	self.value_slider.boxx = v*self.value_slider.w;
end

function dnkColorPicker:picked_color()
	return math.hsv2rgb(self.boxx/self.w, self.boxy/self.h, self.value_slider.boxx/self.value_slider.w);
end

function dnkColorPicker:is_holder()
	return true;
end