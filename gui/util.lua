function math.point_in_box(x, y, x1, y1, w1, h1)
	return (x >= x1) and
		   (y >= y1) and
		   (x <= x1 + w1) and
		   (y <= y1 + h1)
end

function math.mouse_in_box(x1, y1, w1, h1)
	local x = love.mouse.getX();
	local y = love.mouse.getY();
	return (x >= x1) and
		   (y >= y1) and
		   (x <= x1 + w1) and
		   (y <= y1 + h1)	
end

function math.uuid()
    local template ='xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'
    local st = string.gsub(template, '[xy]', function (c)
        local v = (c == 'x') and math.random(0, 0xf) or math.random(8, 0xb)
        return string.format('%x', v)
    end)
    return st
end

function math.clamp(x, m, M)
	return math.max(m, math.min(M, x))
end

-- Returns whole division
function math.euclid(a, b)
	return (a - a%b)/b
end

function math.hsv2rgb(h, s, v)
	if s <= 0 then return v, v, v end
	h = h*6;
	local c = v*s;
	local x = (1-math.abs((h%2) - 1))*c;
	local m, r, g, b = v-c, 0, 0, 0;
	if h < 1 then
		r, g, b = c, x, 0
	elseif h < 2 then
		r, g, b = x, c, 0
	elseif h < 3 then
		r, g, b = 0, c, x
	elseif h < 4 then
		r, g, b = 0, x, c
	elseif h < 5 then
		r, g, b = x, 0, c
	else
		r, g, b = c, 0, x
	end
	return r+m, g+m, b+m
end

function math.rgb2hsv(r, g, b, a)
	a = a or 1;
	local max = math.max(r, g, b);
	local min = math.min(r, g, b);
	local h, s;
	local v = max;

	local d = max - min;
	if max == 0 then s = 0 else s = d / max end;

	if max == min then
		h = 0;
	else
		if max == r then
			h = (g - b) / d;
			if g < b then h = h + 6 end;
		elseif max == g then h = ((b - r) / d) + 2;
		elseif max == b then h = ((r - g) / d) + 4 end;
		h = h / 6;
	end

	return h, s, v, a;
end

function table.insert_everything(t, ...)
	local others = {...};
	for it, other in ipairs(others) do
		for i, v in ipairs(other) do
			table.insert(t, v)
		end
	end	
end

function table.simple_copy(t)
	local ret = {}
	for i, v in pairs(t) do
		if type(v) == "function" or type(v) == "userdata" then
			error("Can't copy a table with functions inside.");
		end
		if type(v) == "table" then
			ret[i] = table.simple_copy(v);
		else
			ret[i] = v;
		end
	end
	return ret;
end

_utf8 = {};
function _utf8.sub(text, i, j)
	if j == -1 then
		return {utf8.codepoint(text, utf8.offset(text, i), utf8.offset(text, utf8.len(text)))}
	end
	return j ~= 0 and {utf8.codepoint(text, utf8.offset(text, i), utf8.offset(text, j))} or {}
end

function _utf8.from(text)
	return {utf8.codepoint(text, 1, utf8.offset(text, utf8.len(text)))};
end

function _utf8.from_safe(text)
	local len = utf8.len(text);
	if len == 0 then
		return {};
	else
		return {utf8.codepoint(text, 1, utf8.offset(text, len))};
	end
end

function _utf8.to(t)
	return utf8.char(unpack(t));
end

local function reversedipairsiter(t, i)
    i = i - 1
    if i ~= 0 then
        return i, t[i]
    end
end

function r_ipairs(t)
    return reversedipairsiter, t, #t + 1
end

function set_union(a, b)
	for i, v in pairs(b) do
		if a[i] then
			error("Two sets have the same key and are being unioned. This is a bug.");
		else
			a[i] = v;
		end
	end
end

function set_union_ignore_dupes(a, b)
	for i, v in pairs(b) do
		if not a[i] then
			a[i] = v;
		end
	end
end