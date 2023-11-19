dnkElement = Node:extend("dnkElement");

function dnkElement:init(parent, name, x, y)
	dnkElement.super.init(self, parent, name, x, y);
	self.events = {};
end

function dnkElement:connect(name, func)
	self.events[name] = func;
end

function dnkElement:call(name, ...)
	if self.events[name] then
		self.events[name](self, ...);
	end
end