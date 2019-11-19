let g:Python = "3.6"
let g:GCC = "-std=c++11"

" compiling
function CPP(mode)                            " now using KnTL
  let l:ext = ""
  let l:command = "CP"
  if has('win32')
    let l:ext = ".exe"
    let l:command = "kntl"
  endif
  if a:mode==1
    if &mod==1 || !filereadable(expand("%:p:r").l:ext)
      execute "w | silent !".l:command shellescape("%") "R"
    else
      execute "silent !".l:command shellescape("%") "r"
    endif
  elseif a:mode==2
    if &mod==1 || !filereadable(expand("%:p:r").l:ext)
      execute "w | silent !".l:command shellescape("%") "I"
    else
      execute "silent !".l:command shellescape("%") "i"
    endif
  endif
  execute "redraw!"
endfunction
function CP(mode)
  let l:clear = "clear"
  let l:rm = "rm"
  if has('win32')
    " For Windows systems
    let l:clear = "cls"
    let l:rm = "del"
  endif
  if expand('%:e') == "py"                    " Python
    execute "w | silent !" l:clear "&& echo [".shellescape("%:p")."]"
    if a:mode==1
      execute "!python" . g:Python shellescape("%:p")
    elseif a:mode==2
      execute "!python" . g:Python shellescape("%:p") "< IN"
    endif
  elseif expand('%:e') == "java"              " Java
    let l:ext = ".class"
    if &mod==1 || !filereadable(expand("%:p:r").l:ext)
      execute "silent !" l:rm shellescape("%:p:r").l:ext
      execute "w | !" l:clear "&& javac" shellescape("%:p")
    endif
    if filereadable(expand("%:p:r").l:ext)
      execute "silent !" l:clear "&& echo [".shellescape("%")."]"
      if a:mode==1
        execute "!java" shellescape("%:r")
      elseif a:mode==2
        execute "!java" shellescape("%:r") "< IN"
      endif
    endif
  elseif expand('%:e') == "cpp"               " C++
    call CPP(a:mode)
"    let l:ext = ""
"    if has('win32')
"      let l:ext = ".exe"
"    endif
"    if &mod==1 || !filereadable(expand("%:p:r").l:ext)
"      execute "silent !" l:rm shellescape("%:p:r").l:ext
"      execute "w | !" l:clear "&& g++" g:GCC "-o" shellescape("%:p:r") shellescape("%:p")
"    endif
"    if filereadable(expand("%:p:r").l:ext)
"      execute "silent !" l:clear "&& echo [".shellescape("%:p")."]"
"      if a:mode==1
"        execute "!" shellescape("%:p:r")
"      elseif a:mode==2
"        execute "!" shellescape("%:p:r") "< IN"
"      endif
"    endif
  endif
endfunction

" INpage toggling
function IN()
  if shellescape(expand('%'))==#shellescape('IN')
    execute "normal c"
  elseif bufwinnr('./IN') > 0
    execute "normal ".expand(bufwinnr('./IN'))."w"
  else
    silent execute "50vs IN"
  endif
endfunction

" CPing
nnoremap <silent> <F2> :call IN()<CR>
nnoremap <silent> <F3> :execute "silent! normal! :call writefile(getreg('*',1,1),\"IN\")\r"<CR>
nnoremap <silent> <F4> :call CP(2)<CR>
nnoremap <silent> <F5> :call CP(1)<CR>
