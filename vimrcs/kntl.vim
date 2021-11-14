let s:black="\033[0;30m"
let s:BLACK="\033[1;30m"
let s:red="\033[0;31m"
let s:RED="\033[1;31m"
let s:green="\033[0;32m"
let s:GREEN="\033[1;32m"
let s:yellow="\033[0;33m"
let s:YELLOW="\033[1;33m"
let s:blue="\033[0;34m"
let s:BLUE="\033[1;34m"
let s:magenta="\033[0;35m"
let s:MAGENTA="\033[1;35m"
let s:cyan="\033[0;36m"
let s:CYAN="\033[1;36m"
let s:white="\033[0;37m"
let s:WHITE="\033[1;37m"
let s:reset="\033[0m"

function KNTL_CPP()
	let l:save_view = winsaveview()
	silent! execute "silent %s/^#define DEBUG(\.\.\.).*$/#define DEBUG(...) {printf(\"".s:green."\");__VA_ARGS__ printf(\"".s:reset."\");}/g"
	execute "w"
	execute "w !g++ -std=c++11 -o" shellescape("%:p:r") shellescape("%:p")
	execute "silent %s/^#define DEBUG(\.\.\.).*$/#define DEBUG(\.\.\.)/g"
	execute "silent w"
	call winrestview(l:save_view)
endfunction
function KNTL_GO()
	execute "w !go build" shellescape("%")
endfunction
function KNTL_RUST()
	execute "w !rustc" shellescape("%")
endfunction

function KNTL_BUILD()
  if expand('%:e') == "cpp"
		call KNTL_CPP()
	elseif expand('%:e') == "go"
		call KNTL_GO()
	elseif expand('%:e') == "rs"
		call KNTL_RUST()
	endif
endfunction

function KNTL_RUN(fromIn, ext)
	let l:start_time = reltime()
	if a:fromIn == 1
		execute "silent !".shellescape("%:p:r").a:ext "< IN"
		execute "!echo runtime:" reltimestr(reltime(l:start_time)) "seconds"
	else
		execute "silent !".shellescape("%:p:r").a:ext
		execute "!echo runtime:" reltimestr(reltime(l:start_time)) "seconds"
	endif
endfunction

function KNTL_ADAPTIVE_RUN(fromIn)
  if has('win32')
    let l:ext = ".exe"
		let l:clear = "cls"
  else
    let l:ext = ""
		let l:clear = "clear"
  endif

	if &mod==1 || !filereadable(expand("%:p:r").l:ext)
		execute "silent w"
		"execute "silent !" l:clear "&& echo ".shellescape(s:YELLOW."compiling"." ".s:BLUE."%".s:reset)
		call delete(expand("%:p:r").l:ext)
		call KNTL_BUILD()
	endif

	if filereadable(expand("%:p:r").l:ext)
		execute "silent !" l:clear "&& echo ".shellescape("[".s:BLUE."%".s:reset."]")
		call KNTL_RUN(a:fromIn, l:ext)
	endif
endfunction

" INpage toggling
function KNTL_IN()
  if shellescape(expand('%'))==#shellescape('IN')
    execute "normal c"
  elseif bufwinnr('./IN') > 0
    execute "normal ".expand(bufwinnr('./IN'))."w"
  else
    silent execute "50vs IN"
  endif
endfunction
" paste clipboard to IN file
function KNTL_PASTE()
  execute "silent! call writefile(getreg('*',0,1),\"IN\")"
endfunction

nnoremap <silent> <F2> :call KNTL_IN()<CR>
nnoremap <silent> <F3> :call KNTL_PASTE()<CR>
nnoremap <silent> <F4> :call KNTL_ADAPTIVE_RUN(1)<CR>
nnoremap <silent> <F5> :call KNTL_ADAPTIVE_RUN(0)<CR>

