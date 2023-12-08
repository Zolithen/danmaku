dnkField = dnkGroup:extend("dnkField");
dnkField.type = {
	text = 1,
	number = 2,
	check = 3
}

function dnkField:init(parent, name, x, y, label, typ)
	dnkField.super.init(self, parent, name, x, y);
	self.label = dnkLabel(self, "", 0, 0, label);
	self.type = typ;
	if typ == dnkField.type.text then
		self.input = dnkTextInput(self, "", self.label.texture:getWidth()+4, 0, 100, 16);
	-- TODO: Make it so text inputs have an option to only input numbers
	elseif typ == dnkField.type.number then
		self.input = dnkTextInput(self, "", self.label.texture:getWidth()+4, 0, 100, 16);
	elseif typ == dnkField.type.check then
		self.input = dnkCheckbox(self, "", self.label.texture:getWidth()+4, 0);
	else
		error("Trying to create dnkField with invalid type " .. tostring(typ));
	end
end

function dnkField:set_text(t)
	self.label:set_text(t);
	self.input.x = self.label.texture:getWidth()+4;
end