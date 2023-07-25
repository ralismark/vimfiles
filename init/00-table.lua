_G.table.append = function(list1, list2)
	for _, v in ipairs(list2) do
		table.insert(list1, v)
	end
	return list1
end

_G.table.slice = function(list, from, to)
	if to == nil then
		to = #list
	end
	if from == nil then
		from = 0
	end
	local out = {}
	for i = from, to, 1 do
		table.insert(out, list[i])
	end
	return out
end
