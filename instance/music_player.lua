main = gui:new_window(0, 0, lg.getWidth(), lg.getHeight(), "main", "Main");
main.movable = false;
main.minimizable = false;
main.expandable = false;

--[[local but = main:add_element(gui.TextButton.new(
	0, 0, "test"
));]]

local clickable = main:add_element(gui.ClickableArea.new(
	0, 0, 100, 100
))

function love.resize(w, h)
	main:resize(lg.getWidth(), lg.getHeight());
end