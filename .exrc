"---- window settings ----
set title

set list
set number

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

"---- color settings ----
syntax on

"---- others ----
"TAB settings
set autoindent
set expandtab
set shiftwidth=4
set tabstop=4

set hidden
set showmatch

set backspace=indent,eol,start
set cursorline

set statusline=%{expand('%:p:t')}\ %<[%{expand('%:p:h')}]%=\ %m%r%y%w[%{&fenc!=''?&fenc:&enc}][%{&ff}][%3l,%3c,%3p]
