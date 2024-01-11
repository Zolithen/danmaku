dnkFloatingList = dnkGroup:extend("dnkFloatingList")

function dnkFloatingList:init(parent, name, x, y, label)
	dnkGroup.init(self, parent, name, x, y);

	self.list = {};
	self.selected_item = 0;
	self.tooltip = dnkListTooltip(nil, name .. "_tooltip", self, 0, 0, 200, 200);
	self.button = dnkButton(self, "button", 0, 0, label):connect("press", function(but)
		gui:float();
		self.tooltip.x = love.mouse.getX();
		self.tooltip.y = love.mouse.getY();
		floatgui:add(self.tooltip);
	end);
end

function dnkFloatingList:add_to_list(str)
	table.insert(self.list, str);
	dnkLabel(self.tooltip, "label_" .. str, 0, self.tooltip.content_height, str);
	self.tooltip:calculate_content_height();
end

dnkListTooltip = dnkTooltip:extend("dnkListTooltip");

function dnkListTooltip:init(parent, name, list, x, y, w, h)
	dnkTooltip.init(self, parent, name, x, y, w, h);
	self.on = false;
	self.list = list;
	--[[for i = 1, 32 do
		dnkLabel(self, "label" .. i, 0, (i-1)*16, i);
	end]]
	self:calculate_content_height();
end

function dnkListTooltip:mousepressed(x, y, b)
	dnkTooltip.mousepressed(self, x, y, b);
	local mx, my = self:transform_vector(love.mouse.getX(), love.mouse.getY());
	my = my + self.transy;
	local item = math.floor(my/16) + 1;
	if item <= #self.list.list then
		self.list.selected_item = item;
		self.list:call("item_select");
		gui:unfloat();
		self:remove_from_parent(); 
	end
end

function dnkListTooltip:wheelmoved(dx, dy)
	self.transy = math.clamp(self.transy - dy*8, 0, math.max(self.content_height - self.w, 0));
end