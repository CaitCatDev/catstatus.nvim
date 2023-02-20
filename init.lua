local M = { }

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
	["n"] = "Normal",
	["i"] = "Insert",
	["ic"] = "Insert Completion",
	["ix"] = "Insert i_CTRL-X Completion",
	["v"] = "Visual",
	["V"] = "Visual line",
	["^V"] = "Visual Block",
	["R"] = "Replace",
	["Rc"] = "Replace Completion",
	["Rv"] = "Replace Virtual",
	["Rx"] = "Replace i_CTRL-X Completion",
	["c"] = "Command Line Editing",
	["cv"] = "Vim Ex Mode",
	["ce"] = "Normal Ex Mode",
	["r"] = "Prompt",
	["!"] = "Shell",
	["t"] = "Terminal",
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
		mode = "UNKNOWN"
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
	return fmt_sym[vim.bo.fileformat] .. vim.bo.fileformat or vim.bo.fileformat
end

local function set_statusline()
	vim.opt.statusline = table.concat {
		"%#Status#",
		"%f%r%m ",
		get_nvim_mode(),
		" %#StatusSep# ",
		"%#StatusLine#",
		get_file_format(),
		"%=",
		"%#Status#",
		"%#StatusLine#",
		"%=",
		"%#StatusSep#%#Status# ",
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
	
	set_highlight("StatusLine", "NONE", "NONE", "NONE");
	set_highlight("StatusSep", "#282a36", "NONE", "NONE");
	set_highlight("Status", "#c5c8c6", "#282a36", "bold");
	set_statusline()
	refresh_timer:start(100, 100, vim.schedule_wrap(refresh))
end



M = {
	setup = setup,
	refresh = refresh,
}

return M
