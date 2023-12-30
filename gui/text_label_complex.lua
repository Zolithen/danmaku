dnkFmtLabel = dnkElement:extend("dnkFmtLabel");

-- Unifont comes without bold by default! If you want to use bold or italics, then change self.font
function dnkFmtLabel:init(parent, name, x, y)
	dnkFmtLabel.super.init(self, parent, name, x, y);
	self.textures = {}
	self.text_w = 0;
	self.font = gui.Skin.font;
	self.bold_font = gui.Skin.test_font;
end

function dnkFmtLabel:draw()
	if self.canvas ~= nil then
		lg.setColor(1, 1, 1, 1);
		lg.draw(self.canvas, self.x, self.y);
	end
end

--[[
	Accepts a table with the format
	{format1, string1, format2, string2, ...}
]]
function dnkFmtLabel:set_text(text_table)
	if (#text_table % 2 == 1) or (text_table == nil) then
		error("Provided text_table doesn't have valid size");
	end
	for i, v in ipairs(self.textures) do
		v.text:release();
		v = nil;
	end
	self.textures = {};
	local text_w = 0;
	local i = 1;
	while i <= #text_table do
		local format = text_table[i];
		local str = text_table[i + 1];

		-- TODO: Make everything work
		table.insert(self.textures, {
			text = love.graphics.newText((format.bold and self.bold_font) or self.font, str),
			color = format.color,
			bold = format.bold,
			italic = format.italic,
			underline = format.underline,
			strike = format.strike
		});
		
		text_w = text_w + self.textures[#self.textures].text:getWidth();
		i = i + 2;
	end
	if self.canvas then self.canvas:release() end
	if text_w >= 1 then
		self.canvas = lg.newCanvas(text_w, 16);
	else
		self.canvas = lg.newCanvas(1, 16);
	end
	lg.setCanvas(self.canvas);
	local acum_w = 0;
	for i, v in ipairs(self.textures) do
		lg.setColor(1, 1, 1, 1);
		if v.color then lg.setColor(v.color); end
		lg.draw(v.text, math.floor(acum_w), 0);
		acum_w = acum_w + v.text:getWidth();
	end
	lg.setCanvas();

	self.w = text_w;
	return self;
end

function dnkFmtLabel:box_full()
	return 0, 0, self.w, 16;
end