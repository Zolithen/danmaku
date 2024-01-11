-- We use HSV as an input method for the color picker to make the color space a bit more easy to traverse
-- If we were to use RGB then it would be harder to get to the desired color (ex. if i want an specific shade of magenta
-- i would need to mix red and blue and then modify all three to get the shade of magenta i want, with hsv
-- i can just pick an area around magenta on the diagram and then choose the brightness. much easier)

local ValueSlider = dnkSlider:extend("ValueSlider");
local ColorSlider = dnkSlider:extend("ColorSlider");
ColorComponent = dnkClickableArea:extend("ColorComponent");
dnkColorPicker = dnkGroup:extend("dnkColorPicker");

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
	-- TODO: For this sliders we need to copy the draw code from the slider class and remove the drawing of the back rectangle
	-- When we have the Skin system done this could be avoided by simply putting the background color on the skin of the slider to alpha=0
	if self.focused then
		lg.setColor(gui.Skin.back_highlight2);
	else
		lg.setColor(gui.Skin.back_light);
	end
	lg.rectangle("fill", self.x+self.boxx, self.y+self.boxy, self.boxw, self.boxh);
end

function ColorSlider:init(parent, name, x, y, w, h)
	dnkSlider.init(self, parent, name, x, y, 200, 200);
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
end

function ColorSlider:draw()
	lg.setColor(1, 1, 1, 1);
	lg.draw(self.colors, self.x, self.y);

	lg.setColor(gui.Skin.back_light);
	lg.rectangle("fill", self.x+self.boxx, self.y+self.boxy, self.boxw, self.boxh);
	
	lg.setColor(1, 0, 0, 1);
	local mx, my = self.x+self.boxx, self.y+self.boxy;
	lg.line(mx-10, my, mx+10, my);
	lg.line(mx, my-10, mx, my+10);
end

-- TODO: Do we handle the box full of groups?
function dnkColorPicker:init(parent, name, x, y)
	dnkGroup.init(self, parent, name, x, y);

	-- TODO: Should the colors in the color_slider be updated when the value slider moves? So you can see how bright the spectrum is with the current value
	self.color_slider = ColorSlider(self, "color_slider", 0, 0, 200, 200)
	self.value_slider = ValueSlider(self, "value_slider", 0, 210, 200, 16, 0, 0):connect("moved", function()
		self:call("color_change");
	end);

	self.color_slider:connect("moved", function(cs)
		self.value_slider:update_color(cs.boxx/cs.w, cs.boxy/cs.h);
		self:call("color_change");
	end)

	self.fields = {
		r = dnkField(self, "red", 0, 240, "R", dnkField.type.number):connect("finish_text", function(inp)
			local r = (tonumber(inp.text) or 0)/255;
			local _, g, b = self:picked_color();
			self:set_color(r, g, b);
		end),
		g = dnkField(self, "green", 55, 240, "G", dnkField.type.number):connect("finish_text", function(inp)
			local g = (tonumber(inp.text) or 0)/255;
			local r, _, b = self:picked_color();
			self:set_color(r, g, b);
		end),
		b = dnkField(self, "blue", 110, 240, "B", dnkField.type.number):connect("finish_text", function(inp)
			local b = (tonumber(inp.text) or 0)/255;
			local r, g, _ = self:picked_color();
			self:set_color(r, g, b);
		end)
	};

	self.fields.r.input.w = 35;
	self.fields.g.input.w = 35;
	self.fields.b.input.w = 35;

	self.fields.r.input:set_text("255");
	self.fields.g.input:set_text("255");
	self.fields.b.input:set_text("255");

	self:connect("color_change", function()
		local r, g, b = self:picked_color();
		self.fields.r.input:set_text(tostring(math.floor(r*255)));
		self.fields.g.input:set_text(tostring(math.floor(g*255)));
		self.fields.b.input:set_text(tostring(math.floor(b*255)));
	end);
end

function dnkColorPicker:draw()
	dnkGroup.draw(self);
	lg.setColor(self:picked_color());
	lg.rectangle("fill", 200-32, 230, 32, 32);
	lg.setColor(1, 1, 1, 1);
end

function dnkColorPicker:picked_color()
	local cs, vs = self.color_slider, self.value_slider;
	return math.hsv2rgb(cs.boxx/cs.w, cs.boxy/cs.h, vs.boxx/vs.w);
end

function dnkColorPicker:set_color(r, g, b)
	r, g, b = math.clamp(r, 0, 1), math.clamp(g, 0, 1), math.clamp(b, 0, 1);
	local h, s, v = math.rgb2hsv(r, g, b, 1);
	self.color_slider.boxx = h*self.color_slider.w;
	self.color_slider.boxy = s*self.color_slider.h;
	self.value_slider.boxx = v*self.value_slider.w;

	self.value_slider:update_color(h, s);
	self:call("color_change"); -- TODO: Is this a good idea to put here? If we change the color in a color change call this would get called, which is bad
end

function dnkColorPicker:_set_color(r, g, b)
	r, g, b = math.clamp(r, 0, 1), math.clamp(g, 0, 1), math.clamp(b, 0, 1);
	local h, s, v = math.rgb2hsv(r, g, b, 1);
	self.color_slider.boxx = h*self.color_slider.w;
	self.color_slider.boxy = s*self.color_slider.h;
	self.value_slider.boxx = v*self.value_slider.w;

	self.value_slider:update_color(h, s);
	self:call("color_change");
end


function ColorComponent:init(parent, name, x, y)
	ColorComponent.super.init(self, parent, name, x, y, 32, 32);

	self.bound = false;
	self.color = {1, 1, 1, 1};
	self.color_window = gui:find_name_in_children("color"); -- TODO: This assumes the color window is always open. FIXME
	self:connect("press", function(self)
		self.color_window:bind_to_component(self);
	end);
end

function ColorComponent:draw()
	ColorComponent.super.draw(self);
	lg.setColor(self.color);
	lg.rectangle("fill", self.x, self.y, self.w, self.h);
end

function ColorComponent:window_close()
	if self.bound then
		self.color_window:component_is_gone();
	end
end

function ColorComponent:set_color(r, g, b)
	self.color[1] = r;
	self.color[2] = g;
	self.color[3] = b;

	if self.bound then
		self.color_window.color_picker:set_color(r, g, b);
	end
end