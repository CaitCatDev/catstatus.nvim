# catstatus.nvim

A neovim status line plugin. Currently we are in early development and do not support and runtime options instead currently the format of the staus line is static. 

This plugin was inspired by Lualine and https://nihilistkitten.me/nvim-lua-statusline. As it seemed rather simple and I wanted to make my own basic sttatus line to gain an apperication for how it works and for my first project in LUA and in plugin in Neovim so to firsts for me.

# Installing:

Installing should just require you to add this plugin repo to your nvim plugin manager list of plugins then update your plugins and add. To your nvim's init.lua file. Currently there are no setup options but we do plan to add some.

```lua
require ("catstatus.nvim").setup {

}
```

Or if you would like to customise the colors do so like below 

```lua
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
```
