require "tree"
lg = love.graphics;
utf8 = require "utf8"
require "gui"
ANDROID = gui.android

--[[TestNode = Node:extend("TestNode");
function TestNode:test()
	print(self.name)
	if self.name == "children2" then
		return NodeResponse.hwall
	end
end

local test1 = TestNode(nil, "parent");
local children1 = TestNode(test1, "children1");
local children2 = TestNode(test1, "children2");
local children3 = TestNode(test1, "children3");
TestNode(children1, "children1,1");
TestNode(children1, "children1,2");
TestNode(children2, "children2,1");
TestNode(children2, "children2,2");
TestNode(children2, "children2,3");
TestNode(children3, "children3,1");
TestNode(children3, "children3,2");
TestNode(children3, "children3,3");
TestNode(children3, "children3,4");
test1:propagate_event("test");]]

function love.load(args)
	-- how would i make scrollable sections bigger than whatever the fuck the system limit is? skill issue solved easily
	--[[for i, v in pairs(lg.getSystemLimits()) do
		print(i, v);
	end]]
	love.keyboard.setKeyRepeat(true);
	lg.setLineStyle("rough");
	lg.setLineWidth(1);
	--main_win = gui:new_window(100, 100, 200, 200, "main", "Main");
	--sec_win = gui:new_window(400, 400, 100, 100, "sec", "Secondary");
	--main_win:add_element(gui.Label.new(0, 0, "test"))
	--main_win:add_element(gui.Label.new(0, 0, "Name: "));
	--test = main_win:add_element(gui.TextInput.new(0, 16, 100, 16));
	--[[test:connect("enter_text", function(t)
		
	end)]]

	--main_win:add_element(gui.Label.new(0, 0, "sharpness"));

	if gui.android then
		love.window.setFullscreen(true);
	end

	local gui_instance = loadstring(get_file("instance/music_player.lua"))
	gui_instance(winc);
end

function love.update(dt)
	gui:propagate_event("update", dt);

	if other_update then
		other_update(dt);
	end
end

function love.draw()
	gui:propagate_event_reverse("draw");
	--gui:propagate_event_reverse("postdraw");
	lg.setColor(1, 1, 1, 1);
	lg.print(string.format("FPS: %d", love.timer.getFPS()), lg.getWidth() - 100, 16);

	lg.setColor(1, 0, 0, 1);

	local mx, my = love.mouse.getX(), love.mouse.getY();
	lg.line(mx-10, my, mx+10, my);
	lg.line(mx, my-10, mx, my+10);

	if other_draw then
		other_draw();
	end
end

function love.mousemoved(x, y, dx, dy)
	gui:propagate_event("mousemoved", x, y, dy, dx);
end

function love.mousereleased(x, y, b)
	gui:propagate_event("mousereleased", x, y, b);
end

function love.mousepressed(x, y, b)
	gui:propagate_event("mousepressed", x, y, b);
end

function love.keypressed(key, scancode, is_repeat)
	gui:propagate_event("keypressed", key, scancode, is_repeat);
	--[[if key == "f4" then
		local gui_instance = loadstring(get_file("instance/item_editor.lua"))
		gui_instance(winc);
	end]]
end

function love.textinput(t)
	gui:propagate_event("textinput", t);
end

function get_file(file)
    --[[local f = assert(io.open(file, "rb"))
    local content = f:read("*all")
    f:close()
    return content]]
    return love.filesystem.read(file);
end