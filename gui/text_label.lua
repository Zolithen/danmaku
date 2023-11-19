dnkLabel = dnkElement:extend("dnkLabel")

function dnkLabel:init(parent, name, x, y, text)
	dnkLabel.super.init(self, parent, name, x, y);
	self.text = text;
	self.texture = lg.newText(gui.Skin.font, self.text);

	return self
end

function dnkLabel:draw()
	lg.setColor(1, 1, 1, 1);
	lg.draw(self.texture, self.x, self.y);
end

--[[
	API FUNCTIONS
]]

function dnkLabel:get_width()
	return self.texture:getWidth();
end

function dnkLabel:set_text(t)
	self.text = t;
	self.texture:release();
	self.texture = love.graphics.newText(skin.font, self.text);
end