local gui = {
	path = ...,
	windows = {},
	android = love.system.getOS() == "Android";
};
require(gui.path .. ".util")

gui.Events = require(gui.path .. ".element_events" )

local ll = function(name, file)
	gui[name] = require(gui.path .. "." .. file);
	set_union(gui[name], gui.Events);
end

ll("Window", "window")
ll("Skin", "skin")

ll("Panel", "panel");

ll("Label", "text_label")
ll("TextInput", "text_input")
ll("ClickableArea", "clickable");
ll("Slider", "slider")

ll("TextButton", "text_button");

-- Window controller stuff
function gui:new_window(x, y, w, h, id, name)
	table.insert(self.windows, self.Window.new(x, y, w, h, self.Skin, id, name, self))
	self.windows[#self.windows].child_index = #self.windows;
	return self.windows[#self.windows];
end

function gui:focus_window(index)
	local window_to_focus = self.windows[index];
	table.remove(self.windows, index);
	table.insert(self.windows, 1, window_to_focus);

	for i, v in ipairs(self.windows) do
		v.child_index = i;
		v.focused = false;
	end
	self.windows[1].focused = true
end

function gui:update(dt)
	for i, v in ipairs(self.windows) do
		if v.show then	
			v:update(dt);
		end
	end
end

function gui:draw()
	for i, v in r_ipairs(self.windows) do
		if v.show then
			v:draw();
		end
	end
end

function gui:mousemoved(x, y, dx, dy)
	for i, v in ipairs(self.windows) do
		if v.show and v:mousemoved(x, y, dx, dy) then
			break;
		end
	end	
end

function gui:mousereleased(x, y, b)
	for i, v in ipairs(self.windows) do
		if v.show and v:mousereleased(x, y, b) then
			break;
		end
	end	
end

function gui:mousepressed(x, y, b)
	for i, v in ipairs(self.windows) do
		if v.show and v:mousepressed(x, y, b) then
			break;
		end
	end	
end

function gui:textinput(t)
	for i, v in ipairs(self.windows) do
		if v.show and v:textinput(t) then
			break;
		end
	end
end

function gui:keypressed(k, scancode, is_repeat)
	for i, v in ipairs(self.windows) do
		if v.show and v:keypressed(k, scancode, is_repeat) then
			break;
		end
	end
end

return gui;