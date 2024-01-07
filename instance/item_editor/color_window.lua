ColorWindow = dnkWindow:extend("ColorWindow");

function ColorWindow:init(parent, x, y, w, h, skin, name, title)
	dnkWindow.init(self, parent, x, y, w, h, skin, name, title);
	self.expandable = false;

	self.color_picker = dnkColorPicker(self, "color_picker", 0, 0);
	self.mod_label = dnkLabel(self, "mod_label", 0, 260, "Currently modifying:");
	self.ok_button = dnkButton(self, "ok_button", 0, 0, "Ok");
	self.ok_button.x = w-self.ok_button.w-4;
	self.ok_button.y = h-self.ok_button.h-4;
end