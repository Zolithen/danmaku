function element_tostring(e, key, table_level, tabs)
	if key == "class" or key == "__index"  or key == "super" or key == "parent" then
		return key;
	end
	if type(e) == "function" then
		return "FUNCTION";
	elseif type(e) == "table" then
		if table_level >= 10 then
			return "MAX DEPTH LEVEL REACHED"
		else
			local m = "<br>"
			if e.class then
				if e.class.name == nil then
					m = "class&ltNIL_CLASS&gt" .. m;
				else
					m = "class&lt" .. e.class.name .. "&gt" .. m;
				end
			end
			return m .. dump_table1(e, table_level, tabs);
		end
	end
	return tostring(e);
end

function dump_table1(x, table_level, tabs)
	local name_bag = {}
	local kout = "";
	for i, v in pairs(x) do
		if type(i) == "string" or type(i) == "number" then
			table.insert(name_bag, i);
		end
	end
	table.sort(name_bag);
	for i, v in ipairs(name_bag) do
		kout = kout .. tabs .. v .. ": " .. element_tostring(x[v], v, table_level + 1, tabs .. "&nbsp&nbsp&nbsp&nbsp") .. "<br>\n";
	end
	return kout;
end

function dump_table(x, n)
	ret = dump_table1(x, 0, "")
	ret = "<body style=\"background-color:black;color:white;\">" .. ret .. "</body>"
	writefile(n .. ".html", ret)
	return(ret)
end

function writefile(filename, value)
	if (value) then
		local file = io.open(filename,"w+")
		file:write(value)
		file:close()
	end
end