dnkElement = Node:extend("dnkElement");

function dnkElement:init(parent, name, x, y)
	dnkElement.super.init(self, parent, name, x, y);
	self.events = {};
end

function dnkElement:connect(name, func)
	self.events[name] = func;
	return self;
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
-- We want holders (like panels) to not return themselves instantly when calling get_holder
function dnkElement:get_holder()
	if self.parent then
		if self.parent:is_holder() then
			return self.parent;
		else
			return self.parent:get_holder();
		end
	else
		if self:is_holder() then -- TODO: Although here it we return it instantly, should we?¿
			return self;
		else
			error("Trying to get holder of orphan element.");	
		end
	end
end