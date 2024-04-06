gui = Node(nil, "gui", 0, 0);
auxgui = Node(nil, "auxgui", 0, 0);
floatgui = Node(nil, "floatgui", 0, 0);
gui.path = ...;
gui.windows = {};
gui.android = love.system.getOS() == "Android";
gui.is_floating = false;
gui.should_unfloat = 0;

ll = function(path)
	require(gui.path .. "." .. path);
end

ll("util");
ll("element");

ll("skin");
ll("window");
ll("tooltip");

ll("group");
ll("panel");
ll("canvas");
ll("clickable");
ll("text_label")
ll("text_button");
ll("text_input");
ll("slider");
ll("on_off_button");
ll("text_label_complex");
ll("image");

ll("tree_list");
ll("floating_list");
ll("field");

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

-- Function used to pass control onto the floating gui. Control comes back when clicking outside of floating elements
function gui:float()
	self.is_floating = true;
end

function gui:unfloat()
	self.is_floating = false;
end

function gui:unfloat_safely()
	self.should_unfloat = 10;
end

-- Cool

function gui:update()
	if self.should_unfloat >= 0 then self.should_unfloat = self.should_unfloat - 1 end
	if self.should_unfloat == 0 then self.is_floating = false end;
	if self.is_floating then return NodeResponse.stop end;
end

function gui:keypressed()
	if self.is_floating then return NodeResponse.stop end;
end

function gui:keyreleased()
	if self.is_floating then return NodeResponse.stop end;
end

function gui:mousepressed()
	if self.is_floating then return NodeResponse.stop end;
end

function gui:mousereleased()
	if self.is_floating then return NodeResponse.stop end;
end

function gui:mousemoved()
	if self.is_floating then return NodeResponse.stop end;
end

function gui:wheelmoved()
	if self.is_floating then return NodeResponse.stop end;
end