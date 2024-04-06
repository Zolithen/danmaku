dnkTreeList = dnkElement:extend("dnkTreeList");
dnkTreeNode = Node:extend("dnkTreeNode");

function dnkTreeNode:init(parent, name)
	dnkTreeNode.super.init(self, parent, name, 0, 0);
	self.focused = false;
	self.opened = false;
end

function dnkTreeList:init(parent, name, x, y, w, h)
	dnkTreeList.super.init(self, parent, name, x, y);

	self.canvas = lg.newCanvas(w, h);
	self.update_canvas = true;
	self.w = w;
	self.h = h;

	self.leaf_yoff = 0; -- Y Offset of the current leaf that is being drawn

	self.tree_mouse_map = {}; -- Table used to know which tree leaf has been clicked
	self.tree = dnkTreeNode(nil, "");
	self.tree.root = true;
	self.tree.opened = true;
	return self;
end

function dnkTreeList:resize(neww, newh)
	self.canvas = lg.newCanvas(neww, newh);
	self.w = neww;
	self.h = newh;
	self.update_canvas = true;
end

function dnkTreeList:draw()
	if self.update_canvas then
		self.tree_mouse_map = {};
		self.leaf_yoff = 0;
		lg.push("all");
			lg.origin();
			lg.setCanvas(self.canvas);
			lg.clear();
			lg.setColor(1, 1, 1, 1);
			self:draw_leaf(self.tree, 0);
			lg.setCanvas();
		lg.pop();
		self.update_canvas = false;
	end

	lg.setColor(1, 1, 1, 1);
	lg.draw(self.canvas, self.x, self.y);
end

function dnkTreeList:draw_leaf(node, xoffset)
	local xoff = xoffset or 0;
	if not node.root then
		table.insert(self.tree_mouse_map, node);
		if #node.children == 0 then
			lg.setColor(0, 0, 0, 1);
		else
			if node.opened then
				lg.setColor(0.8, 0.8, 0.8, 1)
			else
				lg.setColor(1, 1, 1, 1)
			end
		end
		lg.rectangle("fill", xoff-12, self.leaf_yoff+4, 8, 8);
		lg.setColor(1, 1, 1, 1);
		lg.print(node.name, xoff, self.leaf_yoff);
		self.leaf_yoff = self.leaf_yoff + 16;
	end
	if node.opened then
		for i, v in ipairs(node.children) do
			self:draw_leaf(v, xoff + 16);
		end
	end
end

function dnkTreeList:mousepressed(x, y, b)
	local mx, my = self:transform_vector(love.mouse.getX(), love.mouse.getY())
	if (b == 1 and self.parent.focused and math.point_in_box(mx, my, self:box_full())) then
		local clicked = math.floor(my/16) + 1;
		if self.tree_mouse_map[clicked] then -- TODO: This assumes every label is 16 pixels high. In general everything assumes that
			local n = self.tree_mouse_map[clicked];
			n.opened = not n.opened;
			self.update_canvas = true;
		end
	end
end

function dnkTreeList:box_full()
	return 0, 0, self.w, self.h
end
