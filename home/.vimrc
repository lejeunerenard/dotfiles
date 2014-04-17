" vim: foldmethod=marker
set nocompatible

filetype off   " required!

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

" --- Plugins --- {{{1

" Let Vundle manage Vundle
"required!
Bundle 'gmarik/vundle'

" My Bundles
"
" Original repos on GitHub
Bundle 'tpope/vim-fugitive'
Bundle 'tpope/vim-unimpaired'
Bundle 'tpope/vim-repeat'
Bundle 'tpope/vim-surround'
Bundle 'tpope/vim-abolish'
Bundle 'kien/ctrlp.vim'
Bundle 'mattn/emmet-vim'
Bundle 'tommcdo/vim-exchange'
Bundle 'scrooloose/syntastic'
Bundle 'altercation/vim-colors-solarized'
Bundle 'scrooloose/nerdtree'
Bundle 'jiangmiao/auto-pairs'

filetype plugin indent on     " required!

" --- General settings --- {{{1

" Tabs {{{2
:set tabstop=3
:set shiftwidth=3
:set expandtab

" Misc {{{2
:syntax on
:set number
:filetype on
:set splitright " Natural vertical splitting
:set spell
:set foldcolumn=3

" Searching {{{2
:set hlsearch
:set incsearch


" Syntax highlighting for Template Toolkit
:au BufNewFile,BufRead *.tt set filetype=html 

" Detect OS
if has("win16") || has("win32") || has("win64")
   let os = 'win'
else
   let os = substitute(system('uname'), "\n", "", "")
endif

" --- Plugins Settings --- {{{1

" Nerd Tree {{{2
autocmd vimenter * if !argc() | NERDTree | endif
map <C-n> :NERDTreeToggle<CR>

" Fugitive {{{2
" Git branch statusline
set statusline=%<%f\ %h%m%r%{fugitive#statusline()}%=%-14.(%l,%c%V%)\ %P

" Syntastic Settings {{{2
let g:syntastic_mode_map = { 'mode': 'active',
   \ 'active_filetypes': [],
   \ 'passive_filetypes': ['perl'] }
"let g:syntastic_perl_checkers = ['perlcritic']
" Takes so freakin long. Ill have to look into what is causing it.
"let g:syntastic_check_on_open = 1

" Solarized {{{2
if !has('gui_running')
   " Compatibility for Terminal
   let g:solarized_termtrans=1
   if ($TERM == 'xterm') 
      set t_Co=256
   endif

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

" Open markdown files with Chrome. {{{2
if os == "Darwin"
   autocmd BufEnter *.md exe 'noremap <F5> :!open -a "Google Chrome.app" %:p<CR>'
elseif os == "win"
   autocmd BufEnter *.md exe 'noremap <F5> :!chromium-browser %:p<CR>'
endif

" --- Language Settings --- {{{1

" Perl {{{2
" Set manual command to use perldoc for perl files
autocmd FileType perl :noremap K :!perldoc <cword>
   \ <bar><bar> perldoc -f <cword><cr>

