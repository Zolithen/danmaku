ColorWindow = dnkWindow:extend("ColorWindow");

function ColorWindow:init(parent, x, y, w, h, skin, name, title)
	dnkWindow.init(self, parent, x, y, w, h, skin, name, title);
	self.expandable = false;

	self.bound_to = nil;
	self.color_picker = dnkColorPicker(self, "color_picker", 0, 0);
	self._mod_label = dnkLabel(self, "_mod_label", 0, 260, "Currently modifying:");
	self.mod_label = dnkLabel(self, "mod_label", 0, 276, "Nothing");
	self.ok_button = dnkButton(self, "ok_button", 0, 0, "Ok");

	--[[self.color_list = dnkListTooltip(nil, "color_list", 0, 0, 200, 200);
	self.color_list:add_to_list("white");
	self.color_list:add_to_list("orange");
	self.apply_color = dnkFloatingList.from_link_list(self, "apply_color", 200, 0, "Apply color", self.color_list);
	self.modify_color = dnkFloatingList.from_link_list(self, "modify_color", 200, 24, "Modify color", self.color_list)
	self.save_color = dnkFloatingList.from_link_list(self, "save_color", 200, 48, "Save color", self.color_list)

	self.apply_color:connect("item_select", function()
		self.color_picker:set_color(1, 1, 1);
	end)
	self.modify_color:connect("item_select", function()
		print("c");
	end)]]

	self.ok_button.x = w-self.ok_button.w-4;
	self.ok_button.y = h-self.ok_button.h-4;

	self.color_picker:connect("color_change", function()
		if self.bound_to then
			self.bound_to:set_color(self.color_picker:picked_color());
		end
	end);
end

function ColorWindow:bind_to_component(comp)
	gui:focus_window(self.child_index);
	self.mod_label:set_text(comp.label);
	if self.bound_to then self.bound_to.bound = false end;
	self.bound_to = comp;
	comp.bound = true;
	self.color_picker:_set_color(comp.color[1], comp.color[2], comp.color[3]);
end

function ColorWindow:component_is_gone()
	if self.bound_to then self.bound_to.bound = false end;
	self.bound_to = nil;
	self.mod_label:set_text("Nothing");
end