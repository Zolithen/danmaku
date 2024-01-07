WindowECEdit = dnkWindow:extend("WindowECEdit");

function WindowECEdit:init(parent, x, y, skin, id, title, enchants)
	WindowECEdit.super.init(self, parent, x, y, 600, 550, skin, id, title);
	self.enchants = enchants;
	self.expandable = false;

	dnkButton(self, "close_button", 0, 2, "Hide window"):connect("press", function(button)
		self:remove_from_parent();
	end);

	self.enchant_stacker = Stacker(self, "enchant_stacker", 0, 32, 2, 300);
	for i, v in ipairs(self.enchants) do
		dnkField(self.enchant_stacker, "field_" .. v, 0, 0, v, dnkField.type.number);
	end
end