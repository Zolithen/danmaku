WindowTCEdit = dnkWindow:extend("WindowTCEdit");

function WindowTCEdit:init(parent, x, y, w, h, skin, id, title)
	WindowTCEdit.super.init(self, parent, x, y, w, h, skin, id, title);

	dnkButton(self, "close_button", 0, 0, "Hide window"):connect("press", function(button)
		self:remove_from_parent();
	end);

	self.main_input = dnkTextInput(self, "main_input", 0, 120, 100, 16):connect("update_text", function(inp)
		self.section_data[self.cur_sec*2] = inp.text;
		self:update_display();		
	end);

	dnkButton(self, "new_section", 30, 140, "New section"):connect("press", function(button)
		self:new_section();
	end)
	dnkButton(self, "last_section", 0, 140, "<-"):connect("press", function(button)
		self.cur_sec = math.max(1, self.cur_sec - 1);
		self:change_current_section();
	end)
	dnkButton(self, "next_section", 132, 140, "->"):connect("press", function(button)
		self.cur_sec = math.min(self.max_sec, self.cur_sec + 1);
		self:change_current_section();
	end)

	dnkColorPicker(self, "color_picker", 0, 200, 100, 100);

	self.section_label = dnkLabel(self, "section_label", 0, 160, "1/1");
	self.display_label = dnkFmtLabel(self, "display_label", 0, 180);

	self.bold = dnkField(self, "bold", 0, 20, "Bold", dnkField.type.check):connect("press", self:_modify_cur_sec());
	self.italic = dnkField(self, "italic", 0, 40, "Italic", dnkField.type.check):connect("press", self:_modify_cur_sec());
	self.strike = dnkField(self, "strike", 0, 60, "Strikethrough", dnkField.type.check):connect("press", self:_modify_cur_sec());
	self.underline = dnkField(self, "underline", 0, 80, "Underline", dnkField.type.check):connect("press", self:_modify_cur_sec());
	self.obfuscated = dnkField(self, "obfuscated", 0, 100, "Obfuscated", dnkField.type.check):connect("press", self:_modify_cur_sec());

	self.cur_sec = 1;
	self.max_sec = 0;
	self.section_data = {}
	self:new_section();
end

function WindowTCEdit:new_section()
	table.insert(self.section_data, {
		bold = false,
		italic = false,
		strike = false,
		underline = false,
		obfuscated = false,
		color = {1, 1, 1, 1}
	});
	table.insert(self.section_data, "");
	self.max_sec = self.max_sec + 1;

	self.section_label:set_text(self.cur_sec .. "/" .. self.max_sec);
end

function WindowTCEdit:_modify_cur_sec()
	return function(c)
		self.section_data[2*self.cur_sec - 1][c.parent.name] = c.on;
		self:update_display();
	end
end

function WindowTCEdit:update_display()
	self.display_label:set_text(self.section_data);
end

-- This function just updates the text input & switches correctly
function WindowTCEdit:change_current_section()
	self.main_input:set_text(self.section_data[self.cur_sec*2]);
	self.bold.input.on = self.section_data[self.cur_sec*2 - 1].bold;
	self.italic.input.on = self.section_data[self.cur_sec*2 - 1].italic;
	self.strike.input.on = self.section_data[self.cur_sec*2 - 1].strike;
	self.underline.input.on = self.section_data[self.cur_sec*2 - 1].underline;
	self.obfuscated.input.on = self.section_data[self.cur_sec*2 - 1].obfuscated;
	self.section_label:set_text(self.cur_sec .. "/" .. self.max_sec);
end