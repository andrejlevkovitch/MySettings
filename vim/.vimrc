" Open new windows at right
set splitright
" Show string numbers
set number
" Syntax hightliting
syntax on
" Search while type
set incsearch
" Search rezult highligt
set hlsearch
" Smart case from register
set ignorecase
set smartcase
" change color founded elements
highlight Search ctermbg=brown guibg=brown
" Use utf8
set termencoding=utf8
" No vi
set nocompatible
" Show cursor all the time
set ruler
" Show not finished commands in status bar
set showcmd
" Folding
set foldenable
set foldlevel=100
set foldmethod=indent
" Use system bufer
set clipboard=unnamed
" Use one buffer for all files
set hidden
" For gui
set guioptions-=T
" Command line height
set ch=1
" Show information about file
set statusline=%F%m%r%h%w\ [FORMAT=%{&ff}]\ [POS=%04l,%04v]\ [LEN=%L]
set laststatus=2
" Hide mose while typing
set mousehide
" Turn on auto tabs
set autoindent
" Tabs in spaces
set expandtab
" Tabulation size
set shiftwidth=2
set softtabstop=2
set tabstop=2
" Smart tabs past {
set smartindent
" Show pairs
set showmatch
" history size
set history=200
" Dop information in status bar
set wildmenu

set nowrap
set colorcolumn=80
if exists('+colorcolumn')
    highlight ColorColumn ctermbg=235 guibg=#2c2d27
    highlight CursorLine ctermbg=235 guibg=#2c2d27
    highlight CursorColumn ctermbg=235 guibg=#2c2d27
    let &colorcolumn=join(range(81,999),",")
else
    autocmd BufWinEnter * let w:m2=matchadd('ErrorMsg', '\%>80v.\+', -1)
end

" Show cursor line
set cursorline
highlight CursorLine guibg=lightblue ctermbg=darkgray
highlight CursorLine term=none cterm=none

"-------------------------------------------------------------------------------

" Leader
let mapleader= "\\"


" For qrc
autocmd BufRead,BufNewFile *.qrc setfiletype xml
" For qss
autocmd BufRead,BufNewFile *.qss setfiletype css
" For qml
autocmd BufRead,BufNewFile *.qml setfiletype qml

"-------------------------------------------------------------------------------

filetype plugin on 
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
filetype plugin indent on
Plugin 'VundleVim/Vundle.vim'
Plugin 'scrooloose/nerdtree'
Plugin 'Xuyuanp/nerdtree-git-plugin'
Plugin 'Valloric/YouCompleteMe'
Plugin 'andrejlevkovitch/color_coded'
Plugin 'rdnetto/YCM-Generator'
Plugin 'majutsushi/tagbar'
Plugin 'tikhomirov/vim-glsl'
Plugin 'vifm/vifm.vim'
Plugin 'pboettch/vim-cmake-syntax'
Plugin 'vim-python/python-syntax'
Plugin 'plasticboy/vim-markdown'
Plugin 'godlygeek/tabular'

call vundle#end()
filetype plugin indent on

"-------------------------------------------------------------------------------

" NerdTree
" Open by CTRL+n
map <c-n> :NERDTreeToggle<cr>
" Open if vim start without name of file
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
" Ignore files
" let NERDTreeIgnore=['\.o$', '\.a$', '\.so$']
" Close after close last file
let NERDTreeQuitOnOpen=1
" NERDTress File highlighting
function! NERDTreeHighlightFile(extension, fg, bg, guifg, guibg)
 exec 'autocmd filetype nerdtree highlight ' . a:extension .' ctermbg='. a:bg .' ctermfg='. a:fg .' guibg='. a:guibg .' guifg='. a:guifg
 exec 'autocmd filetype nerdtree syn match ' . a:extension .' #^\s\+.*'. a:extension .'$#'
endfunction

call NERDTreeHighlightFile('h', 'cyan', 'none', 'cyan', '#151515')
call NERDTreeHighlightFile('hxx', 'cyan', 'none', 'cyan', '#151515')
call NERDTreeHighlightFile('hpp', 'cyan', 'none', 'cyan', '#151515')
call NERDTreeHighlightFile('cpp', 'lightgreen', 'none', 'lightgreen', '#151515')
call NERDTreeHighlightFile('cxx', 'lightgreen', 'none', 'lightgreen', '#151515')
call NERDTreeHighlightFile('cmake', 'lightblue', 'none', 'lightblue', '#151515')

call NERDTreeHighlightFile('lua', 'lightyellow', 'none', 'lightyellow', '#151515')

call NERDTreeHighlightFile('json', 'yellow', 'none', 'yellow', '#151515')
call NERDTreeHighlightFile('xml', 'yellow', 'none', 'yellow', '#151515')

let g:NERDTreeIndicatorMapCustom = {
    \ "Modified"  : "✹",
    \ "Staged"    : "✚",
    \ "Untracked" : "✭",
    \ "Renamed"   : "➜",
    \ "Unmerged"  : "═",
    \ "Deleted"   : "✖",
    \ "Dirty"     : "✗",
    \ "Clean"     : "✔︎",
    \ 'Ignored'   : '☒',
    \ "Unknown"   : "?"
    \ }

"-------------------------------------------------------------------------------

" Clang Format
function! ClangFormat()
  let l:lines = "all"
  py3f /usr/share/clang/clang-format-9/clang-format.py
endfunction
autocmd FileType c,cpp nnoremap <buffer> <c-k> :call ClangFormat()<cr>
autocmd BufWrite *.cpp,*.hpp,*.cxx,*.c,*.h call ClangFormat()

" Lua Format
function! LuaFormat()
  py3f /usr/local/bin/lua-format.py
endfunction
autocmd FileType lua nnoremap <buffer> <c-k> :call LuaFormat()<cr>
autocmd BufWrite *.lua call LuaFormat()

" Python Format
function! PythonFormat()
  py3f /usr/local/bin/python-format.py
endfunction
autocmd FileType python nnoremap <buffer> <c-k> :call PythonFormat()<cr>
autocmd BufWrite *.py call PythonFormat()

" Json Format (just use python format
autocmd FileType json nnoremap <buffer> <c-k> :call PythonFormat()<cr>
autocmd BufWrite *.json call PythonFormat()

"-------------------------------------------------------------------------------

" YouCompleteMe
" Get type of wariable
map <leader>t :YcmCompleter GetType<cr>
" python
let g:ycm_python_binary_path = '/usr/bin/python3'
" Preview window
let g:ycm_add_preview_to_completeopt = 1
let g:ycm_autoclose_preview_window_after_completion = 1

let g:ycm_filepath_completion_use_working_dir = 1
let g:ycm_confirm_extra_conf=0

" Maximum hight diagnostic window
let g:ycm_max_diagnostics_to_display = 5

" Set no limit for autocomplete menu
let g:ycm_max_num_candidates = 0

let g:ycm_key_invoke_completion = '<C-Space>'

" Check errors ctrl-f
map <c-f> :YcmDiags<cr>
" Recomplile file and use new options
nnoremap <F5> :YcmForceCompileAndDiagnostics<CR>
" Get documentation
nnoremap <leader>d :YcmCompleter GetDoc<cr>
" To declaration
nnoremap <c-]> :YcmCompleter GoToDeclaration<cr>
nnoremap <leader>] :YcmCompleter GoToImprecise<cr>
" To include
nnoremap<leader>i :YcmCompleter GoToInclude<cr>
" To defenition
nnoremap<leader>[ :YcmCompleter GoToDefinition<cr>

"-------------------------------------------------------------------------------

" TagBar
nmap <F8> :TagbarToggle<CR>
" Fix bug with slow cursor in tagbar
autocmd FileType tagbar setlocal nocursorline nocursorcolumn

"-------------------------------------------------------------------------------

" GLSL
autocmd BufWinEnter *.glsl setfiletype glsl

"-------------------------------------------------------------------------------

" Color-coded
let g:color_coded_filetypes = ['c', 'cpp']

"-------------------------------------------------------------------------------

" python-syntax
let g:python_highlight_all = 1
autocmd FileType python set shiftwidth=2
autocmd FileType python set tabstop=2
autocmd FileType python set softtabstop=2
