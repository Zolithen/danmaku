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