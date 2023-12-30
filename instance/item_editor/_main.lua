Stacker = dnkGroup:extend("Stacker");

function Stacker:init(parent, name, x, y)
	Stacker.super.init(self, parent, name, x, y);
	self.current = 0;
end

function Stacker:on_add_children(child)
	child.y = self.current*24
	self.current = self.current + 1;
end

require "instance/item_editor/name_window"
require "instance/item_editor/color_picker"

local projects = {};

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

--[[local libmono_reg = lg.newFont("assets/ttf/LiberationMono-Regular.ttf", 16);
local libmono_bold = lg.newFont("assets/ttf/LiberationMono-Bold.ttf", 16);
local fmt_test = dnkFmtLabel(windows.projects, "fmt", 100, 0);
fmt_test.font = libmono_reg;
fmt_test.bold_font = libmono_bold;
fmt_test:set_text{
	{color = {1, 1, 0, 1}, bold=true}, "this looks",
	{color = {1, 1, 1, 1}}, " sad"
};]]

Project = class("Project");
function Project:init(name)
	self.name = name;
	self:create_name_edit_window();
end

function Project:create_name_edit_window()
	self.name_window = WindowTCEdit(nil, 0, 0, 300, 300, gui.Skin, "project_" .. self.name .. "_name_editor", self.name .. " Name");
end

function Project:create_window()
	if not self.window then
		self.window = dnkWindow(gui, 0, 0, 300, 304, gui.Skin, "project_" .. self.name, self.name);
		self.window.closable = true;
		self._close = dnkButton(self.window, "close_button", 0, 0, "Hide window"):connect("press", function(button)
			self.window:remove_from_parent();
		end);
		self._pname = dnkField(self.window, "pname_field", 0, 20, "Project name", dnkField.type.text);
		self._pname.input:connect("finish_text", function(input)
			self.name = input.text;
			self.window:set_title(self.name);
			self.open_button:set_text(self.name);
			self.name_window:set_title(self.name .. " Name");
		end);
		self._id = dnkField(self.window, "id_field", 0, 40, "Item ID", dnkField.type.text);
		self._count = dnkField(self.window, "count_field", 0, 60, "Count", dnkField.type.number);
		self._count.input.w = 30;

		self._iname_button = dnkButton(self.window, "item_name_button", 0, 80, "Edit Name"):connect("press", function(button)
			if not self.name_window.parent then
				gui:add(self.name_window);
				gui:focus_window(self.name_window.child_index);
			end
		end);

		gui:focus_window(self.window.child_index);
	elseif self.window.parent == nil then
		gui:add(self.window);
		gui:focus_window(self.window.child_index);
	end
end

dnkButton(windows.projects, "new_project", 0, 300-16, "New Project"):connect("press", function(self)
	local proj = Project("Project " .. project_list.current)
	table.insert(projects, proj);
	proj.open_button = dnkButton(project_list, "p" .. project_list.current, 0, 0, "Project " .. project_list.current):connect("press", function(self)
		proj:create_window();
	end);
	project_panel:calculate_content_height();
end);

function other_update(dt)
	
end

function other_draw()
	--[[lg.setColor(1, 0.5, 0.5, 0.8);
	lg.print("test", 350, 0);
	lg.print("test", 350, 0);
	lg.print("test", 350, 0);

	lg.print("test", 400, 0);]]
end