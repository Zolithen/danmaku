lk = love.keyboard
BOOL_TO_NUMBER = {
	[true] = 1,
	[false] = 0
}
local windows = {p = {}}
windows.sim = dnkWindow(gui, 0, 0, 300, 300, gui.Skin, "sim", "Simulation");
windows.sim.expandable = false;
dnkWindow(gui, 300, 300, 300, 300, gui.Skin, "test", "testt");

SimCanvas = dnkCanvas:extend("SimCanvas");

function SimCanvas:init(parent, name, x, y, w, h)
	SimCanvas.super.init(self, parent, name, x, y, w, h);
	self.px = 0;
	self.py = 0;
end

function SimCanvas:update(dt)
	dnkCanvas.update(self, dt);
	if self:get_root_(1).focused and not self:get_root_(1).minim then
		local mx = BOOL_TO_NUMBER[lk.isDown("d")] - BOOL_TO_NUMBER[lk.isDown("a")];
		local my = BOOL_TO_NUMBER[lk.isDown("s")] - BOOL_TO_NUMBER[lk.isDown("w")];
		self.px = self.px + 3*mx;
		self.py = self.py + 3*my;
	end
end

function SimCanvas:canvas_draw()
	lg.clear(0, 0, 0, 1);
	lg.rectangle("fill", self.px, self.py, 16, 16);
end

local canvas = SimCanvas(windows.sim, "canvas", 0, 0, 300, 300);