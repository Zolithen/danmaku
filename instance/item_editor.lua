Stacker = dnkGroup:extend("Stacker");

function Stacker:init(parent, name, x, y)
	Stacker.super.init(self, parent, name, x, y);
	self.current = 0;
end

function Stacker:on_add_children(child)
	child.y = self.current*24
	self.current = self.current + 1;
end

local enchantments = {
	"protection",
	"fire_protection",
	"feather_falling",
	"blast_protection",
	"projectile_protection",
	"respiration",
	"aqua_affinity",
	"thorns",
	"depth_strider",
	"frost_walker",
	"binding_curse",
	"sharpness",
	"smite",
	"bane_of_arthropods",
	"knockback",
	"fire_aspect",
	"looting",
	"sweeping",
	"efficiency",
	"silk_touch",
	"unbreaking",
	"fortune",
	"power",
	"punch",
	"flame",
	"infinity",
	"luck_of_the_sea",
	"lure",
	"loyalty",
	"impaling",
	"riptide",
	"channeling",
	"mending",
	"vanishing_curse",
	"multishot",
	"piercing",
	"quick_charge",
	"soul_speed",
	"swift_sneak"
}

local projects = {}

table.sort(enchantments)

local windows = {p = {}}
windows.projects = dnkWindow(gui, 0, 0, 300, 304, gui.Skin, "projects", "Projects");
windows.projects.expandable = false;

local project_panel = dnkPanel(windows.projects, "panel", 0, 0, 300, 300-16)
local project_slider = dnkSlider(windows.projects, "slider", 300-16, 0, 16, 304):bind(project_panel);
local project_list = Stacker(project_panel, "project_list", 0, 0);
--project_list:calculate_content_height();
dnkButton(windows.projects, "new_project", 0, 300-16, "New Project"):connect("press", function(self)
	local but = dnkButton(project_list, "p" .. project_list.current, 0, 0, "Project " .. project_list.current);
	project_panel:calculate_content_height();

end);

function other_update(dt)
	local newh_c = math.max(project_panel.h + 1, project_list.content_height);
	local y_p = -project_panel.transy;
	local y_b = project_slider.boxy;
	local h_p = project_panel.h;
	local h_s = project_slider.h;
	local h_b = project_slider.boxh;
	local h_c = (y_p / y_b) * (h_s - h_b) + h_p;
	local newh_b = h_s * (h_p / newh_c)
	project_slider.boxh = newh_b;
	project_slider.boxy = math.max(1, ((h_s - newh_b) * (h_c - h_p)) / ((newh_c - h_p) * (h_s - h_b)) * y_b); 

	--project_slider.boxh = project_slider.h * ratio
	--project_slider.boxy = project_panel.transy;

	--[[
		self.bound_to.transy = math.floor(
			((math.max(self.bound_to.h, self.bound_to.content_height) - self.bound_to.h) / (self.h - self.boxh)) * -self.boxy
		)
	]]

	--project_slider.boxh = project_slider.h * ratio;
	--project_slider.boxh
	--project_slider.boxy = (project_slider.boxh/old_bh) * project_slider.boxy;

	--project_slider.boxw = project_slider.w * (project_panel.w / math.max(project_panel.w, project_list.w))
	--project_slider.boxx = (project_slider.boxw/old_bw) * project_slider.boxx;
end

function other_draw()
	lg.setColor(1, 1, 1, 1)
	lg.print(project_list.current);
	lg.print(project_slider.boxy, 0, 16)
	--lg.print(project_list.transy, 0, 16);
end