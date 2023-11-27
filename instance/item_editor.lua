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

--[[local temp = windows.main:add_element(gui.Button.new(
	0, 16, "test", 0, 0
));
temp:connect("press", function(t)
	windows.main.show = not windows.main.show;
	print("i got pressed");
end);]]

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
local function add_named_input(name)
	local l = dnkLabel(windows.main, "",
		0, current_y, name
	);
	dnkTextInput(windows.main, "",
		l:get_width()+4, current_y, 160, 16
	);
	current_y = current_y + 20;
end

add_named_input("Minecraft Item ID");
add_named_input("Count");
add_named_input("Damage");

local panel_test = dnkPanel(windows.main, "",
	0, 80, 300, 300
); 

local but = dnkButton(panel_test, "",
	0, 0, "test"
);

but:connect("press", function(t)
	print("testsssss");
end)

local hide_test = dnkButton(windows.main, "",
	0, 64, "Switch"
)

hide_test:connect("press", function(t)
	panel_test.minim = not panel_test.minim;
end)

-- TODO: Make a layout system or something
function other_update(dt)
	
end

function other_draw()
	--lg.print(string.format("%d,%d,%d,%d,%d", panel_test.window:relative_mouse_pos(), panel_test:box_full()), 0, 32);
	--lg.print(string.format("%d,%d", panel_test.window:relative_mouse_pos() ), 0, 32);
	--lg.print(string.format("%d,%d,%d,%d", panel_test:box_full()), 0, 48);
	--lg.print(tostring(math.point_in_box(panel_test.window:relative_mouse_pos(), panel_test:box_full())), 0, 64)
end

--[[local label_mc_item_id = windows.main:add_element(gui.Label.new(
	0, 0, "Minecraft Item ID"
));
windows.main:add_element(gui.TextInput.new(
	label_mc_item_id:get_width()+4, 0, 160, 16
));]]