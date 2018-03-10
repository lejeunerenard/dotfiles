" vim: foldmethod=marker
let s:darwin = has('mac')

if s:darwin
  set backupskip=/tmp/*,$TMPDIR/*,$TMP/*,$TEMP/*,/private/tmp/*
endif

" --- Plugins --- {{{1
call plug#begin('~/.vim/plugged')

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

" Writing
Plug 'junegunn/goyo.vim'

" Version control
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'

" Editing
Plug 'tpope/vim-surround'
Plug 'mattn/emmet-vim'
Plug 'tommcdo/vim-exchange'
Plug 'jiangmiao/auto-pairs'
Plug 'sjl/gundo.vim', { 'on': 'GundoShow'}
Plug 'terryma/vim-multiple-cursors'

" Formatting
Plug 'w0rp/ale'
Plug 'editorconfig/editorconfig-vim'
Plug 'godlygeek/tabular'
Plug 'tomtom/tcomment_vim'
Plug 'AndrewRadev/splitjoin.vim'

" Snippets & completion
Plug 'SirVer/ultisnips', { 'on': [] }
if !has('python')
   Plug 'MarcWeber/vim-addon-mw-utils'
   Plug 'tomtom/tlib_vim'
   Plug 'garbas/vim-snipmate'
endif
" Plug 'honza/vim-snippets', { 'on': [] }
if v:version > 703 || (v:version == 703 && has('patch584'))
  Plug 'Valloric/YouCompleteMe', { 'on': [], 'do': './install.py --tern-completer' }
endif

augroup load_us_ycm
  autocmd!
  autocmd InsertEnter * call plug#load('ultisnips', 'YouCompleteMe')
                     \| autocmd! load_us_ycm
augroup END

" Searching
Plug 'taglist.vim'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'mileszs/ack.vim', { 'on': 'Ack' }
Plug 'tacahiroy/ctrlp-funky'
" These require compilation
if has('python')
   Plug 'JazzCore/ctrlp-cmatcher', { 'do': './install.sh' }
endif

" Language specific
Plug 'dbakker/vim-lint', { 'for': 'vim' }

" Perl
Plug 'vim-perl/vim-perl', { 'for': 'perl' }
Plug 'c9s/perlomni.vim', { 'for': 'perl' }

" JS
Plug 'jelera/vim-javascript-syntax', { 'for': 'javascript' }
Plug 'pangloss/vim-javascript', { 'for': 'javascript' }
Plug 'marijnh/tern_for_vim', { 'do': 'npm install', 'for': 'javascript' }

" GLSL
Plug 'tikhomirov/vim-glsl', { 'for': 'glsl' }

" Markdown
if s:darwin
   Plug 'junegunn/vim-xmark', { 'do': 'make', 'for': 'markdown'  }
endif

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

" Disable preview autocomplete
set completeopt-=preview

" Edit vimrc
nnoremap <leader>ev :vsplit $MYVIMRC<cr>
augroup reload_vimrc
   autocmd!
   autocmd bufwritepost $MYVIMRC nested source $MYVIMRC
augroup END

nnoremap <leader>s I#<esc>

" Window navigation
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

" Shell config
" set shell=bash\ -i

" Modes {{{2
inoremap jk <esc>
inoremap <esc> <nop>

" Searching {{{2
:set hlsearch
:set incsearch


" Color Scheme {{{2
colo seoul256
set background=dark

" Highlighting
" source: http://askubuntu.com/a/514524
set t_ZH=[3m
set t_ZR=[23m

highlight Comment cterm=italic

" --- Plugins Settings --- {{{1

" lightline {{{2
set noshowmode
let g:lightline = {
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ], [ 'fugitive', 'filename' ], ['ctrlpmark'] ],
      \   'right': [ [ 'syntastic', 'lineinfo' ], ['percent'], [ 'fileformat', 'fileencoding', 'filetype' ] ]
      \ },
      \ 'component_function': {
      \   'fugitive': 'LightLineFugitive',
      \   'filename': 'LightLineFilename',
      \   'fileformat': 'LightLineFileformat',
      \   'filetype': 'LightLineFiletype',
      \   'fileencoding': 'LightLineFileencoding',
      \   'mode': 'LightLineMode',
      \   'ctrlpmark': 'CtrlPMark',
      \ },
      \ 'component_expand': {
      \   'syntastic': 'SyntasticStatuslineFlag',
      \ },
      \ 'component_type': {
      \   'syntastic': 'error',
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
  return fname == 'ControlP' ? g:lightline.ctrlp_item :
        \ fname == '__Tagbar__' ? g:lightline.fname :
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
        \ fname == 'ControlP' ? 'CtrlP' :
        \ fname == '__Gundo__' ? 'Gundo' :
        \ fname == '__Gundo_Preview__' ? 'Gundo Preview' :
        \ fname =~ 'NERD_tree' ? 'NERDTree' :
        \ &ft == 'unite' ? 'Unite' :
        \ &ft == 'vimfiler' ? 'VimFiler' :
        \ &ft == 'vimshell' ? 'VimShell' :
        \ winwidth(0) > 60 ? lightline#mode() : ''
endfunction

function! CtrlPMark()
  if expand('%:t') =~ 'ControlP'
    call lightline#link('iR'[g:lightline.ctrlp_regex])
    return lightline#concatenate([g:lightline.ctrlp_prev, g:lightline.ctrlp_item
          \ , g:lightline.ctrlp_next], 0)
  else
    return ''
  endif
endfunction

let g:ctrlp_status_func = {
  \ 'main': 'CtrlPStatusFunc_1',
  \ 'prog': 'CtrlPStatusFunc_2',
  \ }

function! CtrlPStatusFunc_1(focus, byfname, regex, prev, item, next, marked)
  let g:lightline.ctrlp_regex = a:regex
  let g:lightline.ctrlp_prev = a:prev
  let g:lightline.ctrlp_item = a:item
  let g:lightline.ctrlp_next = a:next
  return lightline#statusline(0)
endfunction

function! CtrlPStatusFunc_2(str)
  return lightline#statusline(0)
endfunction

let g:tagbar_status_func = 'TagbarStatusFunc'

function! TagbarStatusFunc(current, sort, fname, ...) abort
    let g:lightline.fname = a:fname
  return lightline#statusline(0)
endfunction

augroup AutoSyntastic
  autocmd!
  autocmd BufWritePost *.c,*.cpp call s:syntastic()
augroup END
function! s:syntastic()
  SyntasticCheck
  call lightline#update()
endfunction

let g:unite_force_overwrite_statusline = 0
let g:vimfiler_force_overwrite_statusline = 0
let g:vimshell_force_overwrite_statusline = 0
" YouCompleteMe {{{2

" Completion tweaks
let g:ycm_filepath_completion_use_working_dir = 1

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
map <C-n> :NERDTreeToggle<CR>
let NERDTreeShowHidden=1

" ctrlp {{{2
let g:ctrlp_show_hidden = 1
let g:ctrlp_extensions = ['tag', 'funky']
if has("python") " Check for support
   let g:ctrlp_match_func = {'match' : 'matcher#cmatch' }
endif
let g:ctrlp_custom_ignore = 'node_modules\|DS_Store\|git\|local'
let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files -co --exclude-standard']
" Fugitive {{{2
" Git branch statusline
set statusline=%<%f\ %h%m%r%{fugitive#statusline()}%=%-14.(%l,%c%V%)\ %P
command! Gd Gdiff

" Peekaboo {{{2
" Delay opening of peekaboo window (in ms. default: 0)
let g:peekaboo_delay = 750
" vim-surround {{{2
nmap cd viW<Tab>dumper<Tab>

" ALE Settings {{{2

let g:ale_lint_delay = 10
let g:ale_sign_column_always = 1

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

let g:ale_linters = {
\   'javascript': ['standard'],
\   'javascript.jsx': ['standard'],
\}
let g:ale_javascript_eslint_executable = 'eslint_d'

function! SetALEJSLinter(linter)
  if a:linter == 'eslint'
    let b:ale_linters = { 'javascript': ['eslint'], 'javascript.jsx': ['eslint'] }
    let g:ale_javascript_eslint_use_global = 1
    let g:ale_javascript_eslint_executable = 'eslint_d'
  elseif a:linter == 'jshint'
    let b:ale_linters = { 'javascript': ['jshint'], 'javascript.jsx': ['jshint'] }
  elseif a:linter == 'standard'
    let b:ale_linters = { 'javascript': ['standard'] }
  endif
endfunction
function! DetermineALEJSLinter()
  call DetectJSLinter('SetALEJSLinter')
endfunction

augroup FiletypeGroup
  autocmd!
  au BufNewFile,BufRead *.js,*.jsx :call DetermineALEJSLinter()
augroup END

" Syntastic Settings {{{2
let g:syntastic_perl_checkers = ['perl']
let g:syntastic_check_on_open = 1
let g:syntastic_enable_perl_checker = 1
let g:syntastic_always_populate_loc_list = 1

" Check which js checker to use
let jsmodules = system("npm ls --depth=0 --parseable 2>/dev/null")
if match(jsmodules, '\/standard\n') + 1
    let g:syntastic_javascript_checkers = ['standard']
elseif match(jsmodules, '\/eslint\n') + 1
    let g:syntastic_javascript_checkers = ['eslint']
    let g:syntastic_javascript_eslint_exec = 'eslint_d'
else
    let g:syntastic_javascript_checkers = ['jshint']
endif

" HTML::Template
let g:syntastic_ignore_files = ['\m\c.tmpl$']

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
let g:multi_cursor_next_key='<C-g>'
let g:multi_cursor_prev_key='<C-p>'
let g:multi_cursor_skip_key='<C-x>'
let g:multi_cursor_quit_key='<Esc>'
" Map start key the same as the next key
let g:multi_cursor_start_key='<C-g>'
" Tabularize {{{2
map <Leader>t :Tabularize /<bar><CR>

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
