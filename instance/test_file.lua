if ANDROID then
	love.audio.setMixWithSystem(true);
end

local main = dnkWindow(gui, 0, 0, 200, 200, gui.Skin, nil, "test");
dnkLabel(main, "label", 0, 0, "HOLA");
local input = dnkTextInput(main, "ssss", 0, 64, 100, 16);
local but = dnkButton(main, "button", 0, 32, "teaaaaaaaaaaa");
but:connect("press", function(self)
	print(self:get_holder().title);
end);

local test = dnkWindow(gui, 200, 200, 200, 200, gui.Skin, nil, "lol");

dnkLabel(test, "llll", 0, 0, "lol");
local panel = dnkPanel(test, "lol", 0, 32, 200, 200);
dnkLabel(panel, "te", 0, 0, "hola mundo");
dnkButton(panel, "button", 170, 16, "loll"):connect("press", function(self)
	print("osjahgfaosjfnasfoñlas");
end);

function other_update(dt)
	--panel.x = panel.x + 1
end