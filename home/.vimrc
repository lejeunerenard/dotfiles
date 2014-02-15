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
Bundle 'mattn/emmet-vim'
Bundle 'scrooloose/syntastic'
Bundle 'altercation/vim-colors-solarized'

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

" Syntastic Settings
let g:syntastic_mode_map = { 'mode': 'active',
   \ 'active_filetypes': [],
   \ 'passive_filetypes': [] }
" Takes so freakin long. Ill have to look into what is causing it.
"let g:syntastic_check_on_open = 1

" Solarized
if !has('gui_running')
   " Compatibility for Terminal
   let g:solarized_termtrans=1

   if (&t_Co >= 256 || $TERM == 'xterm-256color')
      " Do nothing, it handles itself.
      let g:solarized_termcolors=256
   else
      "Make Solarized use 16 colors for Terminal support
      let g:solarized_termcolors=16
   endif
endif
set background=dark
colorscheme solarized
