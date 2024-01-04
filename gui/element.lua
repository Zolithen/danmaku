dnkElement = Node:extend("dnkElement");

function dnkElement:init(parent, name, x, y)
	dnkElement.super.init(self, parent, name, x, y);
	if parent and parent.is_holder and not parent:is_holder() then
		error("Non-holder elements should not have children.");
	end
	self.events = {};
	self.content_height = 0;
end

function dnkElement:update(dt)
	
end

-- TODO: Make it so if we connect to an unknown event name an error is thrown
-- TODO: Add support for multiple connects to an event
function dnkElement:connect(name, func)
	if self.events[name] then
		table.insert(self.events[name], func)
		return self;
	else
		self.events[name] = {func};
		return self;
	end
end

function dnkElement:call(name, ...)
	if self.events[name] then
		for i, v in ipairs(self.events[name]) do
			v(self, ...);
		end
	end
end

function dnkElement:get_window()
	return self:get_root_(1);
end

function dnkElement:local_mouse_pos()
	return self:transform_vector(love.mouse.getX(), love.mouse.getY());
end

function dnkElement:is_holder()
	return false;
end

-- A resizable element should include a :resize function
-- TODO: Should we do the checks of resizability with .resize == nil instead of this? probably
function dnkElement:is_resizable()
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

--[[function dnkElement:on_add_children(n, id)
	if not self:instanceOf(dnkWindow) then
		self:get_window():on_add_children(n, id)
	end
end]]

-- Returns the box the element resides in local coordinates ((0,0) is the element's upper left corner)
function dnkElement:box_full()
	return 0, 0, 0, 0
end

-- It's important to have setters for the position because an update to the position may cause us to recalculate stuff like the content height
-- It may be good practice if we want to cache things later on
function dnkElement:set_x(x)
	self.x = x;
	self:get_window():calculate_content_height();
end

function dnkElement:set_y(y)
	self.y = y;
	self:get_window():calculate_content_height();
end

-- Calculates the height of all the content in the window. Used for scrolling n stuff
-- TODO: Content height of alone elements?
function dnkElement:calculate_content_height()
	local maxy, _x, _y, _w, _h = 0, 0, 0, 0, 0;

	for i, v in ipairs(self.children) do
		if v:instanceOf(dnkGroup) then
			_h = v:calculate_content_height(); 
		else
			_x, _y, _w, _h = v:box_full();
		end
		maxy = math.max(maxy, v.y + _h);
	end

	self.content_height = maxy;
	return maxy;
end