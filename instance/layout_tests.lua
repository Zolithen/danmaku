lg.setFont(gui.Skin.font);

dnkLayoutStation = class("dnkLayoutStation");

function dnkLayoutStation:init(winw, winh, lay)
	self.layout = lay;
	self.windows = {};
	self.winw = winw;
	self.winh = winh;
	for i, v in ipairs(lay) do
		local win = dnkWindow(gui, v[1]*winw, v[2]*winh, v[3]*winw, v[4]*winh - 16, gui.Skin, v[5], v[6]);
		v[7] = win;
		win.movable = false;
		win.minimizable = false;
		win.expandable = false;
		table.insert(self.windows, v);
	end
end

function dnkLayoutStation:get_window(id)
	for i, v in ipairs(self.windows) do
		if v[5] == id then
			return v;
		end
	end
	return nil;
end

function dnkLayoutStation:resize(winw, winh)
	self.winw = winw;
	self.winh = winh;
	for i, v in ipairs(self.layout) do
		v[7]:resize(v[3]*winw, v[4]*winh - 16);
		v[7].x = math.floor(v[1]*winw);
		v[7].y = math.floor(v[2]*winh);
	end
end

local layout = dnkLayoutStation(800, 600, {
	{0.0, 0.0, 0.2, 0.8, "list", "List"},
	{0.2, 0.0, 0.6, 0.8, "area", "Area"},
	{0.8, 0.0, 0.2, 0.8, "props", "Properties"},
	{0.0, 0.8, 1.0, 0.2, "files", "Files"}
})

local listw = layout:get_window("list")[7];
local p = dnkPanel(listw, "name", 0, 0, listw.w-16, listw.h);
p.border = false;
p.slider = dnkSlider(listw, "slider", listw.w-16, 0, 16, listw.h):bind(p);
--dnkButton(p, "test", 0, 40, "hola");
--dnkButton(p, "test", 0, 800, "hola");

local tlist = dnkTreeList(p, "tree_list", 0, 0, listw.w-16, 1000);
dnkTreeNode(tlist.tree, "yo")
dnkTreeNode(dnkTreeNode(tlist.tree, "yosfaas"), "right")
tlist.update_canvas = true;
p:calculate_content_height();

love.window.setMode(800, 600, {
	resizable = true,
	minwidth = 800,
	minheight = 600
});

function other_resize(winw, winh)
	layout:resize(winw, winh);

	-- So all of this should be automated eventually
	p:resize(listw.w-16, listw.h);
	tlist:resize(listw.w-16, listw.h);
	p.slider.x = listw.w-16;
	p.slider.y = 0;
	p.slider.h = listw.h

	p:calculate_content_height();
end