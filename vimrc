" Extracted from multiple dusty files over the course of eons
" and brought together in the fires of mordor

" We ain't got no time for vi
set nocompatible

call pathogen#infect()
syntax on
filetype plugin indent on

" Powerline solarized theme
let g:Powerline_theme='skwp'
let g:Powerline_colorscheme='skwp'

" Solarized
set background=dark
colorscheme solarized
call togglebg#map("<F5>")

" Do not forces to save changes in bg buffers
set hidden

" Show line numbers
set number

" Current cursor position
set ruler

" Always show the statusline
set laststatus=2

" Make backspace work like other apps
set backspace=2

" Indenting options
set autoindent
set smarttab

" No swap
set noswapfile

" Use spaces not tabs
set expandtab
set tabstop=2

" Number of spaces to use for each step of (auto)indent
set shiftwidth=2

" Show matches as pattern is being typed
set incsearch
set hlsearch

" change leader
let mapleader=","

"status line
set statusline=2

" Give us autocomplete files
set wildmenu
set wildignore+=.git,.svn 
set wildignore+=.DS_Store

" I think this should be on in xterm, but it seems
" to speed up things when tuned explicitly
set ttyfast

" Some other speed improvements, vim on mac seems so
" sllllllow
set lazyredraw
set noshowcmd

" Set paste on and off with special key
set pastetoggle=§

" Line wrapping
set wrap
