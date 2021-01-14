"---- window settings ----
set title

set list
set number
set relativenumber

"---- status line ----
set laststatus=2
set showmode
set showcmd
set ruler

"---- encoding ----
set termencoding=utf-8
set encoding=utf-8
set fileformats=unix,dos,mac
set fileencoding=utf-8
set fileencodings=utf-8,shift-jis

"---- others ----
"TAB settings
set autoindent
set smartindent
set expandtab
set shiftwidth=4
set tabstop=4

set hidden
set showmatch

set wildmenu

set backspace=indent,eol,start
set cursorline

" set statusline=%{expand('%:p:t')}\ %<[%{expand('%:p:h')}]%=\ %m%r%y%w[%{&fenc!=''?&fenc:&enc}][%{&ff}][%3l,%3c,%3p]

" ---- search ---
" incremental search
set incsearch
" ignore case
set ignorecase
" case sensitive in pattern
set smartcase
" highlight search result
set hlsearch

" move cursor prev/next line
set whichwrap=b,s,h,l,<,>,[,],~

" change leader : to space
let mapleader = "\<Space>"

" ===== dein.vim ===============================================================
" dein.vim settings {{{
" install dir {{{
let s:dein_dir = expand('~/.cache/dein')
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'
" }}}

" dein installation check {{{
if &runtimepath !~# '/dein.vim'
    if !isdirectory(s:dein_repo_dir)
        execute '!git clone https://github.com/Shougo/dein.vim' s:dein_repo_dir
    endif
    execute 'set runtimepath^=' . s:dein_repo_dir
endif
" }}}

" begin settings {{{
if dein#load_state(s:dein_dir)
    call dein#begin(s:dein_dir)

    " .toml file
    let s:toml = '~/.dein.toml'

    " read toml and cache
    call dein#load_toml(s:toml, {'lazy': 0})

    " end settings
    call dein#end()
    call dein#save_state()
endif
" }}}

" plugin installation check {{{
if dein#check_install()
    call dein#install()
endif
" }}}

" plugin remove check {{{
let s:removed_plugins = dein#check_clean()
if len(s:removed_plugins) > 0
    call map(s:removed_plugins, "delete(v:val, 'rf')")
    call dein#recache_runtimepath()
endif
" }}}


"---- plugin settings ----
" lightline.vim
let g:lightline = {
    \   'colorscheme':  'default',
    \   'component': {
    \       'readonly': '%{&filetype=="help"?"":&readonly?" ":""}',
    \       'modified': '%{&filetype=="help"?"":&modified?" ":&modifiable?"":"-"}',
    \   },
    \   'separator':    { 'left': '', 'right': ' ' },
    \   'subseparator': { 'left': '', 'right': ' ' },
    \ }

" Yggdroot/indentLine
let g:indentLine_char = '¦'

" git gutter
let g:gitgutter_highlight_lines = 0

" NERDTree
map <Leader>n :NERDTreeToggle<CR>
let g:NERDTreeMapUpdir='<C-u>'
let g:NERDTreeShowHidden=1
let g:NERDTreeShowBookmarks=1


let g:WebDevIconsUnicodeDecorateFolderNodes = 1
let g:DevIconsEnableFoldersOpenClose = 1
let g:WebDevIconsUnicodeDecorateFolderNodesDefaultSymbol = ' '
let g:DevIconsDefaultFolderOpenSymbol = ' '
" file-icons
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols = {}
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['html'] = ' '
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['css'] = ' '
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['md'] = ' '
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['txt'] = ' '

"---- color settings ----
syntax on

"---- key remapping ----
" Cancel highlight
nnoremap <Esc><Esc> :nohlsearch<CR>

" visual align
vmap <Enter> <Plug>(EasyAlign)

