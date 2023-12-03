dnkPanel = dnkElement:extend("dnkPanel")

function dnkPanel:init(parent, name, x, y, w, h)
	dnkPanel.super.init(self, parent, name, x, y);

	self.w = w;
	self.h = h;
	self.canvas = lg.newCanvas(self.w, self.h);
	self.focused = false;
	self.border = true;

	self.transx = 0;
	self.transy = 0;
end

function dnkPanel:resize(new_w, new_h)
	self.w = new_w;
	self.h = new_h;
	self.canvas:release();
	self.canvas = lg.newCanvas(self.w, self.h);
end

function dnkPanel:update(dt)
	self.focused = self.parent.focused;
end

function dnkPanel:draw()
	-- TODO: Probably only draw the canvas again if something has changed
	lg.push("all");
		lg.origin();
		lg.translate(self.transx, self.transy);
		lg.setCanvas(self.canvas);
		lg.clear();
end

function dnkPanel:draw_after_children()
		lg.setCanvas();
	lg.pop();
	
	if self.border then
		if self.focused then
			lg.setColor(gui.Skin.green);
		else
			lg.setColor(gui.Skin.red);
		end
		local bw = gui.Skin.window_border_width;
		lg.rectangle("fill", self.x-bw, self.y-bw, self.w+bw*2, self.h+bw*2);
	end
	
	lg.setColor(gui.Skin.back);
	lg.rectangle("fill", self.x, self.y, self.w, self.h);

	lg.setColor(1, 1, 1, 1);
	lg.draw(self.canvas, self.x, self.y);
end

function dnkPanel:is_mouse_over()
	local mx, my = self:transform_vector(love.mouse.getX(), love.mouse.getY());
	mx = mx + self.transx;
	my = my + self.transy;
	return math.point_in_box(mx, my, self:box_full()) and self.parent:is_mouse_over(); -- TODO: We assume we have a parent here.
end

function dnkPanel:transform_vector(x, y)
	if self.parent == nil then
		return x - self.x - self.transx, y - self.y - self.transy
	else
		local nx, ny = self.parent:transform_vector(x, y);
		return nx - self.x - self.transx, ny - self.y - self.transy
	end
end

function dnkPanel:is_holder()
	return true;
end

function dnkPanel:box_full()
	return 0, 0, self.w, self.h;
end