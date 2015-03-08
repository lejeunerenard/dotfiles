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
if v:version > 703 || (v:version == 703 && has('patch584'))
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

" YouCompleteMe {{{2
" make YCM compatible with UltiSnips (using supertab)
let g:ycm_key_list_select_completion = ['<C-n>', '<Down>']
let g:ycm_key_list_previous_completion = ['<C-p>', '<Up>']
let g:SuperTabDefaultCompletionType = '<C-n>'

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
let g:syntastic_javascript_checkers = ['jshint']
" Takes so freakin long. Ill have to look into what is causing it.
"let g:syntastic_aggregate_errors = 1
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

" Syntax
let perl_extended_vars = 1 " EXPERIMENTAL

" from http://www.slideshare.net/c9s/perlhacksonvim (Cornelius++) Slide 176
nmap <C-x><C-i> :call InstallCPANModule()<CR>
function! InstallCPANModule()
    let l = getline('.')
    let cw = substitute( expand('<cWORD>'), ";$", "", "g" )
    let cw = substitute( cw, "['\"]", "", "g" )
    echo "installing module " . cw . "\n"
    exec "!cpanm " . cw
endfunction

" perl: add 'use' statement
" https://github.com/marcelgruenauer/dotfiles/blob/master/src/.vimrc#L548
"
" make sure you have
"   setlocal iskeyword=48-57,_,A-Z,a-z,:
" so colons are recognized as part of a keyword

function! PerlAddUseStatement()
    let s:package = input('Package? ', expand('<cword>'))
    " skip if that use statement already exists
    if (search('^use\s\+'.s:package, 'bnw') == 0)
        " below the last use statement, except for some special cases
        let s:line = search('^use\s\+\(constant\|strict\|warnings\|parent\|base\|5\)\@!','bnw')
        " otherwise, below the ABSTRACT (see Dist::Zilla)
        if (s:line == 0)
            let s:line = search('^# ABSTRACT','bnw')
        endif
        " otherwise, below the package statement
        if (s:line == 0)
            let s:line = search('^package\s\+','bnw')
        endif
        " if there isn't a package statement either, put it below
        " the last use statement, no matter what it is
        if (s:line == 0)
            let s:line = search('^use\s\+','bnw')
        endif
        " if there are no package or use statements, it might be a
        " script; put it below the shebang line
        if (s:line == 0)
            let s:line = search('^#!','bnw')
        endif
        " if s:line still is 0, it just goes at the top
        call append(s:line, 'use ' . s:package . ';')
    endif
endfunction

" EXPERIMENTAL
" source: https://github.com/marcelgruenauer/dotfiles/blob/master/src/.vimrc#L639
function! s:TidyAsDiff()
    let filetype=&ft
    let filename = bufname("%")
    let pos = getpos('.')
    diffthis
    vnew
    execute "r !perltidy " . filename
    normal! 1Gdd
    diffthis
    exe "setlocal bt=nofile bh=wipe nobl noswf ro ft=" . filetype
    " go to original line in original window
    exe "wincmd l"
    call setpos('.', pos)
endfunction
com! TidyDiff call s:TidyAsDiff()
