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
dnkSlider(windows.projects, "slider", 300-16, 0, 16, 304):bind(project_panel);
local project_list = Stacker(project_panel, "project_list", 0, 0); 
dnkButton(windows.projects, "new_project", 0, 300-16, "New Project"):connect("press", function(self)
	local but = dnkButton(project_list, "p" .. project_list.current, 0, 0, "Project " .. project_list.current);
end);