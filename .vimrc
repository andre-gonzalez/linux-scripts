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

" Ignore case in search
set ignorecase
set smartcase

" Added the dracula theme
packadd! dracula
syntax enable
colorscheme dracula

"enable plugins
call plug#begin('~/.vim/autoload/plug.vim')

Plug 'gabrielelana/vim-markdown'

call plug#end()
