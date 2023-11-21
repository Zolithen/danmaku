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

function dnkElement:local_mouse_pos()
	return self:transform_vector(love.mouse.getX(), love.mouse.getY());
end

function dnkElement:is_holder()
	return false;
end

-- Gets the current holder of the GUI element (ex: window, or panel)
function dnkElement:get_holder()
	if self:is_holder() then
		return self;
	end

	if self.parent then
		return self.parent:get_holder();	
	else
		error("Trying to get holder of orphan element.");
	end
end