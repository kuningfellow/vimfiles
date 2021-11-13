"cpp
autocmd BufWritePre *.cpp %s/\s\+$//e
autocmd BufNewFile *.cpp execute "silent! 0r ~/.vim/templates/template.cpp"
