require("vis")
local vis = vis

local M

local builtin_textobjects = {
	["["] = {{ "[" , "]" }, id =  7},  -- +/VIS_TEXTOBJECT_OUTER_SQUARE_BRACKET vis.h
	["{"] = {{ "{" , "}" }, id =  9},  -- +/VIS_TEXTOBJECT_OUTER_CURLY_BRACKET vis.h
	["<"] = {{ "<" , ">" }, id = 11},  -- +/VIS_TEXTOBJECT_OUTER_ANGLE_BRACKET vis.h
	["("] = {{ "(" , ")" }, id = 13},  -- +/VIS_TEXTOBJECT_OUTER_PARENTHESIS vis.h
	['"'] = {{ '"' , '"' }, id = 15},  -- +/VIS_TEXTOBJECT_OUTER_QUOTE vis.h
	["'"] = {{ "'" , "'" }, id = 17},  -- +/VIS_TEXTOBJECT_OUTER_SINGLE_QUOTE vis.h
	["`"] = {{ "`" , "`" }, id = 19},  -- +/VIS_TEXTOBJECT_OUTER_BACKTICK vis.h
	        {{ ""  , ""  }, id = 28},  -- +/VIS_TEXTOBJECT_INVALID vis.h
}

local aliases = {}
for key, data in pairs(builtin_textobjects) do local pair = data[1] aliases[pair[2]] = key ~= pair[2] and data or nil end
for alias, data in pairs(aliases) do builtin_textobjects[alias] = data end
for alias, key in pairs({
	B = "{",
	b = "(",
}) do builtin_textobjects[alias] = builtin_textobjects[key] end

local function get_pair(key) return builtin_textobjects[key] and builtin_textobjects[key][1] end

local function take_param(win, d)
	if d and type(d[3]) == "table" then
		if #d[3] == 2 then
			if table.concat(d[3]):find("\xef\xbf\xbd", 1, true) then
				local status, out = vis:pipe(win.file, { start = 0, finish = 0 }, "vis-menu" .. (d[4] and " -p '"..d[4]..":'" or ""))
				if status == 0 then
					local param = out:sub(1, -2)
					return {d[3][1]:gsub("\xef\xbf\xbd", param), d[3][2]:gsub("\xef\xbf\xbd", param)}
				end
			else
				return d[3]
			end
		end
	else
		return d
	end
end

local function adjust_spacing(file, range, d)
	local padding = ""
	if vis.mode == vis.modes.VISUAL_LINE then
		padding = d[1] ~= "\n" and "\n" or padding
	elseif vis.mode ~= vis.modes.VISUAL then
		local trailing = file:content(range):match("(%s*)$")
		if #trailing > 0 then
			range.finish = range.finish - #trailing
		end
	end
	return padding
end

local function add(file, range, pos)
	if not (range.finish > range.start) then return pos end
	local d = take_param(vis.win, get_pair(M.key[1], pos))
	if not d then return pos end
	local padding = adjust_spacing(file, range, d)
	file:insert(range.finish, d[2] .. padding)
	file:insert(range.start, d[1] .. padding)
	return pos + #d[1] + #padding
end

local function escape(text)
	return text:gsub("[][^$)(%%.*+?-]", "%%%0")
end

local function delimiters_in_place(file, range, pos, key, get_padding)
	local start, slen, finish, flen
	if vis.mode == vis.modes.VISUAL_LINE then
		local block = file:content(range)
		vis.count = nil
		local d = get_pair(key, range.start + block:find("\n", 1, true))
		if not (d and d[1] and d[2]) then return end
		local d1, d2 = escape(d[1]), escape(d[2])
		local sl = table.pack(block:match("^()[ \t]*()"..d1.."[ \t]-\n()"))
		if #sl == 0 then
			sl = table.pack(block:match("()[ \t]*()"..d1.."[ \t]-()\n"))
		end
		local el = table.pack(block:match("()\n[ \t]*()"..d2.."()[ \t]*\n$"))
		if #el == 0 then
			el = table.pack(block:match("\n[ \t]*()()"..d2.."[ \t]*()[^\n]-\n$"))
		end
		if not (#sl > 0 and #el > 0) then return end
		start = range.start + sl[get_padding and 1 or 2] - 1
		slen = get_padding and sl[3] - sl[1] or #d[1]
		finish = range.start + el[get_padding and 1 or 2] - 1
		flen = get_padding and el[3] - el[1] or #d[2]
	else
		local d = get_pair(key, pos)
		if not (d and d[1] and d[2]) then return end
		if file:content(range.start, #d[1]):find(d[1], 1, true)
			and file:content(range.finish - #d[2], #d[2]):find(d[2], 1, true) then
			start, slen, finish, flen = range.start, #d[1], range.finish - #d[2], #d[2]
		end
	end
	return start, slen, finish, flen
end

local function change(file, range, pos)
	if not (range.finish > range.start) then return pos end
	local start, slen, finish, flen = delimiters_in_place(file, range, pos, M.key[1])
	if not start then return pos end
	local n = take_param(vis.win, get_pair(M.key[2], pos))
	if not n then return pos end
	file:delete(finish, flen)
	file:insert(finish, n[2])
	file:delete(start, slen)
	file:insert(start, n[1])
	if pos < range.start + slen then
		return (pos < range.start + #n[1] and pos < range.start + slen - 1 or slen == 1) and pos or range.start + #n[1] - 1
	elseif pos >= range.finish - flen then
		return (pos < range.finish - flen + #n[2] and pos < range.finish - 1) and pos - slen + #n[1] or range.finish - slen - flen + #n[1] + #n[2] - 1
	else
		return pos - slen + #n[1]
	end
end

local function delete(file, range, pos)
	if not (range.finish > range.start) then return pos end
	local start, slen, finish, flen = delimiters_in_place(file, range, pos, M.key[1], true)
	if not start then return pos end
	file:delete(finish, flen)
	file:delete(start, slen)
	return pos - (pos >= finish + flen and slen + flen or slen)
end

local function outer(key) return builtin_textobjects[key] and builtin_textobjects[key].id or builtin_textobjects[1].id end

local function va_call(id, nargs, needs_range)
	return function(keys)
		if #keys < nargs then return -1 end
		if #keys == nargs then
			M.key = {}
			for key in keys:gmatch(".") do table.insert(M.key, key) end
			vis:operator(id)
			if needs_range then
				vis:textobject(outer(M.key[1]))
			end
		end
		return #keys
	end
end

local function operator_new(prefix, handler, nargs, help)
	local id = vis:operator_register(handler)
	if id < 0 then
		return false
	end
	if type(prefix) == "table" then
		local needs_range = ({[change] = true, [delete] = true})[handler]
		if prefix[1] then vis:map(vis.modes.NORMAL, prefix[1], va_call(id, nargs, needs_range), help) end
		if prefix[2] then vis:map(vis.modes.VISUAL, prefix[2], va_call(id, nargs), help) end
	end
	return id
end

vis.events.subscribe(vis.events.INIT, function()
	M.operator = {
		add = operator_new(M.prefix.add, add, 1, "Add delimiters at range boundaries"),
		change = operator_new(M.prefix.change, change, 2, "Change delimiters at range boundaries"),
		delete = operator_new(M.prefix.delete, delete, 1, "Delete delimiters at range boundaries"),
	}
	if package.loaded["pairs"] then
		local p = require("pairs")
		get_pair = function(key, pos) return p.get_pair(key, vis.win, pos) end
		outer = function(key) p.key = key return p.textobject.outer end
	end
end)

M = {
	prefix = {add = {"ys", "S"}, change = {"cs", "C"}, delete = {"ds", "D"}},
}

return M
