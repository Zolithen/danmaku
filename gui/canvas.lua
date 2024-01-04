dnkCanvas = dnkElement:extend("dnkCanvas")

function dnkCanvas:init(parent, name, x, y, w, h)
	dnkCanvas.super.init(self, parent, name, x, y, w, h);
	self.canvas = lg.newCanvas(w, h);
	self.w = w;
	self.h = h;
end

function dnkCanvas:draw()
	lg.setColor(1, 1, 1, 1);
	lg.draw(self.canvas, self.x, self.y);
	if self.canvas_draw then
		lg.push("all");
		lg.setCanvas(self.canvas);
			lg.origin();
			lg.setColor(1, 1, 1, 1);
			self:canvas_draw();
		lg.setCanvas();
		lg.pop();
	end
end

-- This function wipes the canvas blank!
function dnkCanvas:resize(w, h)
	self.w = w;
	self.h = h;
	self.canvas:release();
	self.canvas = lg.newCanvas(w, h);
end

function dnkCanvas:box_full()
	return 0, 0, self.w, self.h;
end