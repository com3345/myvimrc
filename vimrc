" Startup {{{
filetype plugin indent on 
" 根据平台和分辨率大小自动设置字体大小 
autocmd VimEnter * call SetFont(GetOS(), GetFtSize())
" vim折叠方式为marker
au FileType vim setlocal foldmethod=marker
" }}}

" General {{{

augroup strip_traling_spaces
au!
autocmd FileType css, javascript, python autocmd BufWritePre <buffer> call <SID>StripTrailingSpaces() 
augroup END

" 当vimrc保存时，重载它
au! BufWritePost $MYVIMRC source $MYVIMRC


set nocompatible
set nobackup
set noundofile
set noswapfile
set history=1024
set autochdir "自动跳转到vim打开的文件所在的目录
set nobomb "不要bom头
set backspace=indent,eol,start "然退格键可以删除到上一行/缩进并可以超过插入模式插入的地方
set clipboard+=unnamed "让系统剪贴板和vim共享
set showcmd
set number "显示行号

syntax on
"  }}}

" Lang & Encoding √{{{
set fileencodings=utf-8,gbk2312,gbk,gb18030,cp936
set encoding=utf-8
set langmenu=zh_CN
let $LANG = 'en_US.UTF-8'
"  }}}

" GUI √ {{{
set t_Co=256
colors zenburn 

set splitbelow
set splitright
set guioptions-=T
set guioptions-=m
set guioptions-=L
set guioptions-=r
set guioptions-=b
if has("mac")
    set lines=35 columns=140
else
    set lines=9999 columns=9999
endif
" }}}

" Vundle {{{
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'
Plugin 'szw/vim-g'
" ----- Ale ----- {{{
le g:airline#extensions#ale#enabled = 1
let g:ale_set_loclist = 0
let g:ale_set_quickfix = 1
" }}}
Plugin 'w0rp/ale'

" ----- NerdTree ----- {{{
Plugin 'scrooloose/nerdtree'

let NERDTreeIgnore=['.idea', '*.pyc']
let NERDTreeBookmarksFile=$VIM . '/NERDTreeBookmarks'
let NERDTreeMinimalUI=1
let NERDTreeShowBookmarks=1
let g:NERDTreeWinPos='right'
if exists('g:NERDTreeWinPos')
    au vimenter * NERDTree | wincmd p
endif
"  }}}

" ----- Jedi-Vim ----- {{{
Plugin 'davidhalter/jedi-vim'
" }}}

" ----- Airline ---- {{{
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#branch#enabled=1
"  }}}

" ----- Fugitive ----- {{{
Plugin 'tpope/vim-fugitive'
" }}}
call vundle#end()            
" }}}

" Format √ {{{
set autoindent
set smartindent
set tabstop=4
set softtabstop=4
set expandtab
set foldmethod=indent
" }}}

" Python √{{{
autocmd! BufNewFile, BufRead *.py
\ set shiftwidth=4
\ set fileformat=unix
au! BufNewFile, *.py call append(0, "\# -*- coding: utf-8 -*-")
"nnoremap <F5> :exec '!python' shellescape(@%, 1)<cr>
au! FileType Python nnoremap <buffer> <F5> :exec '!python' shellescape(@%, 1)<cr>
autocmd! FileType python nnoremap <leader>= :0,$!yapf<CR>
" }}}

" Keymap {{{
let mapleader=" "

nnoremap <F2> :NERDTreeToggle<cr>
nnoremap <F3> :setlocal number!<cr>
map <leader>goo :Google<cr>
nmap <leader>s :source $MYVIMRC<cr>
nmap <leader>e :e $MYVIMRC<cr>
" tab创建/关闭/遍历
map <leader>tn :tabnew<cr>
map <leader>tc :tabclose<cr>
map <leader>th :tabp<cr>
map <leader>tl :tabn<cr>

nnoremap <leader>q :bp<cr>:bd #<cr>
map <leader>bp :bp<cr>
map <leader>bn :bn<cr>

" 命令模式下的行首尾
cnoremap <C-a> <home>
cnoremap <C-e> <end>

" 转换当前行为大写
inoremap <C-u> <esc>mzgUiw`za

" 插入模式移动光标alt + 方向键
inoremap ∆ <Down>
inoremap ˚ <Up>
inoremap ˙ <Left>
inoremap ¬ <Right>

" 插入模式移动光标alt + 方向键, win 版本
inoremap <M-j> <Down>
inoremap <M-k> <Up>
inoremap <M-h> <Left>
inoremap <M-l> <Right>

" 移动分割窗口
nmap <C-j> <C-W>j
nmap <C-k> <C-W>k
nmap <C-h> <C-W>h
nmap <C-l> <C-W>l

" 正常模式下 调整分割窗口alt + 方向键
nnoremap ∆ :resize +5<cr>
nnoremap ˚ :resize -5<cr>
nnoremap ˙ :vertical resize -5<cr>
nnoremap ¬ :vertical resize +5<cr>

" 打开各种程序
map <leader>cmd :exe has("mac")==1 ? ':silent !open -a terminal' : ':silent !start cmd'
map <leader>yyy :exe has("mac")==1 ? ':silent !open -a NeteaseMusic' : ':silent !start D:\Software\CloudMusic\neteasemusic.exe'

" }}}

" Functions {{{
"function! GoogleSearch()
"    let searchterm = getreg("g")
"    if has("mac")
"        exec ':silent !open -a "Google Chrome" "http://google.com/search?q=' . searchterm .'"'
"    else
"        exec ':silent !start C:\Chrome "http://google.com/search?q=' . searchterm . '"'
"endfunction

"vnoremap <F6> "gy<Esc>:call GoogleSearch()<CR>
function! SetFont(os, size)
    if a:os == "mac"
        exe ':set guifont=Monaco:'.a:size
        echo 'Font was set to Monaco with size:'.a:size
    elseif a:os == "win"
        exe ':set guifont=Inconsolata:'.a:size
        echo 'Font was set to Inconsolata with size:'.a:size
    endif
endfunction

function! GetOS()
    let osname = "mac"
    if has("gui_running")
        if has("gui_gtk3")
            let osname = "else"
        elseif has("gui_win32")
            let osname = "win"
        elseif has("gui_macvim")
            let osname = "mac"
        endif
    endif
    return osname
endfunction

function! GetFtSize()
    let fontsize = "h16"
    if has("gui_win32")
        let height = 1080
    else
        let height = system("osascript -e 'tell application \"Finder\" to get bounds of window of desktop' | cut -d ' ' -f 4")
    if height > 1200
        let fontsize = "h18"
    elseif height > 900
        let fontsize = "h16"
    else
        let fontsize = "h14"
    endif
    return fontsize
endfunction

function! <SID>StripTrailingSpaces()
    let l = line(".")
    let c = col(".")
:%s/\s\+$//e
    call cursor(l, c)
endfunction
"}}}

