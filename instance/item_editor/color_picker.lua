dnkColorPicker = dnkSlider:extend("dnkColorPicker");

function dnkColorPicker:init(parent, name, x, y, w, h)
	dnkColorPicker.super.init(self, parent, name, x, y, w, h);
	self.boxh = 16;
	self._colors = love.image.newImageData(w, h);
	self._colors:mapPixel(function(x, y, r, g, b, a)
		-- TODO: Make this use HSV
		return (x/w)*(y/h)*0.5, (y/h)*0.5, 0.5, 1
	end)
	self.colors = lg.newImage(self._colors);
end

function dnkColorPicker:draw()
	lg.setColor(1, 1, 1, 1);
	lg.draw(self.colors, self.x, self.y);
	if self.focused then
		lg.setColor(gui.Skin.back_highlight2);
	--elseif (self.parent:is_mouse_over() and self.parent.focused and math.point_in_box(mx, my, self:box_slider())) then
	--	lg.setColor(gui.Skin.back_highlight);
	else
		lg.setColor(gui.Skin.back_light);
	end
	lg.rectangle("fill", self.x+self.boxx, self.y+self.boxy, self.boxw, self.boxh);
end