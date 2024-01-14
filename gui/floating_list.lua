dnkFloatingList = dnkGroup:extend("dnkFloatingList")

function dnkFloatingList:init(parent, name, x, y, label, linked)
	dnkGroup.init(self, parent, name, x, y);

	if not linked then
		self.list = {};
		self.tooltip = dnkListTooltip(nil, name .. "_tooltip",  0, 0, 200, 200, self);
	end
	self.linked = linked;
	self.selected_item = 0;
	self.button = dnkButton(self, "button", 0, 0, label):connect("press", function(but)
		if self.linked then
			self.tooltip.list_el = self;
		end
		gui:float();
		self.tooltip.x = love.mouse.getX();
		self.tooltip.y = love.mouse.getY();
		floatgui:add(self.tooltip);
	end);
end

-- Creates a dnkFloatingList linked to some global list
function dnkFloatingList.from_link_list(parent, name, x, y, label, list)
	local self = dnkFloatingList(parent, name, x, y, label, true);
	self.tooltip = list;
	return self;
end

function dnkFloatingList:add_to_list(str)
	self.list:add_to_list(str);
end

dnkListTooltip = dnkTooltip:extend("dnkListTooltip");

function dnkListTooltip:init(parent, name, x, y, w, h, list)
	dnkTooltip.init(self, parent, name, x, y, w, h);
	self.on = false;
	self.list = {};
	self.list_el = list;
	self:calculate_content_height();
end

function dnkListTooltip:add_to_list(str)
	table.insert(self.list, str);
	dnkLabel(self, "label_" .. str, 0, self.content_height, str);
	self:calculate_content_height();
end

function dnkListTooltip:mousepressed(x, y, b)
	local resp = dnkTooltip.mousepressed(self, x, y, b);
	if resp then return resp end;
	local mx, my = self:transform_vector(love.mouse.getX(), love.mouse.getY());
	my = my + self.transy;
	local item = math.floor(my/16) + 1;
	if item <= #self.list then
		self.list_el.selected_item = item;
		self.list_el:call("item_select");
		if self.list_el.linked then
			self.list_el = nil;
		end
		gui:unfloat_safely();
		self:remove_from_parent(); 
	end
end

function dnkListTooltip:wheelmoved(dx, dy)
	self.transy = math.clamp(self.transy - dy*8, 0, math.max(self.content_height - self.w, 0));
end