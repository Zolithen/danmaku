Stacker = dnkGroup:extend("Stacker");

-- We can generalize this into a column layout
function Stacker:init(parent, name, x, y, irow, cl)
	Stacker.super.init(self, parent, name, x, y);
	self.current_y = 0;
	self.current_x = 0;
	self.irow = irow or 1; -- Items per row
	self.collen = cl or 200; -- Lenght of column (TODO: Autoupdate based on the elements' width?¿?¿?¿?¿??¿?¿¿¿¿??¿¿¿??)
	self.columns = {};
	for i = 1, self.irow do
		table.insert(self.columns, dnkGroup(self, "col", self.collen*(i-1), 0));
	end
end

function Stacker:on_add_children(child)
	if child.child_index > self.irow then
		child:remove_from_parent(); -- We want to correctly add it into one of the columns
		if self.current_x >= self.irow - 1 then
			self.columns[self.current_x + 1]:add(child);
			child.y = self.current_y*24
			self.current_y = self.current_y + 1;
			self.current_x = 0;
		else
			self.columns[self.current_x + 1]:add(child);
			child.y = self.current_y*24;
			self.current_x = self.current_x + 1;
		end
	end
end

require "instance/item_editor/name_window"
require "instance/item_editor/enchant_window"
require "instance/item_editor/color_picker"
require "instance/item_editor/color_window"

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

auxgui = Node(nil, "auxgui", 0, 0);
local windows = {p = {}}
windows.projects = dnkWindow(gui, 0, 0, 300, 304, gui.Skin, "projects", "Projects");
windows.color = ColorWindow(gui, 400, 0, 300, 300, gui.Skin, "color", "Colors");
windows.projects.expandable = false;

local project_panel = dnkPanel(windows.projects, "panel", 0, 16, 300, 300-16)
local project_slider = dnkSlider(windows.projects, "slider", 300-16, 16, 16, 304):bind(project_panel);
local project_list = Stacker(project_panel, "project_list", 0, 16);

local test_window = dnkWindow(gui, 0, 400, 300, 300, gui.Skin, "test", "Test Elements");
dnkImage(test_window, "test_image", 0, 16):set_image("assets/gfx/test_image.png");
dnkCheckbox(test_window, "test_checkbox")


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
	
	self.name_window = WindowTCEdit(nil, 0, 0, gui.Skin, "project_" .. self.name .. "_name_editor", self.name .. " Name");
	self.enchant_window = WindowECEdit(nil, 0, 0, gui.Skin, "project_" .. self.name .. "_name_editor", self.name .. " Enchants", enchantments);
end

function Project:create_window()
	if not self.window then
		self.window = dnkWindow(gui, 0, 0, 300, 304, gui.Skin, "project_" .. self.name, self.name);
		self.window.closable = true;
		self._close = dnkButton(self.window, "close_button", 0, 16, "Hide window"):connect("press", function(button)
			self.window:remove_from_parent();
		end);
		self._pname = dnkField(self.window, "pname_field", 0, 36, "Project name", dnkField.type.text);
		self._pname.input:connect("finish_text", function(input)
			self.name = input.text;
			self.window:set_title(self.name);
			self.open_button:set_text(self.name);
			self.name_window:set_title(self.name .. " Name");
			self.enchant_window:set_title(self.name .. " Enchants");
		end);
		self._id = dnkField(self.window, "id_field", 0, 56, "Item ID", dnkField.type.text);
		self._count = dnkField(self.window, "count_field", 0, 76, "Count", dnkField.type.number);
		self._count.input.w = 30;

		self._iname_button = dnkButton(self.window, "item_name_button", 0, 96, "Edit Name"):connect("press", function(button)
			if not self.name_window.parent then
				gui:add(self.name_window);
				gui:focus_window(self.name_window.child_index);
			end
		end);

		self._enchant_button = dnkButton(self.window, "enchant_button", 0, 126, "Edit Enchants"):connect("press", function(button)
			if not self.enchant_window.parent then
				gui:add(self.enchant_window);
				gui:focus_window(self.enchant_window.child_index);
			end
		end);

		gui:focus_window(self.window.child_index);
	elseif self.window.parent == nil then
		gui:add(self.window);
		gui:focus_window(self.window.child_index);
	end
end

dnkButton(windows.projects, "new_project", 0, 300, "New Project"):connect("press", function(self)
	local proj = Project("Project " .. #projects)
	table.insert(projects, proj);
	proj.open_button = dnkButton(project_list, "p" .. (#projects - 1), 0, 0, "Project " .. (#projects - 1)):connect("press", function(self)
		proj:create_window();
	end);
	project_panel:calculate_content_height();
end);

--[[local tlt = dnkTooltip(floatgui, "test", 200, 200, 150, 128);
dnkLabel(tlt, "label", 0, 0, "This is a tooltip");]]

function other_update(dt)
end

function other_keypressed(key, scancode, isrepeat)

end

function other_draw()
	--[[lg.setColor(1, 0.5, 0.5, 0.8);
	lg.print("test", 350, 0);
	lg.print("test", 350, 0);
	lg.print("test", 350, 0);

	lg.print("test", 400, 0);]]
end