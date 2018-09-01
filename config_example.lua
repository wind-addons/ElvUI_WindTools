local E, L, V, P, G = unpack(ElvUI)
--local LSM = LibStub("LibSharedMedia-3.0")
local WT = E:GetModule("WindTools")

local _G = _G

P["WindTools"][module_name] = {
	[feature_name] = {
		["enabled"] = true,
	},
}

WT.ToolConfigs[module_name] = {
	[feature_name] = {
		tDesc   = , -- necessary
		oAuthor = , -- necessary
		cAuthor = , -- necessary
		[arg_name] = {
			name = , -- necessary
			order = 5, -- necessary, start from 5
			type = , -- optional, determined by WindTools itself if not set
			disabled = , -- optional, determined by WindTools itself if not set
			-- guiInline = , -- useless, always determined by WindTools itself
			-- get = ,
			-- set = ,
			args = {
				sub_arg_name = {
					name = , -- necessary
					order = 0, -- necessary, start from 0
					type = , -- optional, determined by WindTools itself if not set
					get = ,
					set = ,
				},
			}
		},
		func = nil, -- optional, run before option insertion, can be used to modify WT.ToolConfigs iteratively
	},
}