" vim: foldmethod=marker
set nocompatible

filetype off   " required!

" --- Plugins --- {{{1
"set rtp+=~/.vim/bundle/vundle/
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" Let Vundle manage Vundle
"required!
Plugin 'gmarik/Vundle.vim'

" My Plugins
"
" Original repos on GitHub
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-unimpaired'
Plugin 'tpope/vim-repeat'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-abolish'
Plugin 'mattn/emmet-vim'
Plugin 'tommcdo/vim-exchange'
Plugin 'altercation/vim-colors-solarized'
Plugin 'scrooloose/nerdtree'
Plugin 'jiangmiao/auto-pairs'
Plugin 'ervandew/supertab'
Plugin 'nelstrom/vim-qargs'

" Formating
Plugin 'scrooloose/syntastic'
Plugin 'editorconfig/editorconfig-vim'
Plugin 'godlygeek/tabular'

" Snippets
if has("python") " Check for support
   Plugin 'SirVer/ultisnips'
else
   Plugin 'MarcWeber/vim-addon-mw-utils'
   Plugin 'tomtom/tlib_vim'
   Plugin 'garbas/vim-snipmate'
endif
Plugin 'honza/vim-snippets'

" Searching
Plugin 'taglist.vim'
Plugin 'kien/ctrlp.vim'
Plugin 'mileszs/ack.vim'
" These require compilation
Plugin 'JazzCore/ctrlp-cmatcher'
if (v:version >= 703) && has("patch584")
  Plugin 'Valloric/YouCompleteMe'
endif

" Language specific
Plugin 'dbakker/vim-lint'
Plugin 'vim-perl/vim-perl'

" Experimental
Plugin 'benmills/vimux'
Plugin 'suan/vim-instant-markdown'
" Potentially useful in the future
" Plugin 'mattn/webapi-vim'
Plugin 'mattn/gist-vim'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on     " required!

" --- General settings --- {{{1

" Tabs {{{2
:set tabstop=3
:set shiftwidth=3
:set expandtab

" Misc {{{2
syntax on
set number
filetype on
set splitright " Natural vertical splitting
set spell
set foldcolumn=3
set backspace=2
" List characters for hidden characters
set listchars=tab:▸\ ,eol:¬
set list
" Status bar is always on
set laststatus=2

" Shell config
" set shell=bash\ -i

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

" UltiSnips {{{2
" better key bindings for UltiSnipsExpandTrigger
let g:UltiSnipsExpandTrigger = "<tab>"
let g:UltiSnipsJumpForwardTrigger = "<tab>"
let g:UltiSnipsJumpBackwardTrigger = "<s-tab>"
"let g:UltiSnipsSnippetDirectories=["UltiSnips", "snippets"]

" Nerd Tree {{{2
autocmd vimenter * if !argc() | NERDTree | endif
map <C-n> :NERDTreeToggle<CR>
let NERDTreeShowHidden=1

" ctrlp {{{2
let g:ctrlp_show_hidden = 1
let g:ctrlp_extensions = ['tag']
"let g:ctrlp_match_func = {'match' : 'matcher#cmatch' }

" Fugitive {{{2
" Git branch statusline
set statusline=%<%f\ %h%m%r%{fugitive#statusline()}%=%-14.(%l,%c%V%)\ %P

" vim-surround {{{2
nmap cd viW<Tab>dumper<Tab>

" Syntastic Settings {{{2
let g:syntastic_mode_map = { 'mode': 'active',
   \ 'active_filetypes': [],
   \ 'passive_filetypes': [''] }
let g:syntastic_perl_checkers = ['perlcritic', 'perl']
" Takes so freakin long. Ill have to look into what is causing it.
let g:syntastic_check_on_open = 1
let g:syntastic_enable_perl_checker = 1
let g:syntastic_always_populate_loc_list = 1


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

" Markdown plugins {{{2
" Open markdown files with Chrome.
if os == "Darwin"
   autocmd BufEnter *.md exe 'noremap <F5> :!open -a "Google Chrome.app" %:p<CR>'
elseif os == "win"
   autocmd BufEnter *.md exe 'noremap <F5> :!chromium-browser %:p<CR>'
endif

"vim-instant-markdown
let g:instant_markdown_autostart = 0
let g:instant_markdown_slow = 1

" --- Language Settings --- {{{1

" Perl {{{2
" Set manual command to use perldoc for perl files
autocmd FileType perl :noremap K :!perldoc <cword>
   \ <bar><bar> perldoc -f <cword><cr>
" Set perltidy as the default filter
au BufRead,BufNewFile *.pl setl equalprg=perltidy
au BufRead,BufNewFile *.pm setl equalprg=perltidy
au BufRead,BufNewFile *.t setl equalprg=perltidy

