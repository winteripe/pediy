dofile(OdPath .. "LuaScripts\\init\\Init.lua")
dofile(OdPath .. "LuaScripts\\init\\LuaWindow.lua")
dofile(OdPath .. "LuaScripts\\init\\OllyCallBacks.lua")
dofile(OdPath .. "LuaScripts\\init\\PEFunc.lua")
--Ìæ»»´òÓ¡µ½Od log
function OdPrint(...)
	local arg = {...}
	local str = ""
	for k,v in pairs(arg) do
		str = str .. string.format("%-30s",tostring(v))
	end
	Od.Addtolist(0,0,str)
end
print = OdPrint