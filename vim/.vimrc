" Open new windows at right
set splitright
" Show string numbers
set number
" Syntax hightliting
syntax on
" Search while type
set incsearch
" Search rezult highlight
set hlsearch
" Smart case from register
set ignorecase
set smartcase
" change color founded elements
highlight Search ctermbg=brown guibg=brown
" Use utf8
set encoding=utf8
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
" Hide mouse while typing
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

" Show cursor line
set cursorline
highlight CursorLine guibg=lightblue ctermbg=darkgray
highlight CursorLine term=bold cterm=bold

"-------------------------------------------------------------------------------

" Leader
let mapleader= "\\"


" For qrc
autocmd BufRead,BufNewFile *.qrc setfiletype xml
" For qss
autocmd BufRead,BufNewFile *.qss setfiletype css
" For qml
autocmd BufRead,BufNewFile *.qml setfiletype qml
" For gnuplot
autocmd BufRead,BufNewFile *.plot setfiletype gnuplot

"-------------------------------------------------------------------------------

filetype plugin on 
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
filetype plugin indent on
Plugin 'VundleVim/Vundle.vim'
Plugin 'scrooloose/nerdtree'
Plugin 'Xuyuanp/nerdtree-git-plugin'
Plugin 'ycm-core/YouCompleteMe'
Plugin 'rdnetto/YCM-Generator'
Plugin 'majutsushi/tagbar'
Plugin 'tikhomirov/vim-glsl'
Plugin 'pboettch/vim-cmake-syntax'
Plugin 'vim-python/python-syntax'
Plugin 'plasticboy/vim-markdown'
Plugin 'godlygeek/tabular'
Plugin 'luochen1990/rainbow'

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

"-------------------------------------------------------------------------------

" help function for formatters
function! CopyDiffToBuffer(input, output, bufname)
  " prevent out of range in cickle
  let min_len = min([len(a:input), len(a:output)])

  " copy all lines, that was changed
  for i in range(0, min_len - 1)
    let output_line = a:output[i]
    let input_line  = a:input[i]
    if input_line !=# output_line
      call setline(i + 1, output_line) " lines calculate from 1, items - from 0
    end
  endfor

  " in this case we have to handle all lines, that was in range
  if len(a:input) != len(a:output)
    if min_len == len(a:output) " remove all extra lines from input
      call deletebufline(a:bufname, min_len + 1, "$")
    else " append all extra lines from output
      call append("$", a:output[min_len:])
    end
  end

  " XXX if formatting is a long operation and we call after format start some
  " other command, then window will display invalid data. For prevent this we
  " just redraw the windows
  redraw!
endfunction

" Clang Format
function! ClangFormat()
  let input      =  getline(1, "$")
  let output_str =  system("clang-format -assume-filename " .. bufname("%") .. " -fallback-style=none", input)

  " output of system is a string, so transform it to list
  let output=split(output_str, "\n")

  " NOTE: we can get error about not valid `.clang-format`
  if v:shell_error == 0
    call CopyDiffToBuffer(input, output, bufname("%"))
  else " if we get error that means you have not valid config
    " change YAML to .clang-format file with complete path
    let config_file = findfile(".clang-format", ".;")
    let output[0]   = substitute(output[0], "YAML", config_file, "")

    lexpr output
    lwindow
  end
endfunction
autocmd FileType c,cpp,cuda nnoremap <buffer> <c-k> :call ClangFormat()<cr>
autocmd BufWrite *.cpp,*.hpp,*.cxx,*.c,*.h,*.cuda,*.cu call ClangFormat()


" Lua Format
function! LuaFormat()
  let input = getline(1, "$")

  " in case of some error formatter print to stderr error message and exit
  " with 0 code, so we need redirect stderr to file, for read message in case
  " of some error. So let create a temporary file
  let error_file = tempname()

  let flags = " -i "

  " we can use config file for formatting which we have to set manually
  let config_file = findfile(".lua-format", ".;")
  if empty(config_file) == 0 " append config_file to flags
    let flags = flags .. " -c " .. config_file
  end

  let output_str=system("lua-format " .. flags .. " 2> " .. error_file, input)

  if empty(output_str) == 0 " all right
    let output = split(output_str, "\n")
    call CopyDiffToBuffer(input, output, bufname("%"))

    " also clear lbuffer
    lexpr ""
    lwindow
  else " we got error
    let errors = readfile(error_file)

    " insert filename of current buffer in front of list. Need for errorformat
    let source_file = bufname("%")
    call insert(errors, source_file)

    set efm=%+P%f,line\ %l:%c\ %m,%-Q
    lexpr errors
    lwindow 5
  end

  call delete(error_file)
endfunction
autocmd FileType lua nnoremap <buffer> <c-k> :call LuaFormat()<cr>
autocmd BufWrite *.lua call LuaFormat()

function! LuaCheck()
  let source_file = bufname("%")
  let input       = getline(1, '$')

  " we have to create temporary file for validation, because luacheck work only
  " with files 
  let temp_file = tempname()
  call writefile(input, temp_file)
  let errors = system("luacheck " .. temp_file)
  call delete(temp_file)

  " append filename for errorformat
  let errors = source_file .. "\n" .. errors

  set efm=%+P%f,%*[^:]:%l:%c:\ %m
  lexpr errors 
  lwindow 5
endfunction
autocmd FileType lua nnoremap <buffer> <c-f> :call LuaCheck()<cr>


" Python Format
function! PythonFormat()
  let input       = getline(1, '$')
  let output_str  = system('yapf --style=chromium', input)
  if v:shell_error == 0 " all right
    let output = split(output_str, "\n")
    call CopyDiffToBuffer(input, output, bufname("%"))

    " and creare lbuffer
    lexpr ""
    lwindow
  else " we got errors
    lexpr output_str
    lwindow 5
  end
endfunction
autocmd FileType python nnoremap <buffer> <c-k> :call PythonFormat()<cr>
autocmd BufWrite *.py call PythonFormat()


" Json Format
function! JsonFormat()
  let input       = getline(1, '$')
  let output_str  = system('jq "."', input)
  if v:shell_error == 0 " all right
    let output = split(output_str, "\n")
    call CopyDiffToBuffer(input, output, bufname("%"))

    " and creare lbuffer
    lexpr ""
    lwindow
  else " we got errors
    lexpr output_str
    lwindow 5
  end
endfunction
autocmd FileType json nnoremap <buffer> <c-k> :call JsonFormat()<cr>
"autocmd BufWrite *.json call JsonFormat()


" HTML tidy
function! HTMLFormat()
  let input       = getline(1, "$")
  let error_file  = tempname()
  let output_str  = system("tidy -qi -ashtml 2>" .. error_file, input)

  if empty(output_str) == 0 " all right
    let output = split(output_str, "\n")
    call CopyDiffToBuffer(input, output, bufname("%"))

    " alse cleare lbuffer
    lexpr ""
    lwindow
  else " we got error
    let errors = readfile(error_file)

    let source_file = bufname("%")
    call insert(errors, source_file) " append filename for right errorformat

    set efm=%+P%f,line\ %l\ column\ %c\ -\ %t%*[^:]:\ %m,%-Q
    lexpr errors
    lwindow 5
  end

  call delete(error_file)
endfunction
autocmd FileType html nnoremap <buffer> <c-k> :call HTMLFormat()<cr>
autocmd BufWrite *.html call HTMLFormat()

function! HTMLCheck()
  let input   =  getline(1, '$')
  let errors  =  system('tidy -q -e', input)
  if empty(errors) == 0 " ther are some errors
    " append filename for right errorformat
    let source_file = bufname("%")
    let errors      = source_file .. "\n" .. errors

    set efm=%+P%f,line\ %l\ column\ %c\ -\ %t%*[^:]:\ %m,%-Q
    lexpr errors
    lwindow 5
  else " no errors, so we must clear lbuffer
    lexpr ""
    lwindow
  endif
endfunction
autocmd FileType html nnoremap <buffer> <c-f> :call HTMLCheck()<cr>


function! BashCheck()
  let input = getline(1, '$')

  " Because shellcheck work only with files we have to create temporary file for
  " validation
  let temp_file = tempname()
  call writefile(input, temp_file)
  let errors = system("shellcheck -f gcc " .. temp_file)
  call delete(temp_file)

  if empty(errors) == 0
    " append filename for errorformat
    let source_file = bufname("%")
    let errors      = source_file .. "\n" .. errors

    set efm=%+P%f,%*[^:]:%l:%c:\ %t%*[^:]:\ %m,%-Q
    lexpr errors
    lwindow 5
  else " clear lbuffer
    lexpr ""
    lwindow
  end
endfunction
autocmd FileType sh,bash nnoremap <buffer> <c-f> :call BashCheck()<cr>


" Go format
function! GoFormat()
  let input      = getline(1, "$")
  let output_str = system("gofmt", input)

  " output of system is a string, so transform it to list
  let output=split(output_str, "\n")

  " NOTE: you can get error about invalid go code
  if v:shell_error == 0
    call CopyDiffToBuffer(input, output, bufname("%"))

    " also clear lbuffer
    lexpr ""
    lwindow
  else " if we get error, then it means that you have critical error in the code
    " change `<standard input>` to filename for correct error displaing
    for i in range(len(output))
        let output[i] = substitute(output[i], "<standard input>", bufname(""), "")
    endfor

    lexpr output
    lwindow
  end
endfunction
autocmd FileType go nnoremap <buffer> <c-k> :call GoFormat()<cr>
autocmd BufWrite *.go call GoFormat()


" Rust format
function! RustFormat()
  let input      = getline(1, "$")
  let output_str = system("rustfmt", input)

  " output of system is a string, so transform it to list
  let output=split(output_str, "\n")

  " NOTE: you can get error about invalid rust code
  if v:shell_error == 0
    call CopyDiffToBuffer(input, output, bufname("%"))

    " also clear lbuffer
    lexpr ""
    lwindow
  else " if we get error, then it means that you have critical error in the code
    " change `<stdin>` to filename for correct error displaing
    for i in range(len(output))
        let output[i] = substitute(output[i], " --> <stdin>", bufname(""), "")
    endfor

    lexpr output
    lwindow
  end
endfunction
autocmd FileType rust nnoremap <buffer> <c-k> :call RustFormat()<cr>
autocmd BufWrite *.rs call RustFormat()

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
let g:ycm_confirm_extra_conf = 0

" Maximum hight diagnostic window
let g:ycm_max_diagnostics_to_display = 5

" Set no limit for autocomplete menu
let g:ycm_max_num_candidates = 0

let g:ycm_key_invoke_completion = '<C-Space>'

let g:ycm_auto_trigger = 1
let g:ycm_min_num_of_chars_for_completion = 5
" clangd options
let g:ycm_use_clangd = 1
let g:ycm_clangd_uses_ycmd_caching = 0
let g:ycm_rust_toolchain_root = $HOME."/.cargo"

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

" python-syntax
let g:python_highlight_all = 1
autocmd FileType python set shiftwidth=2
autocmd FileType python set tabstop=2
autocmd FileType python set softtabstop=2

" vim-hl-client
let g:hl_server_binary  = "~/.vim/bundle/vim-hl-client/build/bin/hl-server"

" rainbow parentheses
let g:rainbow_active = 1

let g:rainbow_conf = {
\	'ctermfgs': ['Yellow', 'Lightblue', 'Lightmagenta', 'Green'],
\ 'separately': {
\   'cpp': {
\     'parentheses': ['start=/(/ end=/)/ fold', 'start=/\[/ end=/\]/ fold', 'start=/{/ end=/}/ fold', 'start=/\[\[/ end=/\]\]/ fold']
\   },
\   'cmake': 0,
\   'nerdtree': 0
\ }
\}
