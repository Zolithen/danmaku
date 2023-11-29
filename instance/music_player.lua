local main = dnkWindow(gui, 0, 0, lg.getWidth(), lg.getHeight(), gui.Skin, nil, "test");
main.movable = false;
main.minimizable = false;
main.expandable = false;

local slider = dnkSlider(main, "slider", lg.getWidth()-16, 0, 16, lg.getHeight()-16);
slider.boxw = 16;
slider.boxh = 24;
local panel = dnkPanel(main, "panel", 0, 0, lg.getWidth()-16, lg.getHeight()-32);
panel.border = false;
bar = {};

layout_amount = 0;
layout_wide = {};

local dir_bar = dnkGroup(main, "dir_bar", 0, lg.getHeight()-32)
function draw_rectangle(self)
	lg.setColor(gui.Skin.back_light);
	lg.rectangle("fill", self.x, self.y, self.w, self.h);
	lg.setColor(1, 1, 1, 1);
end
local dir_bar_rect = dnkElement(dir_bar, "rect", 0, 0);
dir_bar_rect.w = lg.getWidth()-16;
dir_bar_rect.h = 24;
dir_bar_rect.draw = draw_rectangle;
dnkLabel(dir_bar, "label", 0, 0, "/Yakui - Flock")
dnkButton(dir_bar, "back", lg.getWidth()-64, 0, "<-"):connect("press", function(self)
	local current_layouter = panel:find_name("master_layouter");
	if current_layouter.file_node.parent then
		current_layouter:remove_from_parent();
		panel:add(current_layouter.file_node.parent.layouter);
	end
end)

WideLayouter = dnkElement:extend("WideLayouter");

function WideLayouter:init(parent, name)
	WideLayouter.super.init(self, parent, name, 0, 0);
	self.amount = 0;
end

function WideLayouter:update()
	self.focused = self.parent.focused;
end

function WideLayouter:is_holder()
	return true;
end

function WideLayouter:on_add_children(c)
	c.y = self.amount * 50;
	self.amount = self.amount + 1;
end

function WideLayouter:is_mouse_over()
	return self.parent:is_mouse_over();
end

function WideLayouter:love_resize_window()

end

FileNode = Node:extend("FileNode")

function FileNode:init(parent, name, path)
	FileNode.super.init(self, parent, name);
	self.is_folder = true;
	self.path = path;
	self.layouter = WideLayouter(nil, "master_layouter");
	self.layouter.file_node = self;
	--self.file = love.filesystem.newFile(path);
	for i, v in ipairs(love.filesystem.getDirectoryItems(path)) do
		--local file = love.filesystem.newFile(v);
		local file_node = FileNode(self, v, path .. "/" .. v);
		if love.filesystem.getInfo(path .. "/" .. v).type ~= "directory" then
			file_node.is_folder = false;
		end

		local g = dnkGroup(self.layouter, "", 0, 0);
		dnkClickableArea(g, "area", 0, 0, lg.getWidth()-16, 50):connect("press", function(area)
			if file_node.is_folder then
				local current_layouter = panel:find_name("master_layouter");
				current_layouter:remove_from_parent();
				panel:add(file_node.layouter);
			end
		end);
		dnkLabel(g, "label", 0, 0, v);
	end
end

local master_directory = FileNode(nil, "", "songs");
--dump_table(master_directory, "songs");
panel:add(master_directory.layouter);

local songs = love.filesystem.getDirectoryItems("songs")
--[[for i, v in ipairs(songs) do
	laywide_add(v);
end]]

function other_update()
	panel.transx = slider.boxx;
	panel.transy = -slider.boxy;
end

function other_resize()
	main:resize(math.max(lg.getWidth(), 1), math.max(lg.getHeight(), 1));
	panel:resize(math.max(lg.getWidth()-16, 1), math.max(lg.getHeight()-32, 1));

	-- Handle the layout
	local current_layouter = panel:find_name("master_layouter");
	for i, v in ipairs(current_layouter.children) do
		v:find_name("area").w = lg.getWidth()-16;
	end
	slider.x = lg.getWidth()-16;
	slider.h = lg.getHeight()-16;

	slider.boxy = math.clamp(slider.boxy, 0, slider.h - slider.boxh);

	dir_bar_rect.w = lg.getWidth()-16;
	dir_bar.y = lg.getHeight()-32;
end