dnkLabel = dnkElement:extend("dnkLabel")

function dnkLabel:init(parent, name, x, y, text)
	dnkLabel.super.init(self, parent, name, x, y);
	self.text = text;
	self.texture = lg.newText(gui.Skin.font, self.text);

	return self
end

function dnkLabel:update(dt)
	-- TODO: Do we need a hover on a label? May be a bit expensive with lots of labels
	--[[dnkElement.update(self, dt)
	local mx, my = self:transform_vector(love.mouse.getX(), love.mouse.getY());
	if math.point_in_box(mx, my, self:box_full()) then
		self:call("hover");
	end]]
end

function dnkLabel:draw()
	lg.setColor(1, 1, 1, 1);
	lg.draw(self.texture, self.x, self.y);
end

function dnkLabel:get_width()
	return self.texture:getWidth();
end

function dnkLabel:set_text(t)
	self.text = t;
	self.texture:release();
	self.texture = love.graphics.newText(gui.Skin.font, self.text);
end

function dnkLabel:box_full()
	return 0, 0, self.texture:getWidth(), self.texture:getHeight();
end