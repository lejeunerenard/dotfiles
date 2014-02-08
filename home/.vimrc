set nocompatible

filetype off   " requried!

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

" Let Vundle manage Vundle
"required!
Bundle 'gmarik/vundle'

" My Bundles
"
" Original repos on GitHub
Bundle 'tpope/vim-fugitive'
Bundle 'kien/ctrlp.vim'

filetype plugin indent on     " required!

:set tabstop=3
:set shiftwidth=3
:set expandtab
:syntax on
:set number

:filetype on
:au BufNewFile,BufRead *.tt set filetype=html 

" Fugitive
if has("autocmd")
endif

" Git branch
set statusline=%<%f\ %h%m%r%{fugitive#statusline()}%=%-14.(%l,%c%V%)\ %P
