if ANDROID then
	love.audio.setMixWithSystem(true);
end
main = gui:new_window(0, 0, lg.getWidth(), lg.getHeight(), "main", "Main");
main.movable = false;
main.minimizable = false;
main.expandable = false;

--[[local but = main:add_element(gui.TextButton.new(
	0, 0, "test"
));]]

local layout_wide = {}
local layout_amount = 0;

local panel = main:add_element(gui.Panel.new(
	0, 0, lg.getWidth()-16, lg.getHeight()-16 
))

function laywide_add(t)
	local a = panel:add_element(gui.ClickableArea.new(
		0, layout_amount*50, lg.getWidth()-16, 50
	))
	local b = panel:add_element(gui.Label.new(
		0, layout_amount*50, t	
	))
	layout_amount = layout_amount + 1;

	table.insert(layout_wide, {a, b});
	return a;
end

function laywide_remove(i)
	local v = layout_wide[i];
	table.remove(layout_wide, i);
	layout_amount = layout_amount - 1;
	panel:remove_element(v[1].id);
	panel:remove_element(v[2].id);
end

function laywide_empty()
	for i, v in r_ipairs(layout_wide) do
		laywide_remove(i);
	end
end

local songs = love.filesystem.getDirectoryItems("songs")
for i, v in ipairs(songs) do
	laywide_add(v);
end

--[[laywide_add("Slowdive - Falling Ashes")
laywide_add("Holy Fawn - Dimensional Bleed")
laywide_add("death insurance - ohmyg0d")]]

local bar = main:add_element(gui.Slider.new(
	lg.getWidth()-16,
	0,
	16,
	lg.getHeight()-16
));

function other_update()
	panel.transy = -bar.boxy;
	if love.keyboard.isDown("p") then
		laywide_empty();
	end
	--main.transy = main.transy - 1;
end

function other_draw()

end

function love.resize(w, h)
	main:resize(lg.getWidth(), lg.getHeight());
	panel:resize(lg.getWidth()-16, lg.getHeight()-16);

	-- Handle the layout
	for i, v in ipairs(layout_wide) do
		v.w = lg.getWidth()-16;
	end
	bar.x = lg.getWidth()-16;
	bar.h = lg.getHeight()-16;
end