-- TODO: Test please
dnkTextInput = dnkElement:extend("dnkTextInput");

-- TODO: Make an option to only input numbers
function dnkTextInput:init(parent, name, x, y, w, h)
	dnkTextInput.super.init(self, parent, name, x, y);
	self.w = w;
	self.h = h; -- TODO: Change so height is obtained from the font?¿?¿
	self.scroll_w = 0;
	self.focused = false;
	self.text = "";
	self.text_drawable = nil;
	self.update_canvas = false;
	self.cursor_pos = 0;

	self.canvas = lg.newCanvas(self.w, self.h);
	self.text_drawable = love.graphics.newText(gui.Skin.font, self.text);
	self.text_at_cursor = love.graphics.newText(gui.Skin.font, self.text);
end

function dnkTextInput:draw()
	local mx, my = self:transform_vector(love.mouse.getX(), love.mouse.getY());
	-- TODO: We don't need to update the canvas on draw. We can just do it immediately when we need updating
	if self.update_canvas then -- If we updated the canvas every frame we would get high GPU usage with lots of text inputs
		lg.push("all");
		lg.origin();
		lg.setCanvas(self.canvas);
			lg.clear();
			--lg.translate(0, -16)

			lg.setColor(1, 1, 1, 1);
			-- Floor is to not make the text blurry
			lg.draw(self.text_drawable, math.floor(-self.scroll_w), 0);

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
function dnkTextInput:mousepressed(x, y, b)
	local mx, my = self:transform_vector(love.mouse.getX(), love.mouse.getY())
	if b == 1 and math.point_in_box(mx, my, self:box_full()) then
		self.focused = true;
		if ANDROID then -- TODO: Make this correctly
			love.keyboard.setTextInput(true, self.x+self.parent.x, self.y+self.parent.y, self.w, self.h);
		end
	elseif self.focused == true then -- TODO: Do we need b == 1 here?
		self.focused = false;
		self:call("finish_text"); -- TODO: Test
		if ANDROID then
			love.keyboard.setTextInput(false);
		end
		self.update_canvas = true;
	end
end

function dnkTextInput:keypressed(key, scancode, is_repeat)
	-- Something will definitely be off here
	if not self.focused then return end;
	if key == "backspace" then
		if self.cursor_pos > 0 then
			local char_list = self.cursor_pos ~= 1 and _utf8.sub(self.text, 1, self.cursor_pos-1) or {};
			table.insert_everything(
				char_list,
				_utf8.sub(self.text, self.cursor_pos+1, -1)
			);

			self.text = _utf8.to(char_list);
			self.cursor_pos = self.cursor_pos - 1;

        	self:call("update_text");
    	end
	elseif key == "right" then
		self.cursor_pos = math.min(utf8.len(self.text), self.cursor_pos + 1);
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

function dnkTextInput:textinput(t)
	if self.focused then
		if utf8.len(self.text) == 0 then
			self.text = utf8.char(utf8.codepoint(t));
			self.cursor_pos = self.cursor_pos + 1;
		else
			local char_list = _utf8.sub(self.text, 1, self.cursor_pos);
			table.insert_everything(
				char_list,
				_utf8.from(t),
				_utf8.sub(self.text, self.cursor_pos+1, -1)
			);

			self.text = _utf8.to(char_list);
			self.cursor_pos = self.cursor_pos + 1; -- POTENTIAL: Assumes textinput only gets one character at a time
		end
		self:call("update_text");
	end
	self:update_drawable_text();
end

function dnkTextInput:update_drawable_text()
	self.update_canvas = true;
	-- TODO: Instead of remaking the whole text, do Text:add & Text:set
	self.text_drawable = love.graphics.newText(gui.Skin.font, self.text);
	if self.cursor_pos == 0 then
		self.text_at_cursor = love.graphics.newText(gui.Skin.font, "");
	else
		-- I hate UNICODE (FIXME)
		--self.text_at_cursor = love.graphics.newText(gui.Skin.font, string.sub(self.text, 1, utf8.offset(self.text, self.cursor_pos) ));
		self.text_at_cursor = love.graphics.newText(gui.Skin.font, _utf8.to( _utf8.sub(self.text, 1, self.cursor_pos) ));
	end

	-- Update the scrolling
	self.scroll_w = math.max(0, self.text_at_cursor:getWidth() - 3*self.w/4);
end

function dnkTextInput:set_text(t)
	self.cursor_pos = string.len(t);
	self.text = t;
	self:update_drawable_text();
end

function dnkTextInput:box_full()
	return 0, 0, self.w, self.h
end