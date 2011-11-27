filetype on
call pathogen#helptags()
call pathogen#runtime_append_all_bundles()

set nocompatible
set hidden
set wrap          " wrap lines longer than window width
set wrapmargin=4  " start wrapping 4 char from window border
set tabstop=4     " a tab is four spaces
set shiftwidth=4  " number of spaces to use for autoindenting
set softtabstop=4 
set shiftround    " use multiple of shiftwidth when indenting with '<' and '>
set expandtab     " always expand tabs not spaces
set relativenumber " show relative line number
set backspace=indent,eol,start
                  " allow backspacing over everything in insert mode
set autoindent    " copy indent from current line when starting new line
set copyindent    " copy the structure of te existing lines indent when autoidenting
set ignorecase    " ignore case when searching
set smartcase     " ignore case if search pattern is all lowercase,
                  " case-sensitive otherwise
set smarttab      " nsert tabs on the start of a line according to
                  " shiftwidth, not tabstop
set hlsearch      " highlight search terms
set incsearch     " show search matches as you typeset hidden
set visualbell
set noerrorbells
set nobackup
set noswapfile
set ruler
set textwidth=82  " 82 char columns on inserting text
set colorcolumn=83
set showbreak=...
set cursorline    " highlite current editing line
set ttyfast       " begone slow scrolling
set encoding=utf-8
set history=1000
set dictionary=/usr/share/dict/words
" Set paste on and off with special key
set pastetoggle=§
" Show tabs and end of lines
set list
set listchars=tab:▸\ ,eol:¬,extends:❯,precedes:❮
" Enable mouse
set mouse=a

" Folding
set foldmethod=indent
set foldnestmax=10
set nofoldenable
set foldlevel=1

" syntax highlight stuff filetype on filetype plugin indent on
syntax enable
colorscheme solarized
set background=dark

" comand line
set laststatus=2 "always show the status line
set statusline=%{GitBranch()}
set statusline=[%n]\ %<%.99f\ %h%w%m%r%y\ %{exists('*CapsLockStatusline')?CapsLockStatusline():''}%=%-16(\ %l,%c-%v\%)%P
let mapleader = ","
let g:indent_guides_start_level=2 " set vim indent guides plugin indentention lever
let g:indent_guides_guide_size=1 " set vim indent guides guide size

" don't autocomplete on this files
set wildmenu
set wildignore+=.git,.svn 
set wildignore+=.DS_Store

au FocusLost * :wa  " save all the things when changing windows focus
au VimResized * exe " resize splits when window is resized

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

" Split window and go to it
nnoremap <leader>h <C-w>v<C-w>l
" easy navigation in splits
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

if has('gui_running')
    set guifont=Monaco:h14
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
end
