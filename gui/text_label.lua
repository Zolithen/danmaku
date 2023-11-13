gui.Label = {}

function gui.Label.new(x, y, text)
	local self = {
		x = x,
		y = y,
		text = text
	}
	self.texture = love.graphics.newText(gui.Skin.font, self.text);

	setmetatable(self, {
		__index = gui.Label
	})

	return self
end

function gui.Label:draw()
	lg.setColor(1, 1, 1, 1);
	lg.draw(self.texture, self.x, self.y);
end

--[[
	API FUNCTIONS
]]

function gui.Label:get_width()
	return self.texture:getWidth();
end

function gui.Label:set_text(t)
	self.text = t;
	self.texture:release();
	self.texture = love.graphics.newText(skin.font, self.text);
end