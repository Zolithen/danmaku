local Events = {}

function Events:setup_events()
	self.events = {};
end

function Events:connect(name, func)
	self.events[name] = func;
end

function Events:call(name, ...)
	if self.events[name] then
		self.events[name](self, ...);
	end
end

return Events;