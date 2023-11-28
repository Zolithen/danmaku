dnkButton = dnkElement:extend("dnkButton");

-- A text button can be a group with a dnkClickableArea and dnkLabel as children! (OOP brainrot)
function dnkButton:init(parent, name, x, y, text)
	dnkButton.super.init(self, parent, name, x, y);
	self.text = text;
	self.w = 0;
	self.h = 0;
	self.focused = false;

	self:set_text(self.text);

	return self;
end

function dnkButton:update(dt)
	local mx, my = self:transform_vector(love.mouse.getX(), love.mouse.getY());
	if self.focused then
		if not math.point_in_box(mx, my, self:box_full()) then
			self.focused = false;
		end
	end
end

-- TODO: make sure this works correctly
function dnkButton:draw()
	local mx, my = self:transform_vector(love.mouse.getX(), love.mouse.getY());
	-- TODO: Use get_holder here i guess
	if (self.parent:is_mouse_over() and (self.parent.focused and self.focused)) then
		lg.setColor(gui.Skin.back_highlight2);
	elseif self.parent:is_mouse_over() and (self.parent.focused and math.point_in_box(mx, my, self:box_full())) then
		lg.setColor(gui.Skin.back_highlight);
	else
		lg.setColor(gui.Skin.back_light);
	end
	lg.rectangle("fill", self.x, self.y, self.w, self.h);
	lg.setColor(1, 1, 1, 1);
	lg.draw(self.texture, self.x+4, self.y+2);
end

function dnkButton:mousepressed(x, y, b)
	local mx, my = self:transform_vector(love.mouse.getX(), love.mouse.getY())
	if (self.parent:is_mouse_over() and b == 1 and self.parent.focused and math.point_in_box(mx, my, self:box_full())) then
		self.focused = true;
	end
end

function dnkButton:mousereleased(x, y, b)
	if self.focused then
		self:call("press");
	end
	self.focused = false;
end

function dnkButton:set_text(t)
	self.text = t;
	if self.texture then self.texture:release() end;
	self.texture = love.graphics.newText(gui.Skin.font, self.text);

	self.w = self.texture:getWidth()+8;
	self.h = self.texture:getHeight()+4;
end

function dnkButton:box_full()
	return 0, 0, self.w, self.h
end