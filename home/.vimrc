" vim: foldmethod=marker
let s:darwin = has('mac')

if s:darwin
  set backupskip=/tmp/*,$TMPDIR/*,$TMP/*,$TEMP/*,/private/tmp/*
endif

" --- Plugins --- {{{1
if has('win32')
  call plug#begin('~/vimfiles/plugged')
else
  call plug#begin('~/.vim/plugged')
endif

" General Vim enhancements
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-abolish'
Plug 'junegunn/seoul256.vim'
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'ervandew/supertab'
Plug 'nelstrom/vim-qargs'
Plug 'AndrewRadev/linediff.vim'
Plug 'itchyny/lightline.vim'
Plug 'benmills/vimux', { 'on': [
  \'VimuxRunLastCommand', 'VimuxPromptCommand', 'VimuxSetPane'] }
Plug 'junegunn/vim-peekaboo'

" Version control
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'

" Editing
Plug 'tpope/vim-surround'
Plug 'inkarkat/vim-ReplaceWithRegister'
Plug 'christoomey/vim-titlecase'
Plug 'mattn/emmet-vim'
Plug 'tommcdo/vim-exchange'
Plug 'jiangmiao/auto-pairs'
Plug 'sjl/gundo.vim', { 'on': 'GundoShow'}
Plug 'terryma/vim-multiple-cursors'

" Formatting
let g:ale_completion_enabled = 1
let g:ale_completion_tsserver_autoimport = 1
Plug 'dense-analysis/ale'
Plug 'editorconfig/editorconfig-vim'
Plug 'godlygeek/tabular'
Plug 'tpope/vim-commentary'
Plug 'AndrewRadev/splitjoin.vim'
Plug 'keith/investigate.vim' " Documentation Lookup

" Snippets & completion
Plug 'SirVer/ultisnips', { 'on': [] }
if !has('python3')
   Plug 'MarcWeber/vim-addon-mw-utils'
   Plug 'tomtom/tlib_vim'
   Plug 'garbas/vim-snipmate'
endif
Plug 'honza/vim-snippets', { 'on': [] }
if v:version > 703 || (v:version == 703 && has('patch584'))
  Plug 'Valloric/YouCompleteMe', { 'on': [], 'do': './install.py --tern-completer' }
endif

augroup load_snippet_autocomplete
  autocmd!
  autocmd InsertEnter * call plug#load('ultisnips', 'vim-snippets')
                     \| autocmd! load_snippet_autocomplete
augroup END

" Searching
Plug 'vim-scripts/taglist.vim'
Plug 'mileszs/ack.vim', { 'on': 'Ack' }
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --no-bash' }
Plug 'junegunn/fzf.vim'
Plug 'pbogut/fzf-mru.vim'

" Writing
Plug 'junegunn/goyo.vim'
Plug 'vimwiki/vimwiki', { 'for': 'markdown' }
Plug 'michal-h21/vim-zettel'

" Language specific
" Vimscript
Plug 'dbakker/vim-lint', { 'for': 'vim' }

" Perl
Plug 'vim-perl/vim-perl', { 'for': 'perl' }
Plug 'c9s/perlomni.vim', { 'for': 'perl' }

" JS
Plug 'jelera/vim-javascript-syntax', { 'for': 'javascript' }
Plug 'pangloss/vim-javascript', { 'for': 'javascript' }
Plug 'marijnh/tern_for_vim', { 'do': 'npm install', 'for': 'javascript' }

" TypeScript
Plug 'leafgarland/typescript-vim'

" GLSL
Plug 'tikhomirov/vim-glsl', { 'for': 'glsl' }

"LISP / Clojure
Plug 'guns/vim-sexp', { 'for': ['clojure', 'clojurescript'] }
Plug 'liquidz/vim-iced', { 'for': ['clojure', 'clojurescript'] }

" Markdown
if s:darwin
   Plug 'junegunn/vim-xmark', { 'do': 'make', 'for': 'markdown'  }
endif
Plug 'plasticboy/vim-markdown', { 'for': 'markdown'  }

" Elixir
Plug 'elixir-editors/vim-elixir'

" All of your Plugins must be added before the following line
call plug#end()

" --- General settings --- {{{1

" Tabs {{{2
:set tabstop=2
:set shiftwidth=2
:set expandtab

" Text Objects {{{2
" Next and Last {{{
" https://bitbucket.org/sjl/dotfiles/src/954e9528873269d653f4b41382d88c47ce461e72/vim/vimrc?at=default#cl-1823
"
" Motion for "next/last object".  "Last" here means "previous", not "final".
" Unfortunately the "p" motion was already taken for paragraphs.
"
" Next acts on the next object of the given type, last acts on the previous
" object of the given type.  These don't necessarily have to be in the current
" line.
"
" Currently works for (, [, {, and their shortcuts b, r, B.
"
" Next kind of works for ' and " as long as there are no escaped versions of
" them in the string (TODO: fix that).  Last is currently broken for quotes
" (TODO: fix that).
"
" Some examples (C marks cursor positions, V means visually selected):
"
" din'  -> delete in next single quotes                foo = bar('spam')
"                                                      C
"                                                      foo = bar('')
"                                                                C
"
" canb  -> change around next parens                   foo = bar('spam')
"                                                      C
"                                                      foo = bar
"                                                               C
"
" vin"  -> select inside next double quotes            print "hello ", name
"                                                       C
"                                                      print "hello ", name
"                                                             VVVVVV

onoremap an :<c-u>call <SID>NextTextObject('a', '/')<cr>
xnoremap an :<c-u>call <SID>NextTextObject('a', '/')<cr>
onoremap in :<c-u>call <SID>NextTextObject('i', '/')<cr>
xnoremap in :<c-u>call <SID>NextTextObject('i', '/')<cr>

onoremap al :<c-u>call <SID>NextTextObject('a', '?')<cr>
xnoremap al :<c-u>call <SID>NextTextObject('a', '?')<cr>
onoremap il :<c-u>call <SID>NextTextObject('i', '?')<cr>
xnoremap il :<c-u>call <SID>NextTextObject('i', '?')<cr>


function! s:NextTextObject(motion, dir)
    let c = nr2char(getchar())
    let d = ''

    if c ==# "b" || c ==# "(" || c ==# ")"
        let c = "("
    elseif c ==# "B" || c ==# "{" || c ==# "}"
        let c = "{"
    elseif c ==# "r" || c ==# "[" || c ==# "]"
        let c = "["
    elseif c ==# "'"
        let c = "'"
    elseif c ==# '"'
        let c = '"'
    else
        return
    endif

    " Find the next opening-whatever.
    execute "normal! " . a:dir . c . "\<cr>"

    if a:motion ==# 'a'
        " If we're doing an 'around' method, we just need to select around it
        " and we can bail out to Vim.
        execute "normal! va" . c
    else
        " Otherwise we're looking at an 'inside' motion.  Unfortunately these
        " get tricky when you're dealing with an empty set of delimiters because
        " Vim does the wrong thing when you say vi(.

        let open = ''
        let close = ''

        if c ==# "("
            let open = "("
            let close = ")"
        elseif c ==# "{"
            let open = "{"
            let close = "}"
        elseif c ==# "["
            let open = "\\["
            let close = "\\]"
        elseif c ==# "'"
            let open = "'"
            let close = "'"
        elseif c ==# '"'
            let open = '"'
            let close = '"'
        endif

        " We'll start at the current delimiter.
        let start_pos = getpos('.')
        let start_l = start_pos[1]
        let start_c = start_pos[2]

        " Then we'll find it's matching end delimiter.
        if c ==# "'" || c ==# '"'
            " searchpairpos() doesn't work for quotes, because fuck me.
            let end_pos = searchpos(open)
        else
            let end_pos = searchpairpos(open, '', close)
        endif

        let end_l = end_pos[0]
        let end_c = end_pos[1]

        call setpos('.', start_pos)

        if start_l == end_l && start_c == (end_c - 1)
            " We're in an empty set of delimiters.  We'll append an "x"
            " character and select that so most Vim commands will do something
            " sane.  v is gonna be weird, and so is y.  Oh well.
            execute "normal! ax\<esc>\<left>"
            execute "normal! vi" . c
        elseif start_l == end_l && start_c == (end_c - 2)
            " We're on a set of delimiters that contain a single, non-newline
            " character.  We can just select that and we're done.
            execute "normal! vi" . c
        else
            " Otherwise these delimiters contain something.  But we're still not
            " sure Vim's gonna work, because if they contain nothing but
            " newlines Vim still does the wrong thing.  So we'll manually select
            " the guts ourselves.
            let whichwrap = &whichwrap
            set whichwrap+=h,l

            execute "normal! va" . c . "hol"

            let &whichwrap = whichwrap
        endif
    endif
endfunction

" }}}

" Misc {{{2
syntax on
set number
set relativenumber
set cursorline cursorcolumn
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
" Show count next to VISUAL
set showcmd

" Set Leader
let mapleader = " "

" Disable preview autocomplete
set completeopt=menu,menuone,noselect,noinsert
if !has('nvim')
  set completeopt+=popup
endif

" Edit vimrc
nnoremap <leader>ev :vsplit $MYVIMRC<cr>
augroup reload_vimrc
   autocmd!
   autocmd bufwritepost $MYVIMRC nested source $MYVIMRC
augroup END

" Window navigation
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

" Common action mappings Mappings
nnoremap <leader>q :q<CR>
nnoremap <leader>qq :q!<CR>
nnoremap <leader>qa :qa!<CR>
nnoremap <leader>w :w<CR>
nnoremap <leader>x :x<CR>
" Git specific commands
nnoremap <leader>gd :Gd<CR>
nnoremap <leader>gs :Git<CR>

" Shell config
" set shell=bash\ -i

" Modes {{{2
" TODO test for colemak first before setting `fp` vs `jk`. Also figureout how
" to then set all instances of this mapping correctly throughout setup.
" inoremap jk <esc>
let g:esc_mapping = 'fp'
execute ':inoremap ' . g:esc_mapping . ' <esc>'
inoremap <esc> <nop>

" Searching {{{2
:set hlsearch
:set incsearch

" File Searching
" Use ag for faster searching if available
if executable('ag')
  let g:ackprg = 'ag --vimgrep'
endif

" Color Scheme {{{2
colo seoul256
set background=dark

" Highlighting
" source: http://askubuntu.com/a/514524
set t_ZH=[3m
set t_ZR=[23m

highlight Comment cterm=italic

" Spelling & Abbreviations {{{2
iab managment management
" See after/plugin/abolish.vim for more

" --- Plugins Settings --- {{{1

" lightline {{{2
set noshowmode
let g:lightline = {
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ], [ 'fugitive', 'filename' ] ],
      \   'right': [ [ 'lineinfo' ], ['percent'], [ 'fileformat', 'fileencoding', 'filetype' ] ]
      \ },
      \ 'component_function': {
      \   'fugitive': 'LightLineFugitive',
      \   'filename': 'LightLineFilename',
      \   'fileformat': 'LightLineFileformat',
      \   'filetype': 'LightLineFiletype',
      \   'fileencoding': 'LightLineFileencoding',
      \   'mode': 'LightLineMode',
      \ },
      \ 'subseparator': { 'left': '|', 'right': '|' }
      \ }

function! LightLineModified()
  return &ft =~ 'help' ? '' : &modified ? '+' : &modifiable ? '' : '-'
endfunction

function! LightLineReadonly()
  return &ft !~? 'help' && &readonly ? 'RO' : ''
endfunction

function! LightLineFilename()
  let fname = expand('%:t')
  return fname == '__Tagbar__' ? g:lightline.fname :
        \ fname =~ '__Gundo\|NERD_tree' ? '' :
        \ &ft == 'vimfiler' ? vimfiler#get_status_string() :
        \ &ft == 'unite' ? unite#get_status_string() :
        \ &ft == 'vimshell' ? vimshell#get_status_string() :
        \ ('' != LightLineReadonly() ? LightLineReadonly() . ' ' : '') .
        \ ('' != fname ? fname : '[No Name]') .
        \ ('' != LightLineModified() ? ' ' . LightLineModified() : '')
endfunction

function! LightLineFugitive()
  try
    if expand('%:t') !~? 'Tagbar\|Gundo\|NERD' && &ft !~? 'vimfiler' && exists('*fugitive#head')
      let mark = ''  " edit here for cool mark
      let _ = fugitive#head()
      return strlen(_) ? mark._ : ''
    endif
  catch
  endtry
  return ''
endfunction

function! LightLineFileformat()
  return winwidth(0) > 70 ? &fileformat : ''
endfunction

function! LightLineFiletype()
  return winwidth(0) > 70 ? (strlen(&filetype) ? &filetype : 'no ft') : ''
endfunction

function! LightLineFileencoding()
  return winwidth(0) > 70 ? (strlen(&fenc) ? &fenc : &enc) : ''
endfunction

function! LightLineMode()
  let fname = expand('%:t')
  return fname == '__Tagbar__' ? 'Tagbar' :
        \ fname == '__Gundo__' ? 'Gundo' :
        \ fname == '__Gundo_Preview__' ? 'Gundo Preview' :
        \ fname =~ 'NERD_tree' ? 'NERDTree' :
        \ &ft == 'unite' ? 'Unite' :
        \ &ft == 'vimfiler' ? 'VimFiler' :
        \ &ft == 'vimshell' ? 'VimShell' :
        \ winwidth(0) > 60 ? lightline#mode() : ''
endfunction

let g:tagbar_status_func = 'TagbarStatusFunc'

function! TagbarStatusFunc(current, sort, fname, ...) abort
    let g:lightline.fname = a:fname
  return lightline#statusline(0)
endfunction

let g:unite_force_overwrite_statusline = 0
let g:vimfiler_force_overwrite_statusline = 0
let g:vimshell_force_overwrite_statusline = 0

" UltiSnips {{{2
" better key bindings for UltiSnipsExpandTrigger
let g:UltiSnipsExpandTrigger = "<tab>"
let g:UltiSnipsJumpForwardTrigger = "<tab>"
let g:UltiSnipsJumpBackwardTrigger = "<s-tab>"

" Honza : Vim Snippets {{{2
let g:ultisnips_javascript = {
      \ 'semi': 'never',
      \ 'space-before-function-paren': 'always',
      \}

" Nerd Tree {{{2
map <C-n> :NERDTreeToggle<CR>
let NERDTreeShowHidden=1


" FZF {{{2
" Recreate Ctrlp mapping
nnoremap <silent> <c-p> :MGFiles<CR>
command! -bang -nargs=? -complete=dir MGFiles
    \ call Maybe_git_files(<q-args>, <bang>0)
" Stolen from fzf.vim
function! s:get_git_root()
  let root = split(system('git rev-parse --show-toplevel'), '\n')[0]
  return v:shell_error ? '' : root
endfunction

" Custom command for using gitfiles if available
function! Maybe_git_files(args, fullscreen)
  let root = s:get_git_root()
  if empty(root)
    call fzf#vim#files(a:args, fzf#vim#with_preview(), a:fullscreen)
  else
    call fzf#vim#gitfiles(a:args, fzf#vim#with_preview(), a:fullscreen)
  endif
endfunction

if executable('ag')
" Search using Ag & FZF
  function! AgFzf(query, fullscreen)
    let stringTYPE = type('')
    if type(a:query) != stringTYPE
      return s:warn('Invalid query argument')
    endif
    let query = empty(a:query) ? '^(?=.)' : a:query
    let args = copy(a:000)
    let ag_opts = len(args) > 1 && type(args[0]) == stringTYPE ? remove(args, 0) : ''"{{{
    let command = ag_opts . ' ' . fzf#shellescape(query)"}}}

    let command_fmt = 'ag --nogroup --column --color %s'
    let initial_command = printf(command_fmt, shellescape(command))
    let reload_command = printf(command_fmt, '{q}')
    echom "command"command
    let spec = {'options': ['--phony', '--query', command, '--bind', 'change:reload:'.reload_command]}
    call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
  endfunction

  nnoremap <silent> <leader>s :AG<CR>
  command! -bang -nargs=* AG
      \ call AgFzf(<q-args>, <bang>0)
endif

if executable('rg')
  function! RipgrepFzf(query, fullscreen)
    let command_fmt = 'rg --column --line-number --no-heading --color=always --smart-case -- %s || true'
    let initial_command = printf(command_fmt, shellescape(a:query))
    let reload_command = printf(command_fmt, '{q}')
    let spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
    call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
  endfunction

  command! -nargs=* -bang RG call RipgrepFzf(<q-args>, <bang>0)
endif

" Fugitive {{{2
" Git branch statusline
set statusline=%<%f\ %h%m%r%{fugitive#statusline()}%=%-14.(%l,%c%V%)\ %P
command! Gd Gdiff

" GitGutter {{{2
if has('nvim')
  let g:gitgutter_highlight_linenrs = 1
  highlight link GitGutterAddLineNr DiffAdd
endif

" Peekaboo {{{2
" Delay opening of peekaboo window (in ms. default: 0)
let g:peekaboo_delay = 750
" vim-surround {{{2
nmap cd viW<Tab>dumper<Tab>

" ALE Settings {{{2

let g:ale_lint_delay = 10
let g:ale_sign_column_always = 1
let g:ale_fix_on_save = 1

map gd :ALEGoToDefinition<CR>
map gfr :ALEFindReferences<CR>

" Autocompletion
let g:ale_completion_autoimport = 1
set omnifunc=ale#completion#OmniFunc

function! DetectJSLinter(cb)
  let Callback = function(a:cb)
  if v:version < 800
    let detectedJSLinter = DetectJSLinterSync()
    return Callback(detectedJSLinter)
  else
    call DetectJSLinterAsync(Callback)
  endif
endfunction

function! DetectJSLinterAsyncCB(channel, msg)
  " Get STDOUT
  let linter = a:msg
  call g:Js_lint_async(linter)
endfunction

function! DetectJSLinterAsync(cb)
  let g:Js_lint_async = a:cb
  call job_start(['node', $HOME . '/bin/detect-js-linter.js'], {'out_cb': 'DetectJSLinterAsyncCB'})
endfunction
function! DetectJSLinterSync()
  let jsmodules = system("node " . $HOME . "/bin/detect-js-linter.js")
  return jsmodules
endfunction

let g:ale_fixers = {
\   'javascript': ['eslint']
\}
" let g:ale_javascript_eslint_executable = 'eslint_d'

function! SetALEJSLinter(linter)
  if a:linter == 'eslint'
    let b:ale_linters = { 'javascript': ['eslint'], 'javascript.jsx': ['eslint'] }
    " let g:ale_javascript_eslint_use_global = 1
    " let g:ale_javascript_eslint_executable = 'eslint_d'
  elseif a:linter == 'jshint'
    let b:ale_linters = { 'javascript': ['jshint'], 'javascript.jsx': ['jshint'] }
  elseif a:linter == 'standard'
    let b:ale_linters = { 'javascript': ['standard'] }
  endif
endfunction
function! DetermineALEJSLinter()
  call DetectJSLinter('SetALEJSLinter')
endfunction

" augroup FiletypeGroup
"   autocmd!
"   au BufNewFile,BufRead *.js,*.jsx :call DetermineALEJSLinter()
" augroup END

highlight ALEStyleWarning ctermfg=Black
highlight ALEStyleWarning ctermbg=Yellow
highlight ALEWarning ctermfg=Black
highlight ALEWarning ctermbg=Yellow
highlight ALEStyleError ctermfg=Black
highlight ALEStyleError ctermbg=Red
highlight ALEError ctermfg=Black
highlight ALEError ctermbg=Red

" Markdown plugins {{{2
" Open markdown files with Chrome.
if s:darwin
   autocmd BufEnter *.md exe 'noremap <F5> :!open -a "Google Chrome.app" %:p<CR>'
elseif has('win32')
   autocmd BufEnter *.md exe 'noremap <F5> :!chromium-browser %:p<CR>'
endif

"vim-instant-markdown
let g:instant_markdown_autostart = 0
let g:instant_markdown_slow = 1

"vim-markdown
let g:vim_markdown_folding_disabled = 1
let g:vim_markdown_strikethrough = 1
let g:vim_markdown_new_list_item_indent = 0
let g:vim_markdown_fenced_languages = ['c++=cpp', 'viml=vim', 'bash=sh', 'ini=dosini', 'js=javascript']

augroup markdownSettings
   autocmd!
   autocmd FileType markdown setl tw=80
   autocmd FileType markdown setl conceallevel=2
augroup END

" Vimux {{{2
let g:VimuxOrientation = "v"
map <Leader>vl :VimuxRunLastCommand<CR>
map <Leader>vp :VimuxPromptCommand<CR>
map <Leader>vi :VimuxInspectRunner<CR>
map <Leader>vq :VimuxInterruptRunner<CR>
map <Leader>vz :VimuxZoomRunner<CR>
map <Leader>vs :call VimuxSetPane()<CR>
function! VimuxSetPane()
   "g:VimuxRunnerIndex
   let displayExitCode = system("tmux display-panes")
   let g:VimuxRunnerIndex = nr2char(getchar())
endfunction
function! VimuxCreateNewPane()
  " Creates new Tmux pane
  let splitExitCode = system("tmux split-window")
  " Set the proper index
  let g:VimuxRunnerIndex = _VimuxTmuxIndex()
  call _VimuxTmux("last-"._VimuxRunnerType())
endfunction

" vim-multiple-cursors {{{2
let g:multi_cursor_use_default_mapping=0
" New Mappings
let g:multi_cursor_next_key = '<C-g>'
let g:multi_cursor_prev_key = '<C-p>'
let g:multi_cursor_skip_key = '<C-x>'
let g:multi_cursor_quit_key = g:esc_mapping
" Map start key the same as the next key
let g:multi_cursor_start_key = '<C-g>'
let g:multi_cursor_exit_from_visual_mode = 1
let g:multi_cursor_exit_from_insert_mode = 1

" Fix conflict between YCM & vim-multiple-cursors
func! Multiple_cursors_before()
  if exists("g:ycm_auto_trigger") && g:ycm_auto_trigger
    let g:ycm_is_enable_before_multi_cursors = 1
    let g:ycm_auto_trigger = 0
  else
    let g:ycm_is_enable_before_multi_cursors = 0
  endif
  execute ':iunmap ' . g:esc_mapping
endfunction

func! Multiple_cursors_after()
  if g:ycm_is_enable_before_multi_cursors
    let g:ycm_auto_trigger = 1
  else
    let g:ycm_auto_trigger = 0
  endif
  execute ':inoremap ' . g:esc_mapping . ' <esc>'
endfunction

" Tabularize {{{2
map <Leader>t :Tabularize /<bar><CR>

" Titlecase {{{2
let g:titlecase_map_keys = 0

" VimWiki {{{2
let g:vimwiki_list = [{'path': '~/knowledge-base/', 'syntax': 'markdown', 'ext': '.md'}]
let g:vimwiki_key_mappings = {
\  'global': 0
\}

" --- Language Settings --- {{{1

" Perl {{{2
" Set manual command to use perldoc for perl files
autocmd FileType perl :noremap K :!perldoc <cword>
   \ <bar><bar> perldoc -f <cword><cr>

" Library directories
if isdirectory("./lib")
   autocmd FileType perl :let $PERL5LIB .= ':./lib'
endif
if isdirectory("./local/lib/perl5")
   autocmd FileType perl :let $PERL5LIB .= ':./local/lib/perl5'
endif

" Set perltidy as the default filter
augroup perltidy
   autocmd!
   autocmd BufRead,BufNewFile *.pl setl equalprg=perltidy
   autocmd BufRead,BufNewFile *.pm setl equalprg=perltidy
   autocmd BufRead,BufNewFile *.t setl equalprg=perltidy
augroup END

augroup perl_templates
   autocmd!
   " Set HTML::Template
   autocmd BufRead,BufNewFile *.tmpl set filetype=html
   " Syntax highlighting for Template Toolkit
   autocmd BufNewFile,BufRead *.tt set filetype=html
augroup END

" Perl tests via vimux
autocmd BufWritePost *.t :call RunPerlProveSingleFile()

map <Leader>vt :VimuxRunCommand("clear; prove -lvr " . bufname("%"))<CR>

" Syntax
let perl_extended_vars = 1 " EXPERIMENTAL
let g:enable_prove_on_save = 1

" Perl Tests
function! RunPerlProveSingleFile()
   if ( &ft=='perl' && g:enable_prove_on_save )
      if exists("g:VimuxRunnerIndex")
         VimuxRunCommand("prove -lvr " . bufname("%"))
      endif
   endif
endfunction

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

" PHP {{{2
" WordPress specific
fu! SearchWPAck(searchString)
  exec "Ack --php " . a:searchString . " 'wp-content/plugins' 'wp-content/themes'"
endf

command! -nargs=1 WpAck call SearchWPAck(<f-args>)

" GLSL {{{2
" Daily helpers
augroup dailyHelpers
   autocmd!
   autocmd FileType glsl nnoremap <leader>m gg\|/map\s*(\s*in<cr> zz \| :noh<cr>
   autocmd FileType glsl nnoremap <leader>c gg\|/baseColor\s*(\s*in<cr> zz \| :noh<cr>
   autocmd FileType glsl nnoremap <leader>d gg\|/dispersionStep1(<cr> zz \| :noh<cr>
augroup END

autocmd FileType glsl setlocal commentstring=//\ %s

" Clojure {{{2
" Iced {{{3
let g:iced_enable_default_key_mappings = v:true
