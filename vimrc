set number
set backspace=2
syntax enable

" indent n stuff
set autoindent
set smartindent
set shiftwidth=0
set tabstop=2
set softtabstop=2
set expandtab

" search stuff
set incsearch
set hls
set wrapscan
nnoremap / :execute "silent! normal! :let @/=\"\"\r"<CR>/
nnoremap ? :execute "silent! normal! :let @/=\"\"\r"<CR>?
vnoremap / <ESC>:execute "silent! normal! :let @/=\"\"\r"<CR>/\%V
vnoremap ? <ESC>:execute "silent! normal! :let @/=\"\"\r"<CR>?\%V

" statusline
set laststatus=2
set statusline=%1*
set statusline+=%f
set statusline+=%=
set statusline+=%3*
set statusline+=%m
set statusline+=%r
set statusline+=%h
set statusline+=%4*
set statusline+=%{b:gitbranch}
set statusline+=%2*
set statusline+=%3c
set statusline+=,
set statusline+=%3l
set statusline+=/
set statusline+=%3L
hi User1 ctermbg=white ctermfg=darkmagenta
hi User2 ctermbg=darkgreen ctermfg=cyan
hi User3 ctermbg=lightgray ctermfg=green
hi User4 ctermbg=blue ctermfg=darkcyan
function! StatuslineGitBranch()
  let b:gitbranch=""
  if &modifiable
    try
      let l:dir=expand('%:p:h')
      let l:gitrevparse = system("git -C ".l:dir." rev-parse --abbrev-ref HEAD")
      if !v:shell_error
        let b:gitbranch="(".substitute(l:gitrevparse, "\n", "", "g").")"
      endif
    catch
    endtry
  endif
endfunction
augroup GetGitBranch
  autocmd!
  autocmd VimEnter,WinEnter,BufEnter * call StatuslineGitBranch()
augroup END

" plugins
call plug#begin()
Plug 'terryma/vim-multiple-cursors'
Plug 'scrooloose/nerdtree'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
call plug#end()

" compiling
function CP(mode)
  if expand('%:e') != "cpp"
    echo "ERROR: not a .cpp file"
  else
    let l:stat = 1
    let l:ext = ""
    let l:clear = "clear"
    let l:rm = "rm"
    if has('win32')
      let l:ext = ".exe"
      let l:clear = "cls"
      let l:rm = "del"
    endif
    if &mod==1 || !filereadable(expand("%:p:r").l:ext)
      execute "silent !" l:rm shellescape("%:p:r")
      execute "w | !" l:clear "&& g++ -std=c++11 -o" shellescape("%:p:r") shellescape("%:p")
      let l:stat = !v:shell_error
    endif
    if l:stat==1
      execute "silent !" l:clear "&& echo [".shellescape("%:p")."]"
      if a:mode==1
        execute "!" shellescape("%:p:r")
      elseif a:mode==2
        execute "!" shellescape("%:p:r") "< IN"
      endif
    endif
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

" remove trailing whitespace on save
autocmd BufWritePre *.cpp %s/\s\+$//e

" template
autocmd BufNewFile *.cpp execute "silent! 0r ~/vimfiles/templates/template.cpp"

