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

function CCPCPP()
	let l:save_view = winsaveview()
	silent! execute "silent %s/^#define DEBUG(\.\.\.).*$/#define DEBUG(...) {printf(\"".s:green."\");__VA_ARGS__ printf(\"".s:reset."\");}/g"
	execute "w !g++ -std=c++11 -o" shellescape("%:p:r") shellescape("%:p")
	execute "silent %s/^#define DEBUG(\.\.\.).*$/#define DEBUG(\.\.\.)/g"
	execute "silent w"
	call winrestview(l:save_view)
endfunction

function CCPGO()
	execute "w !go build" shellescape("%")
endfunction

function CCPBUILD()
  if expand('%:e') == "cpp"
		call CCPCPP()
	elseif expand('%:e') == "go"
		call CCPGO()
	endif
endfunction

function CCPRUN(fromIn, ext)
	let l:start_time = reltime()
	if a:fromIn == 1
		execute "silent !".shellescape("%:p:r").a:ext "< IN"
		execute "!echo runtime:" reltimestr(reltime(l:start_time)) "seconds"
	else
		execute "silent !".shellescape("%:p:r").a:ext
		execute "!echo runtime:" reltimestr(reltime(l:start_time)) "seconds"
	endif
endfunction

function CCPADAPTIVERUN(fromIn)
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
		call CCPBUILD()
	endif

	if filereadable(expand("%:p:r").l:ext)
		execute "silent !" l:clear "&& echo ".shellescape("[".s:BLUE."%".s:reset."]")
		call CCPRUN(a:fromIn, l:ext)
	endif
endfunction

" INpage toggling
function CCPIN()
  if shellescape(expand('%'))==#shellescape('IN')
    execute "normal c"
  elseif bufwinnr('./IN') > 0
    execute "normal ".expand(bufwinnr('./IN'))."w"
  else
    silent execute "50vs IN"
  endif
endfunction
" paste clipboard to IN file
function CCPPASTE()
  execute "silent! call writefile(getreg('*',0,1),\"IN\")"
endfunction

nnoremap <silent> <F2> :call CCPIN()<CR>
nnoremap <silent> <F3> :call CCPPASTE()<CR>
nnoremap <silent> <F4> :call CCPADAPTIVERUN(1)<CR>
nnoremap <silent> <F5> :call CCPADAPTIVERUN(0)<CR>

