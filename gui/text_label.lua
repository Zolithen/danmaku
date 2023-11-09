local Label = {}

function Label.new(x, y, text)
	local self = {
		x = x,
		y = y,
		text = text
	}

	setmetatable(self, {
		__index = Label
	})

	return self
end

function Label:load(skin, id, window)
	self.texture = love.graphics.newText(skin.font, self.text);
	self.skin = skin;
	self.id = id or math.uuid();
	self.window = window; 
end

function Label:draw()
	lg.setColor(1, 1, 1, 1);
	lg.draw(self.texture, self.x, self.y);
end

--[[
	API FUNCTIONS
]]

function Label:get_width()
	return self.texture:getWidth();
end

function Label:set_text(t)
	self.text = t;
	self.texture:release();
	self.texture = love.graphics.newText(skin.font, self.text);
end

return Label;