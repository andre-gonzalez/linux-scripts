" Turn syntax highlighting on.
syntax on

" Set tab width to 4 columns.
set tabstop=4

" Enable auto completion menu after pressing TAB
set wildmenu

" Make wildmenu behave like similar to Bash completion.
set wildmode=list:longest

set number relativenumber

set incsearch

set scrolloff=8

" Ignore case in search and if you type an uppercase character it will change
" the search to a case sensitive one
set ignorecase
set smartcase

"allows you to pase in vim with the mouse
set mouse=a

" Added the dracula theme
packadd! dracula
syntax enable
colorscheme dracula

"enable plugins
call plug#begin()

Plug 'gabrielelana/vim-markdown'

Plug 'vim-airline/vim-airline'

Plug 'Yggdroot/indentLine'

Plug 'tpope/vim-surround'

Plug 'preservim/nerdtree'

call plug#end()
