" Work with references to other files
" Similar stuff can be accomplished with 'gf', though this will eventually
" support much more complex links
"
" In a wiki, you can make links to other pages (as well as any kind of
" resource, eventually). They are declared surrounded by [[ and ]] before and
" after correspondingly. The contents can be of many formats:
"
"  - Path, either relative (e.g. subdir/foo) or absolute (e.g. /bar/subdir/foo)
"
"       These refer to pages inside the wiki. Relative files are relative to
"       the current file, while absolute have the root of the wiki as their
"       root. Both of these links do not require the extension to be used. If
"       the file does not exist, it is created, with the extension (defaults
"       to .md) added.
"
" e.g. [[../foo/todo]] may open (root)/projects/foo/todo.md

" go to a reference in the current wiki, creating it if it doesn't exist
" in future, also handles external refs
function! uwiki#ref#go_to(ref)

	" If a link begins with a slash, it is absolute relative to the wiki
	" root. Otherwise, it's relative to the current file.

	let is_absolute = a:ref[0] == '/'
	let rel_to = is_absolute ? uwiki#checked_get_root_dir() : expand('%:p:h')

	" The file we want is ref relative to rel_to. We use existing files
	" (independent of extension), and append uwiki#extension if it doesnt
	" exist

	let target_base = rel_to . '/' . a:ref

	" If the file doesn't exist, we need to make sure all directories up
	" to it exist. This can be done with mkdir -p, which silently fails if
	" the directory already exists

	let target_file = glob(target_base . '.*')
	if target_file == ''
		let target_file = target_base . '.' . g:uwiki#extension
		call mkdir(fnamemodify(target_file, ':h'), 'p')
	endif

	" We then directly edit the file, making a new one if it doesn't exist

	exec 'edit' target_file

endfunction

" get the reference under the cursor
" we're using the vim-wiki syntax of [[ref]], though we may want to make this
" customisable in the future
function! uwiki#ref#get_current()

	" To find the ref, we'll need the contents of the current line as well
	" as the cursor offset

	let line = getline('.')
	let column = col('.') - 1 " first column = 1

	" We then find the last '[[' before the start of the cursor (including
	" the cursor and 1 char after in case the cursor is on the '[[')

	let partbefore = line[:column + 1]
	let mstart = match(partbefore, '\[\[[^\[]*$')

	" We then find the next ']]' on or after the cursor.

	let mend = matchend(line, '\]\]', column - 1)

	" Here, we exit either of the matches fail

	if mstart == -1 || mend == -1
		return ''
	endif

	" From mstart and mend, we can get the actual ref
	let inner_ref = line[mstart:mend - 1][2:-3]

	" We need to make sure there aren't any weird characters (i.e
	" brackets) in the ref, since that can cause it to be falsely matched
	" e.g. [[ a ]] # ]] - matching at # will falsely give a match

	if match(inner_ref, '\[') != -1 || match(inner_ref, '\]') != -1
		return '' " incorrect match
	endif

	" Finally, we trim the whitespace off of inner_ref

	return substitute(inner_ref, '^[[:space:]]*\|[[:space:]]*$', '', 'g')

endfunction

" make the current word the cursor is over a ref
function! uwiki#ref#create()

	" To do this, we're just using a raw :subs to wrap the word the
	" cursor is over with [[ and ]]. This matches adjacent alphanumeric
	" characters, hyphens, and slashes.
	"
	" :subs moves the cursor to the start of the line, so we restore it
	" afterwards (with an offset for the initial brackets)

	let cursor = getcurpos()
	let cursor[2] += 2

	substitute/[[:alnum:]_/]*\%#[[:alnum:]]\+/[[\0]]/

	call setpos('.', cursor)

endfunction

" make the current selected text a ref
function! uwiki#ref#create_visual()

	" Similar to create_ref

	let cursor = getcurpos()
	let cursor[2] += 2

	substitute/\%V.*\%V/[[\0]]/

	call setpos('.', cursor)
endfunction

" helper for maps
function! uwiki#ref#goto_current()
	let ref = uwiki#ref#get_current()
	if ref != ''
		call uwiki#ref#go_to(ref)
	endif
	return ''
endfunction

function! uwiki#ref#create_or_goto()
	let ref = uwiki#ref#get_current()
	if ref != ''
		call uwiki#ref#go_to(ref)
	else
		call uwiki#ref#create()
	endif
	return ''
endfunction

