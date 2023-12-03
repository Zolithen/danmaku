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

table.sort(enchantments)

local windows = {}
windows.main = dnkWindow(gui, 0, 0, 300, 300, gui.Skin, "main", "Main");
--windows.main.expandable = false;
windows.enchantments = dnkWindow(gui, 0, 0, 600, 420, gui.Skin, "enchantments", "Enchantments");
windows.enchantments.expandable = false;

for i, v in ipairs(enchantments) do
	i = i - 1;
	local label = dnkLabel(windows.enchantments, nil,
		(i%2) * 300, math.euclid(i, 2)*16 + math.euclid(i, 2)*4 + 4, v
	)
	dnkTextInput(windows.enchantments, nil,
		250+(i%2) * 300, label.y, 32, 16
	)
end

local current_y = 0;
local function add_named_input(id, name)
	local l = dnkLabel(windows.main, "",
		0, current_y, name
	);
	dnkTextInput(windows.main, id,
		l:get_width()+4, current_y, 160, 16
	);
	current_y = current_y + 20;
end

add_named_input("item_id", "Minecraft Item ID");
add_named_input("count", "Count");
add_named_input("dmg", "Damage");
dnkButton(windows.main, "clipboard_button", 0, current_y, "Copy to cliboard"):connect("press", function(self)
	love.system.setClipboardText(create_command());
end);
current_y = current_y + 20;

dnkCheckbox(windows.main, "bold", 0, 200);

function create_command()
	local com = "/give @s " .. windows.main:find_name_in_children("item_id").text;
	
	return com;
end

function other_draw()
	--lg.print(string.format("%d,%d,%d,%d,%d", panel_test.window:relative_mouse_pos(), panel_test:box_full()), 0, 32);
	--lg.print(string.format("%d,%d", panel_test.window:relative_mouse_pos() ), 0, 32);
	--lg.print(string.format("%d,%d,%d,%d", panel_test:box_full()), 0, 48);
	--lg.print(tostring(math.point_in_box(panel_test.window:relative_mouse_pos(), panel_test:box_full())), 0, 64)
end