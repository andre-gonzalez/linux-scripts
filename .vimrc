" Turn syntax highlighting on.
syntax on

" Set tab width to 4 columns.
set tabstop=4

" Enable auto completion menu after pressing TAB
set wildmenu

" Make wildmenu behave like similar to Bash completion.
set wildmode=list:longest

:set number relativenumber

:augroup numbertoggle
:	autocmd!
:	autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
:	autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
:augroup END
