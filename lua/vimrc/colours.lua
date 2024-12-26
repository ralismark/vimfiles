-- terminal colours
local M = {}

local solarized = {
	base03 = "#002b36",
	base02 = "#073642",
	base01 = "#586e75",
	base00 = "#657b83",
	base0  = "#839496",
	base1  = "#93a1a1",
	base2  = "#eee8d5",
	base3  = "#fdf6e3",
}

M.bg           = "#000816"
M.dim_black    = solarized.base02
M.bright_black = solarized.base01
M.dim_white    = solarized.base2
M.bright_white = solarized.base3
M.fg           = solarized.base3

M.dim_red     = "#dc322f"
M.dim_green   = "#859900"
M.dim_yellow  = "#b58900"
M.dim_blue    = "#268bd2"
M.dim_magenta = "#d33682"
M.dim_cyan    = "#2aa198"

M.bright_red     = "#e35d5b"
M.bright_green   = "#b1cc00"
M.bright_yellow  = "#e8b000"
M.bright_blue    = "#4ca2df"
M.bright_magenta = "#dc609c"
M.bright_cyan    = "#35c9be"

return M
