" Turn syntax highlighting on.
syntax on

" Set tab width to 4 columns.
set tabstop=4

" Enable auto completion menu after pressing TAB in command mode
set wildmenu

" Make wildmenu behave like similar to Bash completion.
set wildmode=list:longest

"move between split windows using ctrl + h,j,k,l
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

"alternate between relative line numbers and absolute based in wich mode you are
:set number
:augroup numbertoggle
:  autocmd!
:  autocmd BufEnter,FocusGained,InsertLeave,WinEnter * if &nu && mode() != "i" | set rnu   | endif
:  autocmd BufLeave,FocusLost,InsertEnter,WinLeave   * if &nu                  | set nornu | endif
:augroup END

set incsearch

set scrolloff=8

" Ignore case in search and if you type an uppercase character it will change
" the search to a case sensitive one
set ignorecase
set smartcase

"allows you to paste in vim with the mouse
set mouse=a

" save undo trees in files
set undofile
set undodir=~/.vim/undo

" number of undo saved
set undolevels=10000 

" Enable spell checking
map <leader>oe :setlocal spell! spelllang=en_us<CR>
map <leader>op :setlocal spell! spelllang=pt_br<CR>

"Search down into subfolders
"Provides tab-completion for all file-related tasks
set path+=**

" consider only 100 columns until break line
setl tw=100

"Enable copying to clipboard
set clipboard+=unnamedplus

"use S as an alias to replace all
noremap <leader>s :%s//g<Left><Left>

"enable plugins
call plug#begin()

Plug 'gabrielelana/vim-markdown'

Plug 'vim-airline/vim-airline'

Plug 'tpope/vim-fugitive'

Plug 'Yggdroot/indentLine'

Plug 'tpope/vim-surround'

Plug 'preservim/nerdtree'

Plug 'morhetz/gruvbox'

Plug 'rentalcustard/exuberant-ctags'
" autocomplete for python
Plug 'kiteco/vim-plugin'
"vim in the brownser
Plug 'glacambre/firenvim', { 'do': { _ -> firenvim#install(1) } }

" telescope requirements
Plug 'nvim-treesitter/nvim-treesitter'
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzy-native.nvim'

call plug#end()

" remap to run telescope with \ + f
nnoremap <Leader>f :lua require('telescope.builtin').find_files()<CR>
" remap to run nerdtree with \ + n
nnoremap <leader>n :NERDTreeFocus<CR>
" Set firenvim extension to ignore whats app
"let fc['https?://web.whatsapp.com/'] = {'takeover': 'never', 'priority': 1 }
set clipboard=unnamed
set background=dark
let g:kite_tab_complete=1
set completeopt+=noselect
colorscheme gruvbox
