lg = love.graphics;
utf8 = require "utf8"
gui = require "gui"
function love.load(args)
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
end

function love.update(dt)
	--love.timer.sleep(0.05);
	gui:update(dt);

	if other_update then
		other_update();
	end
	-- TODO: Remove this in release
	--[[if love.keyboard.isDown("escape") then
		love.event.quit();
	end]]
end

function love.draw()
	gui:draw();
	lg.setColor(1, 1, 1, 1);
	lg.print(string.format("FPS: %d", love.timer.getFPS()), lg.getWidth() - 100, 16);

	--[[if other_draw then
		other_draw();
	end]]
end

function love.mousemoved(x, y, dx, dy)
	gui:mousemoved(x, y, dx, dy)
end

function love.mousereleased(x, y, b)
	gui:mousereleased(x, y, b)
end

function love.mousepressed(x, y, b)
	gui:mousepressed(x, y, b)
end

function love.keypressed(key, scancode, is_repeat)
	gui:keypressed(key, scancode, is_repeat);
	if key == "f4" then
		local gui_instance = loadstring(get_file("instance/music_player.lua"))
		gui_instance(winc);
	end
end

function love.textinput(t)
	gui:textinput(t);
end

function get_file(file)
    local f = assert(io.open(file, "rb"))
    local content = f:read("*all")
    f:close()
    return content
end