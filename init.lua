--[[ init.d -------------------------------------------------------------------

This init.lua does not contain any customisation, but instead runs all files
under init/ in lexicographical order. Those files are prefixed with 2 numbers
for ordering:

00 -- global init
10 -- plugin configuration
20 -- LSP
30 -- Options
40 -- UI configuration
50 -- Mappings & editing configuration
60 -- Autocmds
70 -- Misc
80 -- (unused)
90 -- after init

-- Notes ----------------------------------------------------------------------

more motions would be nice:
- w/W that skips punctuation
- H/M/L aren't really that useful by default

-- Mapping Chart --------------------------------------------------------------

---|----------------|-------------------------|----------------
key| regular        | shift                   | ctrl
---|----------------|-------------------------|----------------
q  | record         | code action             | ?
w  | word           | WORD                    | multi (window)
e  | end            | END                     | scroll down
r  | replace char   | replace mode            | redo
t  | til            | TIL                     | ?
y  | yank           | y$                      | scroll up
u  | undo           | ?                       | up 1/2 page
i  | insert         | insert at start         | (=tab) fold
o  | new line after | new line before         | older pos
p  | paste after    | past before             | newer pos
a  | append         | append at end           | increment
s  | segment        | ?0C                     | ?
d  | delete         | d$                      | down 1/2 page
f  | find           | FIND                    | down page
g  | many           | last line               | ?git info
h  | left           | ?high                   | win left
j  | down           | join                    | win down
k  | up             | hover/help              | win up
l  | right          | ?low                    | win right
z  | many           | ?save or quit           | suspend
x  | delete char    | ?delete before cursor   | decrement
c  | change         | c$                      | interrupt
v  | visual         | visual line             | visual block
b  | back           | BACK                    | up page
n  | next match     | prev match              | ?
m  | mark           | ?mid                    | ?
---|----------------|-------------------------|----------------

--]]

if vim.g.vscode ~= nil then
	return -- config is wholly incompatible
end

local files = vim.fn.globpath(vim.fn.stdpath("config"), "init/*", false, true)
table.sort(files)
for _, file in ipairs(files) do
	vim.cmd.source(file)
end
