" TO-DOs
"	- Learn to use fugitive.vim
"	- Larn to use Harpoon
"	- Learn to personalize vim-airline
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

" Automatically deletes all trailing whitespace on save
autocmd BufWritePre * %s/\s\+$//e

"alternate between relative line numbers and absolute based in wich mode you are
:set number
:augroup numbertoggle
:  autocmd!
:  autocmd BufEnter,FocusGained,InsertLeave,WinEnter * if &nu && mode() != "i" | set rnu   | endif
:  autocmd BufLeave,FocusLost,InsertEnter,WinLeave   * if &nu                  | set nornu | endif
:augroup END

set incsearch

set scrolloff=8

"fill with the date and hour
nmap <F3> i<C-R>=strftime("%Y-%m-%d %a %I:%M %p")<CR><Esc>
imap <F3> <C-R>=strftime("%Y-%m-%d %a %I:%M %p")<CR>

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

		"LSP for having language servers
		Plug 'neovim/nvim-lspconfig'
		"To enable auto completion
		Plug 'hrsh7th/nvim-compe'


		"Tree sitter. Do not need the nvim-treesitter because it was already installed in the
		"telescope requirements
		Plug 'nvim-treesitter/playground'
		" enable jupyter notebook inside vim
        Plug 'jupyter-vim/jupyter-vim'

		"Plugin to show + and - git signs in the text file
		Plug 'airblade/vim-gitgutter'

call plug#end()

"configuration of jupyter-vim
if has('nvim')
    let g:python3_host_prog = '/usr/bin/python3'
else
    set pyxversion=3
endif



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


"Plugin configuration
source ~/.config/nvim/bash-lsp.lua
source ~/.config/nvim/compe-config.lua
source ~/.config/nvim/lsp-config.vim
source ~/.config/nvim/python-lsp.lua

