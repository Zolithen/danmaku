main = gui:new_window(0, 0, lg.getWidth(), lg.getHeight(), "main", "Main");
main.movable = false;
main.minimizable = false;
main.expandable = false;

--[[local but = main:add_element(gui.TextButton.new(
	0, 0, "test"
));]]

local layout_wide = {}
local layout_amount = 0;

function laywide_add(t)
	local a = main:add_element(gui.ClickableArea.new(
		0, layout_amount*50, lg.getWidth()-16, 50
	))
	main:add_element(gui.Label.new(
		0, layout_amount*50, t	
	))
	layout_amount = layout_amount + 1;

	table.insert(layout_wide, a);
	return a;
end

laywide_add("Slowdive - Falling Ashes")
laywide_add("Holy Fawn - Dimensional Bleed")
laywide_add("death insurance - ohmyg0d")

local bar = main:add_element(gui.Slider.new(
	lg.getWidth()-16,
	0,
	16,
	lg.getHeight()-16
));

function other_update()
	--main.transy = main.transy - 1;
end

function other_draw()
	lg.print(tostring(bar.boxx), 0, 160)
end

function love.resize(w, h)
	main:resize(lg.getWidth(), lg.getHeight());

	-- Handle the layout
	for i, v in ipairs(layout_wide) do
		v.w = lg.getWidth()-16;
	end
	bar.x = lg.getWidth()-16;
	bar.h = lg.getHeight()-16;
end