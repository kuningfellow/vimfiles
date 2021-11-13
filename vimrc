filetype plugin indent on
syntax on

"quality of life settings
set tabstop=2
set shiftwidth=2
set hls
set incsearch
set number
set relativenumber
nnoremap <silent> <Leader>/ :let @/=""<CR>
nmap <Leader>e :NERDTreeToggle<CR>
set mouse=a

"performance settings
set maxmempattern=20000

"airline
let g:airline_powerline_fonts = 0
let g:airline#extensions#tabline#enabled = 1

call plug#begin('~/.vim/plugged')
Plug 'ctrlpvim/ctrlp.vim'

Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
call plug#end()

"git clone https://github.com/scrooloose/nerdtree.git ~/.vim/pack/dist/start/nerdtree
"git clone https://github.com/tpope/vim-fugitive.git ~/.vim/pack/dist/start/vim-fugitive
"git clone https://github.com/vim-airline/vim-airline ~/.vim/pack/dist/start/vim-airline
"# clone
"git clone https://github.com/powerline/fonts.git --depth=1
"# install
"cd fonts
"./install.sh
"# clean-up a bit
"cd ..
"rm -rf fonts

source <sfile>:h/vimrcs/cpp.vim
source <sfile>:h/vimrcs/go.vim
source <sfile>:h/vimrcs/coc.vim
source <sfile>:h/vimrcs/cp.vim
