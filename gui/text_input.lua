-- TODO: Test please
gui.TextInput = {}

set_union(gui.TextInput, gui.Events);

function gui.TextInput.new(x, y, w, h)
	local self = {
		x = x,
		y = y,
		w = w,
		h = h, -- TODO: Change so height is obtained from the font?¿?¿
		scroll_w = 0,
		focused = false,
		text = "",
		text_drawable = nil,
		update_canvas = false,
		cursor_pos = 0
	}

	setmetatable(self, {
		__index = gui.TextInput
	})
	self:setup_events();

	self.canvas = lg.newCanvas(self.w, self.h);
	self.text_drawable = love.graphics.newText(gui.Skin.font, self.text);
	self.text_at_cursor = love.graphics.newText(gui.Skin.font, self.text);

	return self
end

function gui.TextInput:draw(mx, my)
	if self.update_canvas then -- If we updated the canvas every frame we would get high GPU usage
		lg.push("all");
		lg.setCanvas(self.canvas);
			lg.clear();

			lg.setColor(1, 1, 1, 1);
			lg.draw(self.text_drawable, -self.scroll_w, 0);

			--[[if self.parent.focused and self.focused then
				--lg.line(self.text_at_cursor:getWidth()-self.scroll_w, 0, self.text_at_cursor:getWidth()-self.scroll_w, self.h);
			end]]
		lg.pop();
		self.update_canvas = false;
	end

	--self.parent:is_mouse_over() and
	if (self.parent.focused) and (self.focused or math.point_in_box(mx, my, self:box_full())) then
		lg.setColor(gui.Skin.back_highlight);
	else
		lg.setColor(gui.Skin.back_light);
	end
	lg.rectangle("fill", self.x, self.y, self.w, self.h);

	lg.setColor(1, 1, 1, 1);
	lg.draw(self.canvas, self.x, self.y);

	-- Draw the cursor
	if self.parent.focused and self.focused then
		lg.line(self.x + self.text_at_cursor:getWidth()-self.scroll_w, self.y, self.x + self.text_at_cursor:getWidth()-self.scroll_w, self.y+self.h);
	end
end

-- TODO: If 2 inputs are near we can select both at once, we shouldn't be able to
function gui.TextInput:mousepressed(x, y, b)
	if b == 1 and math.point_in_box(x, y, self:box_full()) then
		self.focused = true;
		if ANDROID then -- TODO: Make this correctly
			love.keyboard.setTextInput(true, self.x+self.parent.x, self.y+self.parent.y, self.w, self.h);
		end
	elseif self.focused == true then -- TODO: Do we need b == 1 here?
		self.focused = false;
		if ANDROID then
			love.keyboard.setTextInput(false);
		end
		self.update_canvas = true;
	end
end

function gui.TextInput:keypressed(key, scancode, is_repeat)
	-- Something will definitely be off here
	if not self.focused then return end;
	if key == "backspace" then
		local first = utf8.offset(self.text, self.cursor_pos);
		local second = utf8.offset(self.text, self.cursor_pos+1);

        if first and self.cursor_pos ~= 0 then
        	if second then
				self.text = string.sub(self.text, 1, first-1) .. string.sub(self.text, second, -1);
        	else
            	self.text = string.sub(self.text, 1, first-1);
        	end
            self.cursor_pos = self.cursor_pos - 1;
        end
        self:call("update_text");
	elseif key == "right" then
		self.cursor_pos = math.min(string.len(self.text), self.cursor_pos + 1);
	elseif key == "left" then
		self.cursor_pos = math.max(0, self.cursor_pos - 1);
	elseif key == "return" then -- TODO: How the fuck are we gonna do events?
		self.focused = false;
		if ANDROID then
			love.keyboard.setTextInput(false);
		end
		self:call("finish_text");
	end

	self:update_drawable_text(); -- Who cares about it being updated 2 times? TODO: Make sure it's actually garbage collected
end

function gui.TextInput:textinput(t)
	if self.focused then
		if self.cursor_pos == 0 then
			self.text = t .. string.sub(self.text, utf8.offset(self.text, self.cursor_pos), -1);
		else
			self.text = string.sub(self.text, 1, utf8.offset(self.text, self.cursor_pos)) .. t .. string.sub(self.text, utf8.offset(self.text, self.cursor_pos)+1, -1);
		end
		--self.text = self.text .. t;
		self.cursor_pos = self.cursor_pos + 1; -- POTENTIAL: This assumes textinput only gets one char at a time. Is it true?
		self:call("update_text");
	end
	self:update_drawable_text();
end

function gui.TextInput:update_drawable_text()
	self.update_canvas = true;
	self.text_drawable = love.graphics.newText(gui.Skin.font, self.text);
	if self.cursor_pos == 0 then
		self.text_at_cursor = love.graphics.newText(gui.Skin.font, "");
	else
		-- I hate UNICODE (FIXME)
		self.text_at_cursor = love.graphics.newText(gui.Skin.font, string.sub(self.text, 1, utf8.offset(self.text, self.cursor_pos) ));
	end

	-- Update the scrolling
	self.scroll_w = math.max(0, self.text_at_cursor:getWidth() - 3*self.w/4);
end

function gui.TextInput:box_full()
	return self.x, self.y, self.w, self.h
end