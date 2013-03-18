" Extracted from multiple dusty files over the course of eons
" and brought together in the fires of mordor

" We ain't got no time for vi
set nocompatible

call pathogen#infect()
syntax on
filetype plugin indent on

" Ctrlp ignore this
set wildignore+=*/tmp/*,*.so,*.swp,*.zip

" Powerline solarized theme
"let g:Powerline_theme='skwp'
"let g:Powerline_colorscheme='skwp'

" Tagbar configuration
let g:tagbar_width=26                          
nmap <F8> :TagbarToggle<CR>

" Easytags config
set tags=./tags
let g:easytags_dynamic_files=1

" Solarized only in mvim
" i'm in the mood for different 
" terminal colors
"
set background=dark
colorscheme solarized
call togglebg#map("<F5>")

if has("gui_running")
    colorscheme tronlegacy
endif

" We want to see the current line
set cursorline

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

" Show matches as pattern is being typed
set incsearch
set hlsearch

" Always good convetion
set textwidth=80

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
" set ttyfast

" Some other speed improvements, vim on mac seems so
" sllllllow
" set lazyredraw
set noshowcmd

" Set paste on and off with special key
set pastetoggle=§

" Line wrapping
set wrap

" Complete to longest string, like zsh
set wildmode=longest,list:longest

" Restrict search for tab completion sugestions
set complete=.,b,u,]

" default tabsettings
set expandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4

" Python is 4 spaces
au FileType python setlocal expandtab tabstop=4 shiftwidth=4 softtabstop=4
" Ruby is 2 spaces
au Filetype ruby setlocal expandtab tabstop=2 shiftwidth=2 softtabstop=2
" Javascript is 2 spaces
au Filetype javascript  setlocal expandtab tabstop=2 shiftwidth=2 softtabstop=2

if has("gui_running")
	"tab mappings
	map <D-1> 1gt
	map <D-2> 2gt
	map <D-3> 3gt
	map <D-4> 4gt
	map <D-5> 5gt
	map <D-6> 6gt
	map <D-7> 7gt
	map <D-8> 8gt
	map <D-9> 9gt
	map <D-t> :tabnew<CR>
	map <D-t> :tabclose<CR>

	"macvim stuff
	set guioptions-=T
	set guioptions-=r
	set guioptions-=L
	set guifont=Source\ Code\ Pro:h14
    set lines=80 columns=100
endif

" I need to be forced not tu use the arrow keys, this disables them
nnoremap <up> <nop>
nnoremap <down> <nop>
nnoremap <left> <nop>
nnoremap <right> <nop>
inoremap <up> <nop>
inoremap <down> <nop>
inoremap <left> <nop>
inoremap <right> <nop>
nnoremap j gj
nnoremap k gk

" Ack.vim search for current line with <leader>a
noremap <Leader>a :Ack <cword><cr>
