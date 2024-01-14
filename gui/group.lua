dnkGroup = dnkElement:extend("dnkGroup")

function dnkGroup:init(parent, name, x, y)
	dnkGroup.super.init(self, parent, name, x, y);
end

function dnkGroup:draw()
	lg.translate(self.x, self.y);
end

function dnkGroup:draw_after_children()
	lg.translate(-self.x, -self.y);
end

function dnkGroup:update(dt) -- TODO: Change all occurences of parent.focused to holder.focused or some bullshit
	dnkElement.update(self, dt);
	self.focused = self.parent.focused;
end

function dnkGroup:is_holder()
	return true;
end

function dnkGroup:is_mouse_over()
	return self.parent:is_mouse_over();
end