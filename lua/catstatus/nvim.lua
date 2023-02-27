local M = { }

local config = {
	colors = {
		normalmode = "#A9DC76",
		insertmode = "#78DCE8",
		filename = "#AB9DF2",
		visualmode = "#f57800",
		ossymbol = "#ff0000", 
		replace = "#FF6188",
		terminal = "#727072",
	}
}

local function merge_config(user_config)
	config = vim.tbl_deep_extend("force", config, user_config or {})
end 

local refresh_timer = vim.loop.new_timer()

local filetypes = {
	["cpp"] = "",
	["c"] = "",
	["rs"] = "󱘗",
	["java"] = "",
	["js"] = "",
	["css"] = "",
	["html"] = "",
	["python"] = "",
	["py"] = "",
	["lua"] = "󰢱",
	["vim"] = "",
	["sh"] = "",
	["bash"] = "",
}

local modes = {
	["n"] = "%#NormalSepStart#%#NormalStr# NORMAL %#NormalSep#",
	["i"] = "%#InsertSepStart#%#InsertStr# INSERT %#InsertSep#",
	["ic"] = "%#InsertSepStart#%#InsertStr# INSERT %#InsertSep#",
	["ix"] = "%#InsertSepStart#%#InsertStr# INSERT %#InsertSep#",
	["v"] = "%#VisualSepStart#%#VisualStr# Visual %#VisualSep#",
	["V"] = "%#VisualSepStart#%#VisualStr# Visual line %#VisualSep#", 
	["\22"] = "%#VisualSepStart#%#VisualStr# Visual Block %#VisualSep#",
	["R"] = "%#ReplaceSepStart#%#ReplaceStr# Replace %#ReplaceSep#",
	["Rc"] = "%#ReplaceSepStart#%#ReplaceStr# Replace %#ReplaceSep#",
	["Rv"] = "%#ReplaceSepStart#%#ReplaceStr# Replace %#ReplaceSep#",
	["Rx"] = "%#ReplaceSepStart#%#ReplaceStr# Replace %#ReplaceSep#",
	["c"] = "Command Line Editing",
	["cv"] = "Vim Ex Mode",
	["ce"] = "Normal Ex Mode",
	["r"] = "Prompt",
	["!"] = "Shell",
	["t"] = "%#TerminalSepStart#%#TerminalStr# Terminal %#TerminalSep#",
	["nt"] ="%#TerminalSepStart#%#TerminalStr# Terminal %#TerminalSep#",
}

local function ft_contains(key) 
	return filetypes[key] ~= nil
end

local function get_ft_symbol() 
	local ftype = vim.bo.filetype
	if not ftype or ftype == "" then
		ftype = vim.fn.expand("%:e")
	end
	
	local ret = ""
	if ft_contains(ftype) then 
		ret = filetypes[ftype]
	end

	return ret .. " " .. ftype;
end

local function get_nvim_mode() 
	local mode = modes[vim.api.nvim_get_mode().mode]
	if not mode or mode == "" then
		mode = vim.api.nvim_get_mode().mode		
	end
	--TODO Colors?
	return mode
end

local function get_file_format() 
	local fmt_sym = {
		["unix"] = '  ',
		["dos"] = '  ',
		["mac"] = '  '
	}
	--return a symbol or the file format as a string
	return "%#OSSymbol#" .. fmt_sym[vim.bo.fileformat] .. vim.bo.fileformat or vim.bo.fileformat
end

local function set_statusline()
	vim.opt.statusline = table.concat {
		"%#Status#",
		"%#FileNameStr# ",
		"%f%r%m %#FileNameSep#",
		get_nvim_mode(),
		" ",
		"%#StatusLine#",
		get_file_format(),
		"%=",
		"%#Status#",
		"%#StatusLine#",
		"%=",
		"%#StatusSep#%#StatusRight# ",
		get_ft_symbol(),
		" %c:%l %p%% "

	}

end

local function refresh() 
	set_statusline()
end

local function set_highlight(group, fg, bg, gui) 
	vim.cmd("highlight " .. group .. " guifg=" .. fg .. " guibg=" .. bg .. " gui=" .. gui)
end

local function setup(user_config)
	merge_config(user_config)
	set_highlight("NormalStr", "NONE", config.colors.normalmode, "NONE");
	set_highlight("NormalSep", config.colors.normalmode, "NONE", "NONE")
	set_highlight("InsertStr", "NONE", config.colors.insertmode, "NONE");
	set_highlight("InsertSep", config.colors.insertmode, "NONE", "NONE")
	set_highlight("InsertSepStart", config.colors.filename, config.colors.insertmode, "NONE")	
	set_highlight("NormalSepStart", config.colors.filename, config.colors.normalmode, "NONE")	
	set_highlight("ReplaceSepStart", config.colors.filename, config.colors.replace, "NONE")	
	set_highlight("VisualSepStart", config.colors.filename, config.colors.visualmode, "NONE")	
	set_highlight("TerminalSepStart", config.colors.filename, config.colors.terminal, "NONE")	
	set_highlight("OSSymbol", config.colors.ossymbol, "NONE", "NONE")	
	set_highlight("FileNameStr", "NONE", config.colors.filename, "NONE")
	set_highlight("FileNameSep", config.colors.filename, config.colors.normalmode, "NONE")
	set_highlight("VisualStr", "NONE", config.colors.visualmode, "NONE")
	set_highlight("VisualSep", config.colors.visualmode, "NONE", "NONE")
	set_highlight("TerminalSep", config.colors.terminal, "NONE", "NONE")
	set_highlight("TerminalStr", "NONE", config.colors.terminal, "NONE")
	set_highlight("ReplaceStr", "NONE", config.colors.replace, "NONE")
	set_highlight("ReplaceSep", config.colors.replace, "NONE", "NONE")

	set_highlight("StatusLine", "NONE", "NONE", "NONE");
	set_highlight("StatusSep", config.colors.filename, "NONE", "NONE");
	set_highlight("StatusRight", "#f8f8f2", config.colors.filename, "bold");
	set_statusline()
	refresh_timer:start(100, 100, vim.schedule_wrap(refresh))
end



M = {
	setup = setup,
	refresh = refresh,
}

return M
