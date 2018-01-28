" MicroWiki
" Author: Timmy Yao
" Version: 0.1.0
" Last Modified: 4 October 2017
"
" Vimwiki is a good plugin, but is too intrusive, making several bindings that
" you may not want. Additionally, it has a weird syntax by default, requiring
" other options to change it to markdown

" Set uwiki#extension to use a filetype other than markdown. This is used for
" new files only

if !exists('uwiki#extension')
	let uwiki#extension = 'md'
endif

" Set uwiki#defaults to 0 if you want to disable all defaults from
" autocommands (see plugin/uwiki.vim)

if !exists('uwiki#defaults')
	let uwiki#defaults = 1
endif

" Get the uppermost directory of a wiki
function! uwiki#get_root_dir()

	" To find the root directory, we need to find the uppermost index.md
	" This is done by finding the individual directory names in the path,
	" then creating all paths that contain cwd (including cwd itself)
	"
	" i.e. /a/b/c -> ['a', 'b', 'c'] -> ['/a', '/a/b', '/a/b/c']

	let path_components = split(getcwd(), '/') " all individual components of the path
	let subpaths = map(range(len(path_components)), { i -> '/' . join(path_components[:i], '/') }) " list of subpaths

	" Afterwards, we search in that path list for the root file, and take
	" the first that we match. This is done easily using globpath().

	let indexpath = globpath(join(subpaths, ','), 'index.*')

	" However, this is the path to the root file, not the directory. We
	" then remove the last component to get the path, or return an empty
	" one if none is found

	return indexpath == '' ? '' : fnamemodify(indexpath, ':h')

endfunction

"Get the root directory, throwing an error if not found
function! uwiki#checked_get_root_dir()

	" Sice uwiki#get_root_dir() returns an empty string when not found, we
	" just have to throw an error when that happens

	let root_dir = uwiki#get_root_dir()
	if root_dir == ''
		throw "wiki: current directory not in a wiki"
	endif
	return root_dir

endfunction

" Syntax highlighting for things
function! uwiki#syntax_highlight()

	" Links are things between pairs of brackets

	syntax match UWikiRef /\[\[[^]]*\]\]/ containedin=ALLBUT,error,UWikiRef

	hi def link UWikiRef Underlined

endfunction

" Do mappings
function! uwiki#mappings()

	nmap <buffer> <c-cr> <Plug>UWikiMakeOrGotoRef
	vmap <buffer> <c-cr> <Plug>UWikiMakeVRef
	nmap <buffer> <c-space> <Plug>UWikiCycleCheckbox

endfunction
