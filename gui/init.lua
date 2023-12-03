gui = Node(nil, "master", 0, 0);
gui.path = ...;
gui.windows = {};
gui.android = love.system.getOS() == "Android";

ll = function(path)
	require(gui.path .. "." .. path);
end

ll("util")
ll("element")

ll("skin");
ll("window");

ll("group");
ll("panel")
ll("clickable");
ll("text_label")
ll("text_button");
ll("text_input");
ll("slider");
ll("on_off_button");

function gui:focus_window(index)
	local window_to_focus = self.children[index];
	table.remove(self.children, index);
	table.insert(self.children, window_to_focus);

	for i, v in ipairs(self.children) do
		v.child_index = i;
		v.focused = false;
	end
	self.children[#self.children].focused = true
end