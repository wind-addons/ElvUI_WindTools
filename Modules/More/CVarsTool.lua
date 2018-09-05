-- CVars 快速编辑
-- 作者：houshuu
-------------------

local E, L, V, P, G = unpack(ElvUI)
local WT = E:GetModule("WindTools")
local CVarsTool = E:NewModule('Wind_CVarsTool', 'AceHook-3.0', 'AceEvent-3.0', 'AceTimer-3.0');

-- 将部分值为 0/1 的 CVar 查询结果转换为布尔值
function CVarsTool.GetCVarBool(cvar)
	local current = GetCVar(cvar)
	if current == "1" then
		return true
	elseif current == "0" then
		return false
	else
		return nil
	end
end

-- 将布尔值转换为部分值为 0/1 的 CVar，并设定
function CVarsTool.SetCVarBool(cvar, value)
	if value then
		SetCVar(cvar, 1)
	else
		SetCVar(cvar, 0)
	end
end

E:RegisterModule(CVarsTool:GetName())