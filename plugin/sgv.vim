" Vim plugin for srclib (https://srclib.org)
" Last Change: Feb 24 2015
" Maintainer: mmccask2@gmu.edu
" License: 

if exists( "g:sg_vim_loaded" )
	finish
endif
let g:sg_vim_loaded=003

"consider reading from configuration file
let s:supported_languages=["go","python","java","nodejs","ruby"]

if !executable( "src" ) 
	echom "src(https://srclib.org/) is required to use this plugin"
	finish
endif

"close plugin if editing a file not currently supported
"DISABLED FOR TESTING PURPOSES
""if ! Supported_file()
""       finish
""endif       

"This function can be used to get a list of currently supported languages
"so that this plugin only runs when editing supported files
"
"this function currently doesn't work
function SetLangVars()
	let s:src_temp = system( "src toolchain list" )
	let s:src_tool_list = split( s:src_temp )
	unlet s:src_temp
	let l:i = 0
	let l:base_url = "sourcegraph.com/sourcegraph/srclib-"

	while l:i < len(s:src_tool_list)
		let l:j = 0
		while j < len(s:supported_languages)
			if s:src_tool_list[l:i] == l:base_url . s:supported_languges[l:j]
				if(!exists "s:" . s:supported_languages[l:j])
					execute "normal! let " . s:supported_languages[l:j] . " = 1"
				endif
			endif
			let l:j += 1
		endwhile
		let l:i += 1
		unlet l:j
	endwhile

	unlet l:i
	unlet s:src_tool_list
	unlet l:base_url
endfunction

function SG_Keybindings()
	if ! exists( "g:sg_default_keybindings" )
		let g:sg_default_keybindings = 1
	endif
	if g:sg_default_keybindings 
		:noremap ,a :call Sourcegraph_jump_to_definition()<cr>
		:noremap ,o :call Sourcegraph_describe()<cr>
		:noremap ,e :call Sourcegraph_usages()<cr>
		:noremap ,u :call Sourcegraph_search_site()<cr>
	endif	
endfunction

function Disable_SG_Keybindings()
	if ! exists( "g:sg_default_keybindings" )
		let g:sg_default_keybindings = 0
	endif
	unmap ,a
	unmap ,o
	unmap ,e
	unmap ,u
	let g:sg_default_keybindings = 0
endfunction

"function to be called by jump..., describe, and usages
"TODO: find a way for system() to run more smoothly (open a background process
"and run the command there, call a python or perl script, etc.)
function Sourcegraph_call_src( no_examples )
	let l:sg_no_examples = ""
	if a:no_examples
		let l:sg_no_examples = " --no-examples "
	endif
	try
		let l:output = system("src api describe --file " . 
			\expand("%:t") . ' --start-byte ' . 
			\Get_byte_offset() . l:sg_no_examples . " 2>&1")
	catch /^Vim\%((\a\+)\)=:E484/
		"catch fish specific error
		echom "If your default shell is fish, add 'set shell=/bin/bash'
			\to your .vimrc.  Otherwise, please file a bug report 
			\at https://github.com/MarkMcCaskey/sourcegraph-vim"
	endtry
	if l:output ==? "{}\n"
		echom "No results found"
	else
		:silent vsplit .temp_srclib
		normal! ggdG
		"Consider making an output specific color scheme and highlight 
		"the buffer
		setlocal buftype=nofile
		"echom SG_parse_src(l:output)
		call append(0,split(SG_parse_src(l:output),"\n"))
	endif
	unlet l:output
	unlet l:sg_no_examples
endfunction

"TODO: parsing and going to relevant information in newly opened buffer
"Also, consider setting variable or checking if the buffer already exists
"before opening new ones
function Sourcegraph_jump_to_definition()
	:call Sourcegraph_call_src( 1 )
	:echom "sourcegraph_jump_to_definition"
endfunction

function Sourcegraph_describe()
	:call Sourcegraph_call_src( 1 )
	:echom "sourcegraph_describe"
endfunction

function Sourcegraph_usages()
	:call Sourcegraph_call_src( 1 )
	:echom "sourcegraph_usages"
endfunction


"TODO: fix errors when called from inside of TTY/place where browsers cannot
"be opened
"The error appears to be that the error message gets written over Vim, adding
"a redraw! command in this function doesn't seem to fix it, because the text
"appearing is delayed
function Sourcegraph_search_site()
	let l:base_url="https://sourcegraph.com/"
	if( mode() ==? "v" ) 
		"consider updating to command that maintains selected text
		execute "normal! \"ay"
	else "not in visual mode
		"set search_string to word under the cursor
		execute "normal! mqviw\"ay`q"
	endif
	let l:search_string = @a


	"try opening with browser
	"TODO: find better way to open in the background
	let l:url = '"' . l:base_url . "search?q=" . l:search_string . '"'
	if executable( 0 ) "mac OS X and Linux
		"open is a keyword in VimL
		"TODO: find way to call open
		":call system( "open " . l:url . " &" )
	elseif executable( "sensible-browser" ) "debian-based linux
		:silent execute "!sensible-browser"  l:url . " &"
	elseif executable( "xdg-open" ) "linux
		:silent execute "!xdg-open" l:url . " &"
	elseif executable( "firefox" )
		:silent execute "!firefox" l:url
	elseif executable( "chromium-browser" ) . " &"
		:silent execute "!chromium-browser" l:url
	else 
		echom "No browser found, please submit a bug report at https://github.com/MarkMcCaskey/sourcegraph-vim"
	endif
	:redraw!

	unlet l:search_string
	unlet l:base_url
	unlet l:url
endfunction
	
"TODO: add check for support on local machine by calling 'src toolchain list'
function Supported_file()
	if index( s:supported_languages, &filetype ) != -1
		return 1
	endif
	return 0
endfunction

function Get_byte_offset()
	"added viw so that if called on first letter it stays on the same word
	execute "normal! mqviwb"
	let l:retval = line2byte(line("."))+col(".")
	execute "normal! `q"
	return l:retval
endfunction

function SG_parse_src( in )
	let l:tab = "   "
	let l:itab = 0
	let l:ret = ""
	let l:one = split(a:in,'{\zs')
	for c in l:one
		let l:ret = l:ret . "\n" 
		let l:i = 0
		while l:i < l:itab
			let l:ret = l:ret . l:tab
			let l:i = l:i + 1	
		endwhile
		let l:ret = l:ret . c
		let l:itab = l:itab + 1
	endfor
	let l:one = split(l:ret,',\zs')
	let l:ret = ""
	for c in l:one
		let l:ret = l:ret . "\n" 
		let l:i = 0
		while l:i < l:itab
			let l:ret = l:ret . l:tab
			let l:i = l:i + 1	
		endwhile
		let l:ret = l:ret . c
	endfor
	let l:i = 1
	let l:one = split(l:ret,'}')
	let l:ret = l:one[0]
	while l:i < len(l:one)
		let l:tabulator = ""
		let l:j = 2
		while l:j < l:itab
			let l:tabulator = l:tabulator . l:tab
			let l:j = l:j + 1
		endwhile
		let l:itab = l:itab - 1
		let l:ret = l:ret . "\n" . l:tabulator . "}" . l:one[i]
		let l:i = l:i + 1
	endwhile
	unlet l:i
	unlet l:one
	unlet l:itab
	unlet l:tab
	return l:ret
endfunction


"'main': 
:call SG_Keybindings()
