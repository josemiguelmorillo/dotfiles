" === Leader Key Definition ===
" Set leader key to comma (optional, default is '\')
let mapleader=","

" === General Settings ===
syntax on                          " Enable syntax highlighting
filetype plugin indent on          " Enable filetype detection and automatic indentation
set number                         " Show line numbers
set relativenumber                 " Show relative line numbers (useful for navigation)
set encoding=utf-8                 " Use UTF-8 encoding

" === Indentation and Tabs ===
set tabstop=4                      " Number of spaces that a <Tab> counts for
set shiftwidth=4                   " Number of spaces to use for each step of (auto)indent
set expandtab                      " Use spaces instead of tabs
set autoindent                     " Copy indent from current line when starting a new one
set smartindent                    " Automatically insert indents in code

" === Usability Enhancements ===
set scrolloff=5                    " Keep 5 lines visible above/below the cursor when scrolling
set nowrap                         " Do not wrap long lines
set clipboard=unnamedplus          " Use system clipboard for all operations

" === Python-Specific Settings ===
autocmd FileType python setlocal tabstop=4 shiftwidth=4 expandtab
" Optionally, run the current file on save (uncomment to enable)
" autocmd BufWritePost *.py silent! !python3 %

" === Insert Mode Shortcuts ===
inoremap jk <Esc>                   " Exit insert mode quickly using jk

" === File Explorer Key Mapping ===
" Open current directory in a vertical split using built-in netrw
nnoremap <leader>e :Vex .<CR>

" === Run Python Script ===
" Save and run the current Python file
nnoremap <leader>r :w<CR>:!python3 %<CR>


