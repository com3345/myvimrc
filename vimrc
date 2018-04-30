" Startup {{{
filetype plugin indent on 
" 根据平台和分辨率大小自动设置字体大小 
autocmd VimEnter * call GetEnv() | call SetFont(GetFtSize())
" vim折叠方式为marker
au FileType vim setlocal foldmethod=marker
" }}}

" General {{{
" 当vimrc保存时，重载它
au! BufWritePost $MYVIMRC source $MYVIMRC

set hlsearch
set nocompatible
set nobackup
set noundofile
set noswapfile
set history=1024
set autochdir "自动跳转到vim打开的文件所在的目录
set nobomb "不要bom头
set backspace=indent,eol,start "让退格键可以删除到上一行/缩进并可以超过插入模式插入的地方
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

"hi Terminal guibg=#ff0000

set splitbelow
set splitright
set guioptions-=T
set guioptions-=m
set guioptions-=L
set guioptions-=r
set guioptions-=b
set lines=99999 columns=99999
" }}}

" Vundle {{{
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'
Plugin 'szw/vim-g'
Plugin 'skywind3000/asyncrun.vim'
" ----- Ale ----- {{{
Plugin 'w0rp/ale'
le g:airline#extensions#ale#enabled = 1
let g:ale_set_loclist = 0
let g:ale_set_quickfix = 1
" }}}

" ----- NerdTree ----- {{{
Plugin 'scrooloose/nerdtree'

let NERDTreeIgnore=['\.idea$', '\.pyc$', '\.png$', '\.orig$']
let NERDTreeBookmarksFile=$VIM . '/NERDTreeBookmarks'
let NERDTreeMinimalUI=1
let NERDTreeShowBookmarks=1
let g:NERDTreeWinPos='right'
if exists('g:NERDTreeWinPos')
    au vimenter * silent NERDTree | wincmd p
endif
"  }}}

" ----- Jedi-Vim ----- {{{
Plugin 'davidhalter/jedi-vim'
" }}}

" ----- Airline ----- {{{
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
set smartindent
set tabstop=4
set softtabstop=4
set shiftwidth=4
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
map <leader><ESC> :noh<cr>
nmap <leader>s :source $MYVIMRC<cr>
nmap <leader>e :e $MYVIMRC<cr>
noremap <leader>t :exe g:env == "DARWIN" ? ':e $HOME/.vim/todo' : ':e $HOME/vimfiles/todo'<CR>

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

" 在窗口中切换
nmap <C-j> <C-W>j
nmap <C-k> <C-W>k
nmap <C-h> <C-W>h
nmap <C-l> <C-W>l

" 正常模式下 调整分割窗口alt + 方向键
nnoremap ∆ :resize +5<cr>
nnoremap ˚ :resize -5<cr>
nnoremap ˙ :vertical resize -5<cr>
nnoremap ¬ :vertical resize +5<cr>
nnoremap <M-j> :resize +5<cr>
nnoremap <M-k> :resize -5<cr>
nnoremap <M-h> :vertical resize -5<cr>
nnoremap <M-l> :vertical resize +5<cr>


" 打开各种程序
noremap <leader>cmd :exe g:env == "DARWIN" ? '!open -a terminal' : '!start cmd'<CR><CR>
map <leader>yyy :exe g:env == "DARWIN" ? ':silent !open -a NeteaseMusic' : ':silent !start D:\Software\Netease\CloudMusic\cloudmusic.exe'<CR><CR>

" }}}

" Functions {{{
function! GetEnv()
    if !exists('g:env')
        if has('win64') || has('win32') || has('win16')
        let g:env = 'WINDOWS'
        else
            let g:env = toupper(substitute(system('uname'), '\n', '', ''))
        endif
    endif
endfunction

function! SetFont(size)
    if g:env == "DARWIN"
        exe ':set guifont=Monaco:'.a:size
        echo 'Font was set to Monaco with size:'.a:size
    else
        exe ':set guifont=Inconsolata:'.a:size
        echo 'Font was set to Inconsolat:'.a:size
    endif
endfunction

function! GetFtSize()
    let fontsize = "h16"
    if g:env != "DARWIN" 
        let height = 1080
    else
        let height = system("osascript -e 'tell application \"Finder\" to get bounds of window of desktop' | cut -d ' ' -f 4")
    endif
    if height > 1200
        let fontsize = "h16"
    elseif height > 900
        let fontsize = "h14"
    else
        let fontsize = "h12"
    endif
    return fontsize
endfunction
"}}}

