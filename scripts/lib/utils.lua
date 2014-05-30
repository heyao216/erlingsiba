--将table2插入table1后面并返回table1
function concatTable(table1 , table2)
	for i = 1, #table2 do
		table.insert(table1 , table2[i])
	end
	return table1
end

--剔除nil元素,返回一个新的table
function trimNilValue(t)
	local t2 = {}
	for i = 1 , #t do
		if t[i] ~= nil then
			table.insert(t2 , t[i])
		end
	end
	return t2
end

--角度转换为弧度
function ang2rad(angle)
	return angle / 180 * math.pi
end

--弧度转换为角度
function rad2ang(rad)
	return rad * 180
end

--由一个十六进制字符串(#FFFFFFFF)转换成一个cccolor颜色值
function hexToColor(hex)
	local v1 = convertToNum(string.sub(hex , 2 , 2)) * 16 + convertToNum(string.sub(hex , 3 , 3))
	local v2 = convertToNum(string.sub(hex , 4 , 4)) * 16 + convertToNum(string.sub(hex , 5 , 5))
	local v3 = convertToNum(string.sub(hex , 6 , 6)) * 16 + convertToNum(string.sub(hex , 7 , 7))
	if string.len(hex) == 9 then
		local v4 = convertToNum(string.sub(hex , 8 , 8)) * 16 + convertToNum(string.sub(hex , 9 , 9))
		return ccc4(v2, v3, v4, v1)
	else
		return ccc3(v1, v2, v3)
	end
end

function convertToNum(str)
	str = string.upper(str)
	if str == "F" then
		return 15
	elseif str == "E" then
		return 14
	elseif str == "D" then
		return 13
	elseif str == "C" then
		return 12
	elseif str == "B" then
		return 11
	elseif str == "A" then
		return 10
	else
		return tonumber(str)
	end
end