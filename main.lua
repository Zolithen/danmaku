math.randomseed(os.time())
require "tree"
lg = love.graphics;
utf8 = require "utf8"
require "gui"
ANDROID = gui.android

require "datadump"

--[[local test_font = love.graphics.newImageFont("assets/ttf/test.png", "@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_ ")
test_font:setFilter("nearest", "nearest");]]

function love.load(args)
	love.keyboard.setKeyRepeat(true);
	lg.setLineStyle("rough");
	lg.setLineWidth(1);

	if gui.android then
		love.window.setFullscreen(true);
	end

	local gui_instance, e = loadstring(get_file("instance/item_editor/_main.lua"));
	if gui_instance == nil then
		error(e);
	end
	gui_instance(winc);
end

function love.update(dt)
	gui:propagate_event("update", dt);

	if other_update then
		other_update(dt);
	end
end

function love.draw()
	gui:propagate_event("draw");
	lg.setColor(1, 1, 1, 1);

	lg.setColor(1, 0, 0, 1);

	local mx, my = love.mouse.getX(), love.mouse.getY();
	lg.line(mx-10, my, mx+10, my);
	lg.line(mx, my-10, mx, my+10);

	if other_draw then
		other_draw();
	end

	if true then
		--[[lg.scale(4, 4)
		lg.setColor(1, 1, 1, 1);
		lg.setFont(test_font);
		lg.print("MIRACLE OF SNOWDAGGER");
		lg.setFont(gui.Skin.font);
		lg.scale(1/4, 1/4);]]
	end
end

function love.mousemoved(x, y, dx, dy)
	gui:propagate_event_reverse("mousemoved", x, y, dy, dx);
end

function love.mousereleased(x, y, b)
	gui:propagate_event_reverse("mousereleased", x, y, b);
end

function love.mousepressed(x, y, b)
	gui:propagate_event_reverse("mousepressed", x, y, b);
end

function love.keypressed(key, scancode, is_repeat)
	gui:propagate_event_reverse("keypressed", key, scancode, is_repeat);
	--[[if key == "f4" then
		local gui_instance = loadstring(get_file("instance/item_editor.lua"))
		gui_instance(winc);
	end]]
end

function love.textinput(t)
	gui:propagate_event_reverse("textinput", t);
end

function love.resize()
	gui:propagate_event_reverse("love_resize_window");
	if other_resize then
		other_resize();
	end
end

function get_file(file)
    return love.filesystem.read(file);
end