let mapleader = ' '

syntax on
filetype on
filetype plugin on
filetype indent on
set noswapfile
set number
set relativenumber
set history=2000
set mouse=a
set clipboard=unnamedplus
let g:netrw_banner=0

" base
set nocompatible                " don't bother with vi compatibility
set autoread                    " reload files when changed on disk, i.e. via `git checkout`
set shortmess=atI
set magic                       " For regular expressions turn magic on
set title                       " change the terminal's title
set nobackup                    " do not keep a backup file
set novisualbell                " turn off visual bell
set noerrorbells                " don't beep
set visualbell t_vb=            " turn off error beep/flash
set t_vb=
set tm=500

" search
set hlsearch                    " highlight searches
set incsearch                   " do incremental searching, search as you type
set ignorecase                  " ignore case when searching
set smartcase                   " no ignorecase if Uppercase char present

" indent
set autoindent smartindent shiftround
set shiftwidth=4
set tabstop=4
set softtabstop=4

" encoding
set encoding=utf-8
set fileencodings=ucs-bom,utf-8,cp936,gb18030,big5,euc-jp,euc-kr,latin1
set termencoding=utf-8
set ffs=unix,dos,mac
set formatoptions+=m
set formatoptions+=B

" select & complete
set selection=inclusive
set selectmode=mouse,key


set completeopt=longest,menu
set wildmenu                           " show a navigable menu for tab completion"
set wildmode=longest,list,full
set wildignore=*.o,*~,*.pyc,*.class

" theme
set background=dark
colorscheme desert

" set mark column color
hi! link SignColumn   LineNr
hi! link ShowMarksHLl DiffAdd
hi! link ShowMarksHLu DiffChange
highlight EndOfBuffer ctermbg=NONE guibg=NONE
highlight NonText ctermbg=NONE guibg=NONE

" status line
set statusline=%<%f\ %h%m%r%=%k[%{(&fenc==\"\")?&enc:&fenc}%{(&bomb?\",BOM\":\"\")}]\ %-14.(%l,%c%V%)\ %P
set laststatus=2   " Always show the status line - use 2 lines for the status bar

" my custom keybinding
nnoremap <leader>e 15L:Lex<CR>                          " 15 left columns explorer
let g:copy_mode = 0
nnoremap <leader>c :if g:copy_mode == 0 \| set nonumber norelativenumber \| let g:copy_mode=1 \| else \| set number relativenumber \| let g:copy_mode=0 \| endif<CR>
