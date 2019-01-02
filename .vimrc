if has('vim_starting')
  set nocompatible               " Be iMproved
endif

command! Edit :tabedit ~/.vimrc
command! Reload :so ~/.vimrc

syntax on
filetype plugin indent on

" augroup init (from tyru's vimrc)
augroup vimrc
  autocmd!
augroup END

command!
      \ -bang -nargs=*
      \ MyAutoCmd
      \ autocmd<bang> vimrc <args>

MyAutoCmd BufNewFile,BufRead *.{md,mdwn,mkd,mkdn,mark*} set filetype=markdown
MyAutoCmd FileType markdown setlocal noautoindent nosmartindent

"matchit読み込み
source $VIMRUNTIME/macros/matchit.vim
set matchpairs+={:}

" display
" ----------------------
set t_Co=256
scriptencoding utf-8

MyAutoCmd Colorscheme * highlight IdeographicSpace term=underline ctermbg=DarkGreen guibg=DarkGreen
" MyAutoCmd VimEnter,WinEnter * match IdeographicSpace /　/
set background=dark
" colorscheme darkblue
" colorscheme default
colorscheme slate
" colorscheme torte

" http://kannokanno.hatenablog.com/entry/2013/05/08/110557
set completeopt=menuone

"""""""インサートモードでカーソルの形を変える""""""""""
" Changing cursor shape per mode
if exists('$TMUX')
  let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
  let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
else
  let &t_SI = "\<Esc>]50;CursorShape=1\x7"
  let &t_EI = "\<Esc>]50;CursorShape=0\x7"
endif

nmap <TAB> %
vmap <TAB> %

MyAutoCmd CmdwinEnter * call s:init_cmdwin()
function! s:init_cmdwin() abort
  inoremap <buffer><expr><CR>  pumvisible() ? "\<C-y>" : "\<CR>"
  " Completion.
  inoremap <buffer><expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
  startinsert!
endfunction

set number " show line number
" set relativenumber
set showmode " show mode
set title " show filename
set ruler
set list " show eol,tab,etc...
set listchars=eol:¬,tab:▸▸,trail:-,extends:»,precedes:«,nbsp:%
set laststatus=2
set wrap
set wrapmargin=2

set showtabline=2 " 常にタブラインを表示

" The prefix key.
nnoremap    [Tag]   <Nop>
nmap    t [Tag]
" Tab jump
for n in range(1, 9)
  execute 'nnoremap <silent> [Tag]'.n  ':<C-u>tabnext'.n.'<CR>'
endfor
" t1 で1番左のタブ、t2 で1番左から2番目のタブにジャンプ

map <silent> [Tag]t :tablast <bar> tabnew<CR>
" tt 新しいタブを一番右に作る
map <silent> [Tag]k :tabclose<CR>
" tk タブを閉じる
map <silent> [Tag]n :tabnext<CR>
" tn 次のタブ
map <silent> [Tag]p :tabprevious<CR>
" tp 前のタブ

" edit
" ----------------------
"http://qiita.com/Kta-M/items/9a386c01db150dc90fc2
set iskeyword +=@-@,!,?,-

" 括弧を入力した時にカーソルが移動しないように設定
set matchtime=0
"ESCのタイムアウトを早くする
set timeout timeoutlen=1000 ttimeoutlen=75
set encoding=utf-8
set fileencodings=utf-8,iso-2022-jp,cp932,sjis,euc-jp
set fileencoding=utf-8
set termencoding=utf-8
set noswapfile
set autoindent
set smartindent
set expandtab
set smarttab
set tabstop=2 shiftwidth=2
set softtabstop=0
set showmatch " show mactch brace
set wildmenu
set wildmode=longest,list:full
set autoread
set hidden
set showcmd
set backspace=indent,eol,start
set ambiwidth=double

nnoremap p p=`]`]

nnoremap + <C-a>
nnoremap - <C-x>

MyAutoCmd BufEnter * setlocal formatoptions-=ro


" vimにcoffeeファイルタイプを認識させる
MyAutoCmd BufRead *.coffee setlocal filetype=coffee
MyAutoCmd BufRead *.coffee nnoremap <buffer> <Leader>cf :CoffeeWatch watch vert<CR>

MyAutoCmd BufEnter *.schema setlocal filetype=ruby

set nocursorline
set nocursorcolumn

MyAutoCmd FileType gitcommit setlocal cursorline

hi MatchParen ctermbg=1

nnoremap <CR> o<ESC>


" OSのクリップボードを使う
set clipboard+=unnamed

""""""""""gf(Goto File)拡張"""""""""""

" 縦分割版gf
" nnoremap gv :<C-u>vsplit<CR>gf
" " 横分割
" nnoremap gs :<C-u>split<CR>gf
" 新規タブ

"""""""""""""""mark""""

" mark auto reg
" http://saihoooooooo.hatenablog.com/entry/2013/04/30/001908
if !exists('g:markrement_char')
  let g:markrement_char = [
        \     'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm',
        \     'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z'
        \ ]
endif
nnoremap <silent>m :<C-u>call <SID>AutoMarkrement()<CR>

function! s:AutoMarkrement()
  if !exists('b:markrement_pos')
    let b:markrement_pos = 0
  else
    let b:markrement_pos = (b:markrement_pos + 1) % len(g:markrement_char)
  endif
  execute 'mark' g:markrement_char[b:markrement_pos]
  echo 'marked' g:markrement_char[b:markrement_pos]
endfunction

"""""""""""""""folding""""
" set foldmethod=indent
" set foldnestmax=4
" set foldlevel=2
" set foldtext=foldCC#foldtext()
" " let g:foldCCtext_tail = 'v:foldend-v:foldstart+1'
" " let g:foldCCtext_enable_autofdc_adjuster = 1
" set foldcolumn=0
"
" MyAutoCmd FileType vim setlocal foldlevel=0
" MyAutoCmd Filetype ruby,coffeescript,cpp setlocal foldlevel=2
" MyAutoCmd Filetype ruby,coffeescript setlocal foldnestmax=2
" MyAutoCmd FileType haml setlocal foldmethod=manual
"
" nnoremap <expr>l  foldclosed('.') != -1 ? ':call <SID>smart_foldopener()<CR>' : 'l'
" " nnoremap <expr>h foldlevel('.') != 0 ? ':call <SID>smart_foldcloser()<CR>' : 'h'
"
" function! s:smart_foldopener() "{{{
"   let before = foldlevel('.')
"
"   " if before > 2
"   " norm! zO
"   " return
"   " endif
"
"   norm! zo
"
"   if foldlevel('.') != foldclosedend('.')
"     norm! j
"   endif
"
"   let after = foldlevel('.')
"   if before > after
"     norm! k
"   endif
" endfunction "}}}
"
" nnoremap <C-_> :<C-u>call <SID>smart_foldcloser()<CR>
" nnoremap z<C-_>    zMzvzc
" nnoremap  z[     :<C-u>call <SID>put_foldmarker(0)<CR>
" nnoremap  z]     :<C-u>call <SID>put_foldmarker(1)<CR>
" nnoremap <silent>z0    :<C-u>set foldlevel=<C-r>=foldlevel('.')<CR>
"
" function! s:smart_foldcloser() "{{{
"   if foldlevel('.') == 0
"     " norm! zM
"     return
"   endif
"
"   let foldc_lnum = foldclosed('.')
"   norm! zc
"   if foldc_lnum == -1
"     return
"   endif
"
"   if foldclosed('.') != foldc_lnum
"     return
"   endif
"   " norm! zM
" endfunction
" "}}}
"
" function! s:put_foldmarker(foldclose_p) "{{{
"   let crrstr = getline('.')
"   let padding = crrstr=='' ? '' : crrstr=~'\s$' ? '' : ' '
"   let [cms_start, cms_end] = ['', '']
"   let outside_a_comment_p = synIDattr(synID(line('.'), col('$')-1, 1), 'name') !~? 'comment'
"   if outside_a_comment_p
"     let cms_start = matchstr(&cms,'\V\s\*\zs\.\+\ze%s')
"     let cms_end = matchstr(&cms,'\V%s\zs\.\+')
"   endif
"   let fmr = split(&fmr, ',')[a:foldclose_p]. (v:count ? v:count : '')
"   exe 'norm! A'. padding. cms_start. fmr. cms_end
" endfunction
" "}}}


" 保存時に行末の空白を除去する
MyAutoCmd BufWritePre * :%s/\s\+$//ge
" 保存時にtabをスペースに変換する
MyAutoCmd BufWritePre * :%s/\t/  /ge
" .vimrc 保存時に自動で再読み込み
" MyAutoCmd BufWritePost ~/.vimrc   :so ~/.vimrc


" move
nnoremap <silent> j gj
nnoremap <silent> gj j
nnoremap <silent> k gk
nnoremap <silent> gk k
nnoremap <silent> $ g$
nnoremap <silent> g$ $
vnoremap <silent> j gj
vnoremap <silent> gj j
vnoremap <silent> k gk
vnoremap <silent> gk k
vnoremap <silent> $ g$
vnoremap <silent> g$ $
" ----------------------
" window manage
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l
nnoremap <C-c> <C-w>c

" _ : Quick horizontal splits
nnoremap _  :sp<CR>

" | : Quick vertical splits
nnoremap <bar>  :vsp<CR>

set splitright

set scrolloff=5
" search
" ----------------------
set helplang=ja,en
set incsearch
set ignorecase
set smartcase
set visualbell
set t_vb=

" backup
" --------------------
" set backup
" set backupdir=~/.vim/vim_backup
" set swapfile
" set directory=~/.vim/vim_swap
" viminfo
" http://vimwiki.net/?%27viminfo%27
set viminfo='50,<1000,s100,:0,n~/.vim/viminfo
set undofile
set undodir=~/.vim/vim_undo

" key map
" --------------------
nnoremap Q <Nop>

" auto command
" --------------------
MyAutoCmd QuickFixCmdPost *grep* cwindow


if executable('ag')
  " Use Ag over Grep
  set grepprg=ag\ --nogroup\ --nocolor
endif

""""""""""Tag Jump拡張"""""""""""
nnoremap <C-]> g<C-]>
nnoremap <C-v><C-]> :vsp<CR>:exec('tjump '.expand('<cword>'))<CR>
nnoremap <C-t><C-]> :tabnew<CR>:exec('tjump '.expand('<cword>'))<CR>
nnoremap <C-w><C-]> :sp<CR>:exec('tjump '.expand('<cword>'))<CR>
" nmap <C-]> :vsp <CR>:exec("tag ".expand("<cword>"))<CR>
