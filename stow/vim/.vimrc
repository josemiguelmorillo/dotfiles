" ============================
" Basic & Leader
" ============================
set nocompatible                 " Use Vim defaults, not vi compatible mode
let mapleader = ","              " Leader key

" ============================
" UI & Editing Experience
" ============================
set number relativenumber        " Absolute on current line, relative elsewhere
set cursorline                   " Highlight current line
set nowrap                       " Do not wrap long lines
set scrolloff=8                  " Keep 8 lines visible above/below cursor
set sidescrolloff=8              " Keep context when scrolling horizontally
set showcmd                      " Show partial command in bottom-right
set laststatus=2                 " Always show status line
set ruler                        " Show cursor position

" Show invisible characters (helps spot tabs/trailing spaces)
set list
set listchars=tab:▸\ ,trail:·

" Optional quality-of-life
set hidden                       " Allow switching buffers without saving
set autoread                     " Reload files changed outside Vim (git checkout, etc.)
set splitright                   " Vertical splits open to the right
set splitbelow                   " Horizontal splits open below
set backspace=indent,eol,start   " Sane backspace in insert mode
set timeoutlen=200               " Reduce delay for key sequences (e.g. jk escape)

" Persistent undo with centralized directory
if has('persistent_undo')
    let s:undodir = expand('~/.vim/undo')
    if !isdirectory(s:undodir) | call mkdir(s:undodir, 'p') | endif
    set undofile
    set undodir=~/.vim/undo
endif

set noswapfile

" Use system clipboard
set clipboard=unnamed

" ============================
" Filetypes, Syntax & Indent
" ============================
syntax enable                    " Syntax highlighting
filetype plugin indent on        " Filetype detection, plugins, and indentation

" Global indentation defaults
set expandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4

" Suppress auto comment continuation on o/O
augroup my_formatopts
    autocmd!
    autocmd FileType * setlocal formatoptions-=o
augroup END

" Soft-wrap long Markdown lines without changing file contents
augroup my_markdown
    autocmd!
    autocmd FileType markdown setlocal wrap linebreak breakindent
augroup END

" ============================
" Completion & Wildmenu
" ============================
set wildmenu                     " Enhanced command-line completion
set wildmode=longest:full,full   " Completion behavior
set completeopt=menu,menuone,noselect  " Better popup completion UX

" ============================
" Search
" ============================
set ignorecase                   " Case-insensitive search...
set smartcase                    " ...unless the search has uppercase
set incsearch                    " Show matches as you type
set hlsearch                     " Highlight matches

" Use ripgrep for :grep if available
if executable('rg')
    set grepprg=rg\ --vimgrep\ --smart-case
    set grepformat=%f:%l:%c:%m
endif

" Clear search highlight quickly
nnoremap <leader><space> :nohlsearch<CR>

" ============================
" Paths, Files & Tags
" ============================
set path+=**                     " Search subdirs with gf and friends
set wildignore+=**/.git/**,**/node_modules/**,**/__pycache__/**,**/dist/**,**/.DS_Store
set tags=./tags;/                " Use tags file, stopping at project root

" Generate tags for the project (requires ctags installed)
command! MakeTags execute '!ctags -R .'

" ============================
" Quickfix Convenience
" ============================
nnoremap <silent> <leader>q :cclose<CR>
nnoremap <silent> ]q :cnext<CR>
nnoremap <silent> [q :cprev<CR>

" ============================
" NetRW (Built-in File Explorer)
" ============================
function! ToggleNetrw()
    for w in range(1, winnr('$'))
        let buf = winbufnr(w)
        if getbufvar(buf, '&filetype') ==# 'netrw'
            execute w . 'wincmd c'
            return
        endif
    endfor

    Lexplore
endfunction

nnoremap <silent> <leader>e :call ToggleNetrw()<CR>

let g:netrw_banner = 0           " Hide banner
let g:netrw_liststyle = 3        " Tree-style view
let g:netrw_browse_split = 4     " Open in prior window
let g:netrw_winsize = 25         " Use 25% width
let g:netrw_altv = 1             " Use the alternate (non-netrw) window
let g:netrw_keepdir = 0          " Do not keep cwd fixed when browsing
let g:netrw_fastbrowse = 0       " More reliable refresh behavior
let g:netrw_hide = 0             " Show all files including dotfiles

" ============================
" Mappings: Insert Mode
" ============================
inoremap jk <Esc>

" ============================
" Mappings: Normal Mode
" ============================
" Build ctags
nnoremap <silent> <leader>t :MakeTags<CR>

" Edit and source vimrc
nnoremap <silent> <leader>ev :edit $MYVIMRC<CR>
nnoremap <silent> <leader>sv :source $MYVIMRC<CR>

" Returns git root of the current file, or its directory as fallback
function! ProjectRoot()
    let root = trim(system('git -C ' . shellescape(expand('%:p:h')) . ' rev-parse --show-toplevel 2>/dev/null'))
    return root !=# '' ? root : expand('%:p:h')
endfunction

" Search word under cursor across the project (uses rg via grepprg)
nnoremap <silent> <leader>f :execute 'grep! ' . shellescape(expand('<cword>')) . ' ' . shellescape(ProjectRoot())<CR>:copen<CR>

" Search a literal string across the project
function! SearchProject()
    let q = input('Search: ')
    if q !=# ''
        silent! execute 'grep! ' . shellescape(q) . ' ' . shellescape(ProjectRoot())
        copen
    endif
endfunction
nnoremap <silent> <leader>g :call SearchProject()<CR>

" ============================
" Run Current Python File
" ============================
nnoremap <silent> <leader>r :write<CR>:execute '!python3 ' . shellescape(expand('%:p'))<CR>

nnoremap <leader>cp :let @+ = expand('%:p')<CR>:echo "Copied path!"<CR>
