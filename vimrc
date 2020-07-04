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
set statusline=%4*
set statusline+=%{b:gitbranch}
set statusline+=%1*
set statusline+=%f
set statusline+=%=
set statusline+=%3*
set statusline+=%m
set statusline+=%r 
set statusline+=%h
set statusline+=%2*
set statusline+=%3c
set statusline+=,
set statusline+=%3l
set statusline+=/
set statusline+=%3L
hi User1 ctermbg=darkblue ctermfg=yellow
hi User2 ctermbg=blue ctermfg=green
hi User3 ctermbg=darkblue ctermfg=magenta
hi User4 ctermbg=darkgreen ctermfg=darkmagenta
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
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --bin' }
Plug 'junegunn/fzf.vim'
Plug 'kuningfellow/ccp'
call plug#end()

" remove trailing whitespace on save
autocmd BufWritePre *.cpp %s/\s\+$//e
autocmd BufWritePre *.java %s/\s\+$//e
autocmd BufWritePre *.py %s/\s\+$//e

" template
autocmd BufNewFile *.cpp execute "silent! 0r ~/.vim/templates/template.cpp"
autocmd BufNewFile *.cpp execute "silent! 0r ~/vimfiles/templates/template.cpp"

