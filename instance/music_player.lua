local main = dnkWindow(gui, 0, 0, lg.getWidth(), lg.getHeight(), gui.Skin, nil, "test");
main.movable = false;
main.minimizable = false;
main.expandable = false;
local slider = dnkSlider(main, "slider", lg.getWidth()-16, 0, 16, lg.getHeight()-16);
slider.boxw = 16;
slider.boxh = 24;
local panel = dnkPanel(main, "panel", 0, 0, lg.getWidth()-16, lg.getHeight()-16);
bar = {};
layout_amount = 0;
layout_wide = {}

--[[function draw_rectangle(self)
	lg.setColor(gui.Skin.back_light);
	lg.rectangle("fill", self.x, self.y, self.w, self.h);
	lg.setColor(1, 1, 1, 1);
end]]

function laywide_add(t)
	local a = dnkClickableArea(
		panel, "", 0, layout_amount*50, lg.getWidth()-16, 50
	)
	--[[local a = dnkElement(
		panel, "", 0, layout_amount*50
	);
	a.w = lg.getWidth()-16;
	a.h = 50;
	a.draw = draw_rectangle;]]
	local b = dnkLabel(
		panel, "", 0, layout_amount*50, t	
	)
	layout_amount = layout_amount + 1;

	table.insert(layout_wide, {a, b});
	return a;
end

local songs = love.filesystem.getDirectoryItems("songs")
for i, v in ipairs(songs) do
	laywide_add(v);
end

function other_update()
	panel.transx = slider.boxx;
	panel.transy = -slider.boxy;
end

function love.resize()
	main:resize(lg.getWidth(), lg.getHeight());
	panel:resize(lg.getWidth()-16, lg.getHeight()-16);

	-- Handle the layout
	for i, v in ipairs(layout_wide) do
		v[1].w = lg.getWidth()-16;
	end
	slider.x = lg.getWidth()-16;
	slider.h = lg.getHeight()-16;

	slider.boxy = math.clamp(slider.boxy, 0, slider.h - slider.boxh);
end