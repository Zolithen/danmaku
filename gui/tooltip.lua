dnkTooltip = dnkElement:extend("dnkTooltip")

function dnkTooltip:init(parent, name, x, y, w, h)
	dnkElement.init(self, parent, name, x, y);
	self.w = w;
	self.h = h;
	self.canvas = lg.newCanvas(w, h);
	self.focused = true;
	self.transy = 0;
end

function dnkTooltip:resize(neww, newh)
	self.w = neww;
	self.h = newh;
	self.canvas:release();
	self.canvas = lg.newCanvas(self.w, self.h);
end

function dnkTooltip:draw()
	lg.setColor(gui.Skin.back);
	lg.rectangle("fill", self.x, self.y, self.w, self.h);

	lg.push("all");
		lg.setCanvas(self.canvas);
		lg.clear(0, 0, 0, 0);
		lg.origin();
		lg.setColor(1, 1, 1, 1);
		lg.translate(0, -self.transy);
end

function dnkTooltip:draw_after_children()
		lg.translate(0, self.transy);
		lg.setCanvas();
	lg.pop();
	lg.setColor(1, 1, 1, 1);
	lg.draw(self.canvas, self.x, self.y);
end

-- TODO: This is kinda stupid: If we don't click a tooltip, should it dissapear?
-- SOLUTION: All floating gui stuff shouldn't be just tooltips.
function dnkTooltip:mousepressed(x, y, b)
	local mx, my = self:transform_vector(love.mouse.getX(), love.mouse.getY());
	if math.point_in_box(mx, my, self:box_full()) then
		floatgui.pressed = true;
	else
		self:remove_from_parent();
		return NodeResponse.vwall;
	end
end

function dnkTooltip:is_holder()
	return true;
end

function dnkTooltip:box_full()
	return 0, 0, self.w, self.h;
end