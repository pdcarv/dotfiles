" Modern vim setup - no vi compatibility
set nocompatible

" Plugin Management with vim-plug
call plug#begin('~/.vim/plugged')

" Core functionality improvements
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'         " Easy quotes/brackets manipulation
Plug 'neoclide/coc.nvim', {'branch': 'release'}  " Completion and LSP support
Plug 'machakann/vim-highlightedyank'  " Highlight yanked text
Plug 'mhinz/vim-startify'            " Better start screen
Plug 'preservim/tagbar'              " Code structure viewer

" Language support and syntax
Plug 'fatih/vim-go'
Plug 'vim-ruby/vim-ruby'
Plug 'derekwyatt/vim-scala'
Plug 'plasticboy/vim-markdown'
Plug 'honza/dockerfile.vim'

" Navigation and search
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'          " FZF vim integration
Plug 'preservim/nerdtree'        " File explorer

" Git integration
Plug 'airblade/vim-gitgutter'    " Git changes in gutter

" Color schemes
Plug 'morhetz/gruvbox'
Plug 'ghifarit53/tokyonight-vim'

" macOS specific
if has("unix")
  let s:uname = system("uname")
  if s:uname == "Darwin\n"
    Plug 'rizzatti/dash.vim',  { 'on': 'Dash' }
  endif
endif

call plug#end()

" Basic Settings
syntax on
filetype plugin indent on

" Modern defaults
set mouse=a                   " Enable mouse in all modes
set clipboard=unnamed         " Use system clipboard
set updatetime=300           " Faster update time
set timeoutlen=500          " Faster key sequence completion
set lazyredraw              " Don't redraw while executing macros
set shortmess+=c           " Don't pass messages to ins-completion-menu
set hidden                 " Allow hidden buffers
set encoding=utf-8        " Use UTF-8 encoding
set fileencoding=utf-8    " Use UTF-8 for written files
set scrolloff=8           " Keep 8 lines above/below cursor
set sidescrolloff=8       " Keep 8 characters left/right of cursor
set pumheight=10         " Limit popup menu height
set noshowmode           " Don't show mode (status line handles it)

" Split behavior
set splitbelow             " Open new splits below
set splitright            " Open new splits right
set signcolumn=yes        " Always show signcolumn

" File handling
set noswapfile
set nobackup
set nowritebackup
if !isdirectory($HOME."/.vim/undodir")
    call mkdir($HOME."/.vim/undodir", "p")
endif
set undofile
set undodir=~/.vim/undodir

" Interface
set number
set numberwidth=5
set laststatus=2
set cursorline
set showmatch
set showcmd
set cmdheight=2
set list
set listchars=tab:»·,trail:·,extends:>,precedes:<,nbsp:+
set nofoldenable
set ruler

" Search settings
set hlsearch
set incsearch             " Incremental search
set ignorecase
set smartcase
set path+=**             " Search down into subfolders
noremap <CR> :nohlsearch<CR>

" Indentation
set autoindent
set smartindent
set smarttab
set expandtab
set tabstop=2
set shiftwidth=2
set softtabstop=2

" Status line configuration
set statusline=%<%f\ (%{&ft})\ %-4(%m%)%=%-19(%3l,%02c%03V%)

" Completion
set wildmenu
set wildmode=longest,full
set wildignore+=.git,.svn,.DS_Store
set wildignore+=*/tmp/*,*.so,*.swp,*.zip
set wildignore+=*.rar,*.png,*.jpg,*.log
set wildignore+=*.o,*~,*.pyc

" Performance
set ttyfast
set shell=/usr/local/bin/zsh

" Color scheme
set termguicolors

let g:tokyonight_style = 'night' " available: night, storm
let g:tokyonight_enable_italic = 1

colorscheme tokyonight

" Start screen configuration
let g:startify_lists = [
      \ { 'type': 'files',     'header': ['   Recent Files']    },
      \ { 'type': 'dir',       'header': ['   Current Directory '. getcwd()] },
      \ { 'type': 'sessions',  'header': ['   Sessions']        },
      \ { 'type': 'bookmarks', 'header': ['   Bookmarks']       },
      \ ]

" CoC configuration
let g:coc_global_extensions = [
  \ 'coc-tsserver',
  \ 'coc-json',
  \ 'coc-pyright',
  \ 'coc-rust-analyzer'
  \ ]

" Use tab for trigger completion
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use K to show documentation in preview window
nnoremap <silent> K :call ShowDocumentation()<CR>

function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

" GoTo code navigation
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" FZF Configuration
let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit' }
let g:fzf_layout = { 'down': '~40%' }

" Key mappings
let mapleader=","

" Window navigation
nnoremap <C-j> <C-w><C-j>
nnoremap <C-k> <C-w><C-k>
nnoremap <C-h> <C-w><C-h>
nnoremap <C-l> <C-w><C-l>

" Quick buffer navigation
nnoremap <leader>bn :bnext<CR>
nnoremap <leader>bp :bprevious<CR>

" Quick tab navigation
nnoremap <leader>tn :tabnext<CR>
nnoremap <leader>tp :tabprevious<CR>

" Toggle Tagbar
nnoremap <F8> :TagbarToggle<CR>

" Quick vimrc access
nnoremap <leader>ev :vsplit $MYVIMRC<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>

" FZF mappings
nnoremap <leader>f :Files<CR>
nnoremap <leader>b :Buffers<CR>
nnoremap <leader>g :Ag<CR>

" NERDTree mappings
nnoremap <leader>n :NERDTreeToggle<CR>
nnoremap <leader>nf :NERDTreeFind<CR>

" Improved Git commands
function! GitCommand(command)
    let l:output = system(a:command)
    if v:shell_error
        echohl ErrorMsg
        echo "Git command failed: " . l:output
        echohl None
        return
    endif
    if empty(l:output)
        echo "No files to edit."
        return
    endif
    let l:files = split(l:output, "\n")
    exe "args " . join(map(l:files, 'fnameescape(v:val)'), ' ')
endfunction

command! GitModified :call GitCommand("git status --porcelain | sed -ne 's/^ M//p'")
command! GitConflict :call GitCommand("git diff --name-only --diff-filter=U")

" Auto commands
augroup vimrc_autogroup
    autocmd!
    " Spell checking
    autocmd FileType gitcommit setlocal spell
    autocmd BufRead,BufNewFile *.md setlocal spell

    " Return to last edit position
    autocmd BufReadPost *
        \ if &ft != 'gitcommit' && line("'\"") > 0 && line("'\"") <= line("$") |
        \   exe "normal g`\"" |
        \ endif

    " Resize splits on window resize
    autocmd VimResized * exe "normal! \<c-w>="
augroup END

" Format JSON command
command! FormatJSON %!python -m json.tool
