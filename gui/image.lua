dnkImage = dnkElement:extend("dnkImage")

function dnkImage:init(parent, name, x, y)
	dnkImage.super.init(self, parent, name, x, y);
	self.w = 0;
	self.h = 0;
end

function dnkImage:set_image(path)
	if type(path) == "string" then
		if self.image then
			self.image:release();
		end
		self.image = lg.newImage(path);
		self.image:setFilter("nearest", "nearest");
		self.w = self.image:getWidth();
		self.h = self.image:getHeight();
	else
		error("Invalid path type"); -- TODO: Add support for directly passing an image data
	end

	return self;
end

function dnkImage:draw()
	if self.image then
		lg.setColor(1, 1, 1, 1);
		lg.draw(self.image, self.x, self.y);
	end
end

function dnkImage:box_full()
	return 0, 0, self.w, self.h;
end