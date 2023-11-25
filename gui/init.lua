gui = Node(nil, "master", 0, 0);
gui.path = ...;
gui.windows = {};
gui.android = love.system.getOS() == "Android";

ll = function(path)
	require(gui.path .. "." .. path);
end

--[[ll("skin");
ll("proto_panel");

ll("window");

ll("panel");

ll("text_label");
ll("text_input");
ll("clickable");
ll("slider");

ll("text_button");]]

ll("util")
ll("element")

ll("skin");
ll("proto_panel");
ll("window");

ll("panel")
ll("text_label")
ll("text_button");
ll("text_input");

-- Window controller stuff

--[[function gui:new_window(x, y, w, h, id, name)
	table.insert(self.windows, self.Window.new(x, y, w, h, self.Skin, id, name, self))
	self.windows[#self.windows].child_index = #self.windows;
	return self.windows[#self.windows];
end]]

--[[function gui:on_add_children(child, nid)
	print("bro");
end]]

function gui:focus_window(index)
	local window_to_focus = self.children[index];
	table.remove(self.children, index);
	table.insert(self.children, 1, window_to_focus);

	for i, v in ipairs(self.children) do
		v.child_index = i;
		v.focused = false;
	end
	self.children[1].focused = true
end