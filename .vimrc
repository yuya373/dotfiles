" ------------------------------------------------------------------------------
"
"   neobundle
" ------------------------------------------------------------------------------
"

command! Edit :tabedit ~/.vimrc
command! Reload :so ~/.vimrc

if has('vim_starting')
  set nocompatible               " Be iMproved
  set runtimepath+=~/.vim/bundle/neobundle.vim/
endif

call neobundle#rc()


" Let NeoBundle manage NeoBundle
NeoBundleFetch 'Shougo/neobundle.vim'

" Recommended to install
NeoBundle 'Shougo/vimproc', {
      \ 'build' : {
      \     'windows' : 'make -f make_mingw32.mak',
      \     'cygwin' : 'make -f make_cygwin.mak',
      \     'mac' : 'make -f make_mac.mak',
      \     'unix' : 'make -f make_unix.mak',
      \    },
      \ }

" My Bundles here:
" Refer to |:NeoBundle-examples|.
"
" Note: You don't set neobundle setting in .gvimrc!

" ...

NeoBundle 'Shougo/neobundle.vim'
NeoBundle 'VimClojure'
NeoBundle 'Shougo/vimshell'
NeoBundle 'Shougo/neocomplete'
NeoBundle 'Shougo/neosnippet'
NeoBundle 'scrooloose/syntastic'
NeoBundle 'scrooloose/nerdcommenter'
NeoBundle 'itchyny/lightline.vim'
NeoBundle 'surround.vim'
NeoBundle 'thinca/vim-quickrun'
NeoBundle 'https://github.com/kana/vim-smartinput'
NeoBundle "cohama/vim-smartinput-endwise"
NeoBundle 'https://github.com/vim-jp/vimdoc-ja'
NeoBundle 'tpope/vim-fugitive'
NeoBundle 'Lokaltog/vim-easymotion'
NeoBundle 'vim-scripts/vim-auto-save'
NeoBundle 'rking/ag.vim'
NeoBundle 'honza/vim-snippets'
NeoBundle 'Yggdroot/indentLine'
NeoBundle 'itchyny/thumbnail.vim'
NeoBundle 'szw/vim-tags'
NeoBundle 't9md/vim-choosewin'
NeoBundle 'Shougo/neosnippet-snippets'
NeoBundle 'cohama/agit.vim'
NeoBundle 'tpope/vim-repeat'
NeoBundle 'LeafCage/foldCC'
NeoBundle 'LeafCage/yankround.vim'
NeoBundle 'osyo-manga/vim-over'
NeoBundle 'AnsiEsc.vim'
NeoBundle 'tacroe/unite-mark'
NeoBundle 'moznion/hateblo.vim', {
      \ 'depends': ['mattn/webapi-vim', 'Shougo/unite.vim']
      \ }
NeoBundle 'airblade/vim-rooter'
NeoBundle 'taku25/subway'
NeoBundle 'scrooloose/nerdtree'
NeoBundle 'tpope/vim-bundler'
NeoBundle 'othree/html5.vim'
NeoBundle 'junegunn/vim-easy-align'

"""""""Unite""""""""""""
NeoBundle 'osyo-manga/unite-choosewin-actions'
NeoBundle 'h1mesuke/unite-outline'
NeoBundle 'Shougo/unite.vim'
NeoBundle 'Shougo/neomru.vim'
" NeoBundle 'Shougo/vimfiler'

"""""""ruby && rails""""
NeoBundle 'Keithbsmiley/rspec.vim'
NeoBundle 'tpope/vim-haml'
NeoBundle 'tpope/vim-rails'

"""""""js && coffee""""
NeoBundle 'kchmck/vim-coffee-script'
NeoBundle "vim-scripts/JavaScript-Indent"
NeoBundle "elzr/vim-json"

"""""""haskell""""""""
NeoBundle 'dag/vim2hs'
NeoBundle 'eagletmt/ghcmod-vim'
NeoBundle 'kana/vim-filetype-haskell'

"""""""markdown""""""""
NeoBundle 'rcmdnk/vim-markdown'
NeoBundle 'glidenote/memolist.vim'
NeoBundle 'kannokanno/previm'
NeoBundle 'tyru/open-browser.vim'

"""""""colorscheme""""""""
NeoBundle 'w0ng/vim-hybrid'
NeoBundle 'chriskempson/vim-tomorrow-theme'
NeoBundle 'ujihisa/unite-colorscheme'
NeoBundle 'altercation/vim-colors-solarized'
NeoBundle 'Railscasts-Theme-GUIand256color'
NeoBundle 'nanotech/jellybeans.vim'
NeoBundle 'jnurmine/Zenburn'
NeoBundle 'vim-scripts/twilight'
NeoBundle 'tomasr/molokai'


NeoBundleLazy 'alpaca-tc/neorspec.vim', {
      \ 'depends' : 'tpope/vim-rails',
      \ 'autoload' : {
      \   'commands' : [
      \       'RSpecAll', 'RSpecNearest', 'RSpecRetry',
      \       'RSpecCurrent', 'RSpec'
      \ ]}}
NeoBundleLazy 'tpope/vim-dispatch', { 'autoload' : {
      \ 'commands' : ['Dispatch', 'FocusDispatch', 'Start']
      \}}

NeoBundleLazy 'supermomonga/jazzradio.vim', { 'depends' : [ 'Shougo/unite.vim' ] }

if neobundle#tap('jazzradio.vim')
  call neobundle#config({
        \   'autoload' : {
        \     'unite_sources' : [
        \       'jazzradio'
        \     ],
        \     'commands' : [
        \       'JazzradioUpdateChannels',
        \       'JazzradioStop',
        \       {
        \         'name' : 'JazzradioPlay',
        \         'complete' : 'customlist,jazzradio#channel_id_complete'
        \       }
        \     ],
        \     'function_prefix' : 'jazzradio'
        \   }
        \ })
endif




" Brief help
" :NeoBundleList          - list configured bundles
" :NeoBundleInstall(!)    - install(update) bundles
" :NeoBundleClean(!)      - confirm(or auto-approve) removal of unused bundles

syntax enable
filetype plugin indent on
set synmaxcol=200

" Installation check.
NeoBundleCheck


" augroup init (from tyru's vimrc)
augroup vimrc
  autocmd!
augroup END

command!
      \ -bang -nargs=*
      \ MyAutoCmd
      \ autocmd<bang> vimrc <args>



" display
" ----------------------
set t_Co=256
scriptencoding utf-8

MyAutoCmd Colorscheme * highlight IdeographicSpace term=underline ctermbg=DarkGreen guibg=DarkGreen
MyAutoCmd VimEnter,WinEnter * match IdeographicSpace /　/

set background=dark
colorscheme solarized

"""""""インサートモードでカーソルの形を変える""""""""""
" Changing cursor shape per mode
if exists('$TMUX')
  let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
  let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
else
  let &t_SI = "\<Esc>]50;CursorShape=1\x7"
  let &t_EI = "\<Esc>]50;CursorShape=0\x7"
endif

set number " show line number
" set relativenumber
set showmode " show mode
set title " show filename
set ruler
set list " show eol,tab,etc...
set listchars=eol:¬,tab:▸▸,trail:-,extends:»,precedes:«,nbsp:%
set laststatus=2
set wrap
" highlight turn gui=standout cterm=standout
" call matchadd("turn", '.\%>81v')
set wrapmargin=2

" tab
" ----------------------

" Anywhere SID.
" function! s:SID_PREFIX()
" return matchstr(expand('<sfile>'), '<SNR>\d\+_\zeSID_PREFIX$')
" endfunction

" Set tabline.
" function! s:my_tabline()  "{{{
" let s = ''
" for i in range(1, tabpagenr('$'))
" let bufnrs = tabpagebuflist(i)
" let bufnr = bufnrs[tabpagewinnr(i) - 1]  " first window, first appears
" let no = i  " display 0-origin tabpagenr.
" let mod = getbufvar(bufnr, '&modified') ? '!' : ' '
" let title = fnamemodify(bufname(bufnr), ':t')
" let title = '[' . title . ']'
" let s .= '%'.i.'T'
" let s .= '%#' . (i == tabpagenr() ? 'TabLineSel' : 'TabLine') . '#'
" let s .= no . ':' . title
" let s .= mod
" let s .= '%#TabLineFill# '
" endfor
" let s .= '%#TabLineFill#%T%=%#TabLine#'
" return s
" endfunction "}}}
" let &tabline = '%!'. s:SID_PREFIX() . 'my_tabline()'
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
" tc 新しいタブを一番右に作る
map <silent> T :tabclose<CR>
" T タブを閉じる
map <silent> [Tag]n :tabnext<CR>
" tn 次のタブ
map <silent> [Tag]p :tabprevious<CR>
" tp 前のタブ






" edit
" ----------------------
"ESCのタイムアウトを早くする
set timeout timeoutlen=1000 ttimeoutlen=75
set encoding=UTF-8
set fileencoding=UTF-8
set termencoding=UTF-8
set noswapfile
set autoindent
set smartindent
set expandtab
set smarttab
set tabstop=2 shiftwidth=2
set softtabstop=0
set showmatch " show mactch brace
set wildmenu
set wildmode=list,full
set autoread
set hidden
set showcmd
set backspace=indent,eol,start
set ambiwidth=double

nnoremap p p=`]`]
inoremap <silent> <C-j> <ESC>

MyAutoCmd BufEnter * setlocal formatoptions-=ro


" vimにcoffeeファイルタイプを認識させる
MyAutoCmd BufRead,BufNewFile,BufReadPre *.coffee   set filetype=coffee
MyAutoCmd BufRead,BufNewFile,BufReadPre *.coffee nnoremap <Leader>cf :CoffeeWatch watch vert<CR>

set cursorline
set nocursorcolumn
" set nocursorline

hi MatchParen ctermbg=1

nnoremap <CR> o<ESC>
map <C-j> <Esc>

" set formatoptions=qrn1
" if v:version >= 730
" set colorcolumn=85 "色づけ
" endif

" nnoremap <Leader>a :Ag<SPACE>


" OSのクリップボードを使う
set clipboard+=unnamed
" set clipboard=autoselect

""""""""""gf(Goto File)拡張"""""""""""

" 縦分割版gf
nnoremap gv :vertical wincmd f<CR>
" 横分割
nnoremap gs <C-w>f
" 新規タブ
nnoremap gt <C-w>gf

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

set foldmethod=indent
set foldnestmax=4
set foldlevel=2
set foldtext=foldCC#foldtext()
let g:foldCCtext_tail = 'v:foldend-v:foldstart+1'
" let g:foldCCtext_enable_autofdc_adjuster = 1
set foldcolumn=3

MyAutoCmd Filetype ruby,coffeescript setlocal foldlevel=1
MyAutoCmd Filetype ruby,coffeescript setlocal foldnestmax=2
MyAutoCmd FileType haml setlocal foldmethod=manual

nnoremap <expr>l  foldclosed('.') != -1 ? ':call <SID>smart_foldopener()<CR>' : 'l'
" nnoremap <expr>h foldlevel('.') != 0 ? ':call <SID>smart_foldcloser()<CR>' : 'h'

function! s:smart_foldopener() "{{{
  let before = foldlevel('.')

  " if before > 2
  " norm! zO
  " return
  " endif

  norm! zo

  if foldlevel('.') != foldclosedend('.')
    norm! j
  endif

  let after = foldlevel('.')
  if before > after
    norm! k
  endif
endfunction "}}}

nnoremap <C-_> :<C-u>call <SID>smart_foldcloser()<CR>
nnoremap z<C-_>    zMzvzc
nnoremap  z[     :<C-u>call <SID>put_foldmarker(0)<CR>
nnoremap  z]     :<C-u>call <SID>put_foldmarker(1)<CR>
nnoremap <silent>z0    :<C-u>set foldlevel=<C-r>=foldlevel('.')<CR>

function! s:smart_foldcloser() "{{{
  if foldlevel('.') == 0
    " norm! zM
    return
  endif

  let foldc_lnum = foldclosed('.')
  norm! zc
  if foldc_lnum == -1
    return
  endif

  if foldclosed('.') != foldc_lnum
    return
  endif
  " norm! zM
endfunction
"}}}

function! s:put_foldmarker(foldclose_p) "{{{
  let crrstr = getline('.')
  let padding = crrstr=='' ? '' : crrstr=~'\s$' ? '' : ' '
  let [cms_start, cms_end] = ['', '']
  let outside_a_comment_p = synIDattr(synID(line('.'), col('$')-1, 1), 'name') !~? 'comment'
  if outside_a_comment_p
    let cms_start = matchstr(&cms,'\V\s\*\zs\.\+\ze%s')
    let cms_end = matchstr(&cms,'\V%s\zs\.\+')
  endif
  let fmr = split(&fmr, ',')[a:foldclose_p]. (v:count ? v:count : '')
  exe 'norm! A'. padding. cms_start. fmr. cms_end
endfunction
"}}}


" 保存時に行末の空白を除去する
MyAutoCmd BufWritePre *[^(markdown)] :%s/\s\+$//ge
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
" nnoremap <C-o> <C-w>o

" imap <C-j> <Down>
" imap <C-K> <Up>
" imap <C-h> <Left>
" imap <C-l> <Right>
" imap <C-i> <Esc>I
" imap <C-a> <Esc>A
set scrolloff=5
" search
" ----------------------
set helplang=ja,en
set incsearch
set ignorecase
set smartcase
set hlsearch
" Esc Esc でハイライトOFF
nnoremap <Esc><Esc> :<C-u>set nohlsearch<Return>

" Localize search options.
" MyAutoCmd WinLeave *
" \     let b:vimrc_pattern = @/
" \   | let b:vimrc_hlsearch = &hlsearch
" MyAutoCmd WinEnter *
" \     let @/ = get(b:, 'vimrc_pattern', @/)
" \   | let &l:hlsearch = get(b:, 'vimrc_hlsearch', &l:hlsearch)
" 「/」「?」「*」「#」が押されたらハイライトをON にしてから「/」「?」「*」「#」
nnoremap / :<C-u>set hlsearch<Return>/
nnoremap ? :<C-u>set hlsearch<Return>?
nnoremap * :<C-u>set hlsearch<Return>*
nnoremap # :<C-u>set hlsearch<Return>#

" no bell
"
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

" key map
" --------------------
nnoremap Q <Nop>

" auto command
" --------------------
MyAutoCmd QuickFixCmdPost *grep* cwindow

" Plugin setting
" --------------------

" NEED Commenter
let NERDShutUp = 1 "no alart undfined filetype

"------------------------------------
" vim-rails
"------------------------------------
""{{{
"有効化
let g:rails_default_file='config/database.yml'
let g:rails_level = 3
let g:rails_mappings=1
let g:rails_modelines=0
let g:rails_some_option = 1
let g:rails_statusline = 1
let g:rails_subversion=0
let g:rails_syntax = 1
let g:rails_url='http://localhost:3000'
" function! SetUpRailsSetting()
" nnoremap <buffer><Space>r :R<CR>
" nnoremap <buffer><Space>a :A<CR>
" nnoremap <buffer><Space>m :Rmodel<Space>
" nnoremap <buffer><Space>c :Rcontroller<Space>
" nnoremap <buffer><Space>v :Rview<Space>
" nnoremap <buffer><Space>p :Rpreview<CR>
" endfunction
" aug MyAutoCmd
" au User Rails call SetUpRailsSetting()
" aug END
" aug RailsDictSetting
" au!
" aug END
" autocmd User Rails.view*                 NeoSnippetSource ~/.vim/snippet/ruby.rails.view.snip
" autocmd User Rails.controller*           NeoSnippetSource ~/.vim/snippet/ruby.rails.controller.snip
" autocmd User Rails/db/migrate/*          NeoSnippetSource ~/.vim/snippet/ruby.rails.migrate.snip
" autocmd User Rails/config/routes.rb      NeoSnippetSource ~/.vim/snippet/ruby.rails.route.snip


"""""""""""""""vimfiler""""""""""""

let g:vimfiler_safe_mode_by_default = 0
let g:vimfiler_as_default_explorer = 1
" Like Textmate icons.
" let g:vimfiler_tree_leaf_icon = ' '
" let g:vimfiler_tree_opened_icon = '▾'
" let g:vimfiler_tree_closed_icon = '▸'
" let g:vimfiler_file_icon = '-'
" let g:vimfiler_marked_file_icon = '*'
" nmap <C-n>  :VimFilerBufferDir -split -horizontal -toggle -quit<CR>

""" unite.vim
" 起動時にインサートモードで開始
let g:unite_enable_start_insert = 1
let g:unite_enable_short_source_names = 1
" let g:unite_winheight = 10
" let g:unite_split_rule = 'botright'
" let g:unite_prompt = '▸▸ '
"  " unite grep に ag(The Silver Searcher) を使う
if executable('ag')
  let g:unite_source_grep_command = 'ag'
  let g:unite_source_grep_default_opts = '--nogroup --nocolor --column'
  let g:unite_source_grep_recursive_opt = ''
endif
" 大文字小文字を区別しない
let g:unite_enable_ignore_case = 1
let g:unite_enable_smart_case = 1
" ファイルを開く場合のデフォルトアクションを choosewin にする
call unite#custom#default_action('file' , 'choosewin/open')
call unite#custom#default_action('buffer' , 'choosewin/open')
call unite#custom#default_action('grep' , 'choosewin/open')

" The prefix key.
nnoremap    [unite]   <Nop>
nmap    ,u [unite]

" アウトライン
nnoremap <silent> [unite]o  :<C-u>Unite outline<CR>
nnoremap [unite]o :Unite -vertical -winwidth=40 outline<Return>
" マッピング
" nnoremap <silent> [unite]ma :<C-u>Unite mapping<CR>
" バッファ一覧
nnoremap <silent> [unite]b :<C-u>Unite buffer<CR>
" レジスタ一覧
nnoremap <silent> [unite]p :<C-u>Unite -buffer-name=register register<CR>
" ヤンク履歴
nnoremap <silent> [unite]y :<C-u>Unite yankround<CR>
" 最近使用したファイル一覧
nnoremap <silent> [unite]u :<C-u>Unite file_mru<CR>
" 常用セット
" nnoremap <silent> [unite]u :<C-u>Unite buffer file_mru<CR>
" 全部乗せ
" nnoremap <silent> [unite]a :<C-u>Unite -buffer-name=files buffer file_mru bookmark file<CR>
" ctrlp風
" let g:unite_source_file_rec_max_cache_files = 10000
" let g:unite_source_file_rec_min_cache_files = 100
" nnoremap <C-p> :Unite -start-insert -winheight=10 -direction=botright file_rec/async<cr>
" call unite#custom#source('file_rec/async', 'ignore_pattern', '\(^\.git\|png\|gif\|jpeg\|jpg\)$')

nnoremap <silent> <C-p> :<C-u>Unite -start-insert file_rec/async:!<CR>
" nnoremap <C-p> :<C-u>execute
      " \ 'Unite'
      " \ '-start-insert'
      " \ 'buffer file_mru'
      " \ 'file:'.fnameescape(expand('%:p:h'))
      " \ 'file_rec:!:'.fnameescape(expand('%:p:h'))
      " \ <CR>

function! s:cd_root_and_unite(...)
  let args = join(a:000, ' ')
  execute 'Rooter'
  execute 'Unite'.' '.args
endfunction
command! -nargs=* RootAndUnite call s:cd_root_and_unite(<f-args>)
" ファイル一覧
nnoremap <silent> [unite]f :UniteWithBufferDir file file/new directory/new -buffer-name=files<CR>
nnoremap <silent> [unite]c :RootAndUnite file file/new directory/new -input=app/controllers/ -buffer-name=controllers<CR>
nnoremap <silent> [unite]m :RootAndUnite file file/new directory/new -input=app/models/ -buffer-name=models<CR>
nnoremap <silent> [unite]d :RootAndUnite file file/new directory/new -input=app/decorators/ -buffer-name=decorators<CR>
nnoremap <silent> [unite]v :RootAndUnite file file/new directory/new -input=app/views/ -buffer-name=views<CR>
nnoremap <silent> [unite]j :RootAndUnite file file/new directory/new -input=app/assets/javascripts/ -buffer-name=js<CR>
nnoremap <silent> [unite]a :RootAndUnite file file/new directory/new -input=app/ -buffer-name=app<CR>
nnoremap <silent> [unite]r :UniteWithProjectDir file file/new directory/new -buffer-name=root<CR>
nnoremap <silent> [unite]s :RootAndUnite file file/new directory/new -input=spec/ -buffer-name=spec<CR>
" grep検索
nnoremap <silent> ,g  :<C-u>Unite grep:. -buffer-name=search-buffer<CR>
" カーソル位置の単語をgrep検索
nnoremap <silent> ,cg :<C-u>Unite grep:. -buffer-name=search-buffer<CR><C-R><C-W><CR>
" grep検索結果の再呼出
nnoremap <silent> ,r  :<C-u>UniteResume search-buffer<CR>

"mark一覧
nnoremap <silent> ,m :<C-u>Unite mark<CR>


MyAutoCmd FileType unite call s:unite_my_settings()

function! s:unite_my_settings()
  " 単語単位からパス単位で削除するように変更
  imap <buffer> <C-w> <Plug>(unite_delete_backward_path)
  " ESCキーを2回押すと終了する
  nmap <buffer> <ESC><ESC> <Plug>(unite_all_exit)
  imap <buffer> <ESC><ESC> <Plug>(unite_exit)
  let unite = unite#get_current_unite()
  nnoremap <buffer> <expr> <C-f> unite#do_action('choosewin/split')
  inoremap <buffer> <expr> <C-f> unite#do_action('choosewin/split')
  nnoremap <buffer> <expr> <C-v> unite#do_action('choosewin/vsplit')
  inoremap <buffer> <expr> <C-v> unite#do_action('choosewin/vsplit')
  " dwm.vim で開く
  " nnoremap <silent> <buffer> <expr> <c-o> unite#do_action('dwm_new')
  " inoremap <silent> <buffer> <expr> <c-o> unite#do_action('dwm_new')
endfunction



"""""""""""""""""""""""""neosnippet
" Plugin key-mappings.
imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)
xmap <C-k>     <Plug>(neosnippet_expand_target)

" SuperTab like snippets behavior.
imap <expr><TAB> neosnippet#expandable_or_jumpable() ?
      \ "\<Plug>(neosnippet_expand_or_jump)"
      \: pumvisible() ? "\<C-n>" : "\<TAB>"
smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
      \ "\<Plug>(neosnippet_expand_or_jump)"
      \: "\<TAB>"

" For snippet_complete marker.
if has('conceal')
  set conceallevel=2 concealcursor=i
endif
" Tell Neosnippet about the other snippets
let g:neosnippet#snippets_directory='~/.vim/bundle/vim-snippets/snippets'


""""""""""syntastic"""""""""""""""

""USE RUBOCOP
let g:syntastic_mode_map = { 'mode': 'passive',
      \ 'active_filetypes': ['ruby'] }
let g:syntastic_ruby_checkers = ['rubocop']
let g:syntastic_ruby_rubocop_args = '--rails'
" let g:syntastic_quiet_messages = {'level': 'warnings'}

"""""""""""vim-easymotion""""""""""""

let g:EasyMotion_do_mapping = 0
let g:EasyMotion_enter_jump_first = 1

" デフォルトだと<Leader><Leader>となってるprefixキーを変更
let g:EasyMotion_leader_key = '\'

" 候補選択: 候補が最初から2キー表示されるので大文字や打ちにくい文字は全面的に消す
" なお、最後の数文字が2キーの時の最初のキーになるので打ちやすいものを選ぶとよさそうです。
let g:EasyMotion_keys='hklyuiopnm,qwertzxcvbasdgjf;'
let g:EasyMotion_do_shade = 1


" 拡張版機能"{{{

" もっともよく使うであろう'<Leadr><Leader>s'motion をsに割り当て
nmap s <Plug>(easymotion-s)
xmap s <Plug>(easymotion-s)
" surround.vimと被らないように
omap z <Plug>(easymotion-s)

map f <Plug>(easymotion-bd-fl)

" keep cursor column
let g:EasyMotion_startofline = 0

" smartcase
let g:EasyMotion_smartcase = 1


"""""""NeoComplete""""""""""
"""""""""""""""""""""""""""""

"Note: This option must set it in .vimrc(_vimrc).  NOT IN .gvimrc(_gvimrc)!
" Disable AutoComplPop.
let g:acp_enableAtStartup = 0
" Use neocomplete.
let g:neocomplete#enable_at_startup = 1
" Use smartcase.
let g:neocomplete#enable_smart_case = 1
" Set minimum syntax keyword length.
let g:neocomplete#sources#syntax#min_keyword_length = 3
let g:neocomplete#lock_buffer_name_pattern = '\*ku\*'

" Define dictionary.
let g:neocomplete#sources#dictionary#dictionaries = {
      \ 'default' : '',
      \ 'vimshell' : $HOME.'/.vimshell_hist',
      \ 'scheme' : $HOME.'/.gosh_completions'
      \ }

" Define keyword.
if !exists('g:neocomplete#keyword_patterns')
  let g:neocomplete#keyword_patterns = {}
endif
let g:neocomplete#keyword_patterns['default'] = '\h\w*'

" Plugin key-mappings.
inoremap <expr><C-g>     neocomplete#undo_completion()
"inoremap <expr><C-l>     neocomplete#complete_common_string()

" Recommended key-mappings.
" <CR>: close popup and save indent.
" imap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
" function! s:my_cr_function()
" " For no inserting <CR> key.
" return pumvisible() ? neocomplete#close_popup() : "\<CR>"
" endfunction
imap <expr> <CR> pumvisible() ?
      \ neocomplete#close_popup() : "\<Plug>(smartinput_CR)"

" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<S-TAB>"
" <C-h>, <BS>: close popup and delete backword char.
imap <expr><C-h> neocomplete#smart_close_popup()."\<Plug>(smartinput_C-h)"
imap <expr><BS> neocomplete#smart_close_popup()."\<Plug>(smartinput_BS)"
" inoremap <expr><C-o>  neocomplete#close_popup()
inoremap <expr><C-e>  neocomplete#cancel_popup()
" Close popup by <Space>.
"inoremap <expr><Space> pumvisible() ? neocomplete#close_popup() : "\<Space>"




" Enable omni completion.
MyAutoCmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
MyAutoCmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
MyAutoCmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
MyAutoCmd FileType python setlocal omnifunc=pythoncomplete#Complete
MyAutoCmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

" Enable heavy omni completion.
" if !exists('g:neocomplete#sources#omni#input_patterns')
" let g:neocomplete#sources#omni#input_patterns = {}
" endif
"let g:neocomplete#sources#omni#input_patterns.php = '[^.
"\t]->\h\w*\|\h\w*::'
"let g:neocomplete#sources#omni#input_patterns.c = '[^.[:digit:]
"*\t]\%(\.\|->\)'
"let g:neocomplete#sources#omni#input_patterns.cpp = '[^.[:digit:]
"*\t]\%(\.\|->\)\|\h\w*::'

" For perlomni.vim setting.
" https://github.com/c9s/perlomni.vim
" let g:neocomplete#sources#omni#input_patterns.perl = '\h\w*->\h\w*\|\h\w*::'
let g:neocomplete#force_overwrite_completefunc = 1

"""""""""indentLine""""""""""
"""""""""""""""""""""""""""""
let g:indentLine_faster=1
let g:indentLine_color_term = 239
let g:indentLine_color_gui = '#A4E57E'
" let g:indentLine_char = '┊'
" let g:indentLine_char = '▸'
let g:indentLine_showFirstIndentLevel = 2
nnoremap <Leader>ig :IndentLinesToggle<CR>

""""""""""vim-smartinput"""""""""""""""
call smartinput#map_to_trigger('i', '<Space>', '<Space>', '<Space>')
call smartinput#define_rule({
      \   'at'    : '(\%#)',
      \   'char'  : '<Space>',
      \   'input' : '<Space><Space><Left>',
      \   })

call smartinput#define_rule({
      \   'at'    : '( \%# )',
      \   'char'  : '<BS>',
      \   'input' : '<Del><BS>',
      \   })
call smartinput#define_rule({
      \   'at'    : '{\%#}',
      \   'char'  : '<Space>',
      \   'input' : '<Space><Space><Left>',
      \   })

call smartinput#define_rule({
      \   'at'    : '{ \%# }',
      \   'char'  : '<BS>',
      \   'input' : '<Del><BS>',
      \   })

" call smartinput#define_rule({
" \   'at'    : '[\%#]',
" \   'char'  : '<Space>',
" \   'input' : '<Space><Space><Left>',
" \   })

" call smartinput#define_rule({
" \   'at'    : '[ \%# ]',
" \   'char'  : '<BS>',
" \   'input' : '<Del><BS>',
" \   })

call smartinput#map_to_trigger('i', '#', '#', '#')
call smartinput#define_rule({
      \   'at'       : '"\%#"',
      \   'char'     : '#',
      \   'input'    : '#{}<Left>',
      \   'filetype' : ['ruby'],
      \})

" call smartinput#map_to_trigger('i', '<Bar>', '<Bar>', '<Bar>')
" call smartinput#define_rule({
" \   'at' : '\({\|\<do\>\)\s*\%#',
" \   'char' : '<Bar>',
" \   'input' : '<Bar><Bar><Left>',
" \   'filetype' : ['ruby'],
" \ })



call smartinput_endwise#define_default_rules()

call smartinput#map_to_trigger('i', '<Plug>(smartinput_BS)',
      \                        '<BS>',
      \                        '<BS>')
call smartinput#map_to_trigger('i', '<Plug>(smartinput_C-h)',
      \                        '<BS>',
      \                        '<C-h>')
call smartinput#map_to_trigger('i', '<Plug>(smartinput_CR)',
      \                        '<Enter>',
      \                        '<Enter>')

"""""""""""NERD COMMENTER""""""""""""
let NERDSpaceDelims = 1
nmap ,, <Plug>NERDCommenterToggle
vmap ,, <Plug>NERDCommenterToggle

""""""""""""""""thumbnail"""""""""""""""""""""""

nnoremap <Leader>t :Thumbnail<CR>

""""""""""""lightline"""""""""""""""""""""""
" colorscheme default, wombat, jellybeans, solarized, landscape

let g:lightline = {
      \ 'colorscheme': 'solarized',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ], [ 'fugitive', 'filename' ], ['ctrlpmark'] ],
      \   'right': [ [ 'syntastic', 'lineinfo' ], ['percent'], [ 'fileformat', 'fileencoding', 'filetype' ] ]
      \ },
      \ 'component_function': {
      \   'fugitive': 'MyFugitive',
      \   'filename': 'MyFilename',
      \   'fileformat': 'MyFileformat',
      \   'filetype': 'MyFiletype',
      \   'fileencoding': 'MyFileencoding',
      \   'mode': 'MyMode',
      \   'ctrlpmark': 'CtrlPMark',
      \ },
      \ 'component_expand': {
      \   'syntastic': 'SyntasticStatuslineFlag',
      \ },
      \ 'component_type': {
      \   'syntastic': 'error',
      \ },
      \ 'subseparator': { 'left': '|', 'right': '|' }
      \ }

function! MyModified()
  return &ft =~ 'help' ? '' : &modified ? '+' : &modifiable ? '' : '-'
endfunction

function! MyReadonly()
  return &ft !~? 'help' && &readonly ? 'RO' : ''
endfunction

function! MyFilename()
  let fname = expand('%:t')
  return fname == 'ControlP' ? g:lightline.ctrlp_item :
        \ fname == '__Tagbar__' ? g:lightline.fname :
        \ fname =~ '__Gundo\|NERD_tree' ? '' :
        \ &ft == 'vimfiler' ? vimfiler#get_status_string() :
        \ &ft == 'unite' ? unite#get_status_string() :
        \ &ft == 'vimshell' ? vimshell#get_status_string() :
        \ ('' != MyReadonly() ? MyReadonly() . ' ' : '') .
        \ ('' != fname ? fname : '[No Name]') .
        \ ('' != MyModified() ? ' ' . MyModified() : '')
endfunction

function! MyFugitive()
  try
    if expand('%:t') !~? 'Tagbar\|Gundo\|NERD' && &ft !~? 'vimfiler' && exists('*fugitive#head')
      let mark = ''  " edit here for cool mark
      let _ = fugitive#head()
      return strlen(_) ? mark._ : ''
    endif
  catch
  endtry
  return ''
endfunction

function! MyFileformat()
  return winwidth(0) > 70 ? &fileformat : ''
endfunction

function! MyFiletype()
  return winwidth(0) > 70 ? (strlen(&filetype) ? &filetype : 'no ft') : ''
endfunction

function! MyFileencoding()
  return winwidth(0) > 70 ? (strlen(&fenc) ? &fenc : &enc) : ''
endfunction

function! MyMode()
  let fname = expand('%:t')
  return fname == '__Tagbar__' ? 'Tagbar' :
        \ fname == 'ControlP' ? 'CtrlP' :
        \ fname == '__Gundo__' ? 'Gundo' :
        \ fname == '__Gundo_Preview__' ? 'Gundo Preview' :
        \ fname =~ 'NERD_tree' ? 'NERDTree' :
        \ &ft == 'unite' ? 'Unite' :
        \ &ft == 'vimfiler' ? 'VimFiler' :
        \ &ft == 'vimshell' ? 'VimShell' :
        \ winwidth(0) > 60 ? lightline#mode() : ''
endfunction

function! CtrlPMark()
  if expand('%:t') =~ 'ControlP'
    call lightline#link('iR'[g:lightline.ctrlp_regex])
    return lightline#concatenate([g:lightline.ctrlp_prev, g:lightline.ctrlp_item
          \ , g:lightline.ctrlp_next], 0)
  else
    return ''
  endif
endfunction

let g:ctrlp_status_func = {
      \ 'main': 'CtrlPStatusFunc_1',
      \ 'prog': 'CtrlPStatusFunc_2',
      \ }

function! CtrlPStatusFunc_1(focus, byfname, regex, prev, item, next, marked)
  let g:lightline.ctrlp_regex = a:regex
  let g:lightline.ctrlp_prev = a:prev
  let g:lightline.ctrlp_item = a:item
  let g:lightline.ctrlp_next = a:next
  return lightline#statusline(0)
endfunction

function! CtrlPStatusFunc_2(str)
  return lightline#statusline(0)
endfunction

let g:tagbar_status_func = 'TagbarStatusFunc'

function! TagbarStatusFunc(current, sort, fname, ...) abort
  let g:lightline.fname = a:fname
  return lightline#statusline(0)
endfunction

MyAutoCmd BufWritePost *.c,*.cpp call s:syntastic()

function! s:syntastic()
  SyntasticCheck
  call lightline#update()
endfunction

let g:unite_force_overwrite_statusline = 0
let g:vimfiler_force_overwrite_statusline = 0
let g:vimshell_force_overwrite_statusline = 0

"""""""""""""""""neorspec""""""""""""""""""""""
" let g:neorspec_command = "!bundle exec spring rspec --color --format documentation {spec}"
" let g:neorspec_command = "Dispatch bundle exec rspec --color --format documentation {spec}"
let g:neorspec_command = "Dispatch bundle exec spring rspec --color {spec}"
function! s:load_rspec_settings()
  nnoremap <buffer> ,rc  :RSpecCurrent<CR>
  nnoremap <buffer> ,rn  :RSpecNearest<CR>
  nnoremap <buffer> ,rl  :RSpecRetry<CR>
  nnoremap <buffer> ,ra  :RSpecAll<CR>
  nnoremap <buffer> ,r   :RSpec<Space>
endfunction

MyAutoCmd BufWinEnter *_spec.rb call s:load_rspec_settings()
" RSpec対応
" let g:quickrun_config = {}
" let g:quickrun_config._ = {'runner' : 'vimproc'}
" let g:quickrun_config['ruby.rspec'] = {
" \ 'command': 'rspec',
" \ 'cmdopt': '--color --format documentation',
" \ 'exec': 'bundle exec %c %o %s'
" \}
" augroup RSpec
" autocmd!
" autocmd BufWinEnter,BufNewFile *_spec.rb set filetype=ruby.rspec
" augroup END

""""""""""""""""""undotree""""""""""""""""""""""
" nnoremap <Leader>u :UndotreeToggle<CR>
" let g:undotree_SetFocusWhenToggle = 1
" let g:undotree_SplitLocation = 'topleft'
" let g:undotree_SplitWidth = 35
" let g:undotree_diffAutoOpen = 1
" let g:undotree_diffpanelHeight = 25
" let g:undotree_RelativeTimestamp = 1
" let g:undotree_TreeNodeShape = '*'
" let g:undotree_HighlightChangedText = 1
" let g:undotree_HighlightSyntax = "UnderLined"
"
" Use The Silver Searcher https://github.com/ggreer/the_silver_searcher

if executable('ag')
" Use Ag over Grep
set grepprg=ag\ --nogroup\ --nocolor
" Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
" let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
endif



"""""""""""""""vim-tags""""""""""""""""""""
let g:vim_tags_project_tags_command = "/usr/local/bin/ctags -R {OPTIONS} {DIRECTORY} 2>/dev/null"
let g:vim_tags_gems_tags_command = "/usr/local/bin/ctags -R {OPTIONS} `bundle show --paths` 2>/dev/null"

let g:vim_tags_auto_generate = 1
" tagsジャンプの時に複数ある時は一覧表示
nnoremap <C-]> g<C-]>
""""""""""Tag Jump拡張"""""""""""
" nmap <C-]> :vsp <CR>:exec("tag ".expand("<cword>"))<CR>

"""""""""""previm""""""""""""
" let g:previm_open_cmd = 'open -a Safari'

"""""""""""vim-startify""""""""
" startifyのヘッダー部分に表示する文字列を設定する(dateコマンドを実行して日付を設定している)
" let g:startify_custom_header =
" \ map(split(system('date'), '\n'), '"   ". v:val') + ['','']
" " デフォルトだと、最近使ったファイルの先頭は数字なので、使用するアルファベットを指定
" let g:startify_custom_indices = ['f', 'g', 'h', 'r', 'i', 'o', 'b']
" " よく使うファイルをブックマークとして登録しておく
" let g:startify_bookmarks = [
" \ '~/.vimrc'
" \ ]

"""""""""""ctrlp""""""""""""""""
" let g:ctrlp_prompt_mappings = {
" \ 'PrtSelectMove("j")':   ['<c-n>', '<down>'],
" \ 'PrtSelectMove("k")':   ['<c-p>', '<up>'],
" \ 'PrtHistory(-1)':       ['<c-j>'],
" \ 'PrtHistory(1)':        ['<c-k>'],
" \ }

""""""""""vim-choosewin"""""""""""""""
nmap  -  <Plug>(choosewin)
" if you want to use overlay feature
let g:choosewin_overlay_enable          = 1

" overlay font broke on mutibyte buffer?
let g:choosewin_overlay_clear_multibyte = 1

let g:choosewin_color_overlay = {
      \ 'gui': ['DodgerBlue3', 'DodgerBlue3' ],
      \ 'cterm': [ 25, 25 ]
      \ }
let g:choosewin_color_overlay_current = {
      \ 'gui': ['firebrick1', 'firebrick1' ],
      \ 'cterm': [ 124, 124 ]
      \ }

""""""""""osyo-manga/unite-choosewin-actions"""""""""""
" 選択しないウィンドウの場合は 1 を返す
" それ以外は 0 を返す
" choosewin/open 時は unite, vimfiler, vimshell を選択しない
function! s:choosewin_is_ignore_window(action, winnr)
  if a:action ==# "open"
    return index(["unite", "vimfiler", "vimshell"], getbufvar(winbufnr(a:winnr), "&filetype")) >= 0
  else
    return 0
  endif
endfunction

"""""""""""""""""Vimshell""""""""""""""""""""""""
nnoremap <Leader>s :shell<CR>
let g:vimshell_prompt_expr = 'getcwd()." > "'
let g:vimshell_prompt_pattern = '^\f\+ > '

""""""""""""""""""quickrun"""""""""""""""""""
set splitright
let g:quickrun_config = {}
let g:quickrun_config._ = {'runner' : 'vimproc', 'outputter/buffer/split': 'vsplit'}
" QuickRunのcoffee
let g:quickrun_config['coffee'] = {
      \'command' : 'coffee',
      \'exec' : ['%c -cbp %s']
      \}
"""""""""""""""""""fugitive""""""""""""""""
nnoremap <Leader>gg :Gst<CR>
nnoremap <Leader>gp :Gpush<CR>

""""""""""""""""""agit"""""""""""""""""""
nnoremap <Leader>ag :Agit<CR>

" DEFAULT KEY-MAPPINGS        *agit-default-key-mappings*

" J          <Plug>(agit-scrolldown-stat)
" K          <Plug>(agit-scrollup-stat)
" <C-j>      <Plug>(agit-scrolldown-diff)
" <C-k>      <Plug>(agit-scrollup-diff)
" u          <PLug>(agit-reload)
" yh         <Plug>(agit-yank-hash)
" q          <Plug>(agit-exit)
" C          <Plug>(agit-git-checkout)
" cb         <Plug>(agit-git-checkout-b)
" D          <Plug>(agit-git-branch-d)
" rs         <Plug>(agit-git-reset-soft)
" rm         <Plug>(agit-git-reset)
" rh         <Plug>(agit-git-reset-hard)
" rb         <Plug>(agit-git-rebase)
" ri         <Plug>(agit-git-rebase-i)
"""""""""""vim-json""""""""""""
let g:vim_json_syntax_conceal = 0

""""""""""memolist"""""""""""""""
let g:memolist_path = "~/Dropbox/memo"
nnoremap <Leader>mn  :MemoNew<CR>
nnoremap <Leader>ml  :MemoList<CR>
nnoremap <Leader>mg  :MemoGrep<CR>
let g:memolist_unite = 1
let g:memolist_unite_source = "file_rec"
let g:memolist_unite_option = "-start-insert"
let g:memolist_memo_date = "%Y-%m-%d-%a %H:%M"

""""""""""vim-markdown"""""""""""
let g:vim_markdown_folding_disabled=1

""""""""""open-browser"""""""""""
let g:netrw_nogx = 1 " disable netrw's gx mapping.
nmap gx <Plug>(openbrowser-smart-search)
vmap gx <Plug>(openbrowser-smart-search)

"""""""""""jazzradio.vim""""""""""""
nnoremap <Leader>jz :JazzradioUpdateChannels<CR>
nnoremap <Leader>jZ :JazzradioStop<CR>
nnoremap <Leader>uz :Unite jazzradio<CR>
"""""""""""over-vim""""""""""""
cnoreabb <silent><expr>s getcmdtype()==':' && getcmdline()=~'^s' ? 'OverCommandLine<CR><C-u>%s/<C-r>=get([], getchar(0), '')<CR>' : 's'
"""""""""""vim-auto-save""""""""""""
let g:auto_save = 1

""""""""""subway"""""""""""""""
nnoremap mm :SBToggleStation<CR>
nnoremap mp :SBMovePreviousStation<CR>
nnoremap mn :SBMoveNextStation<CR>

""""""""""NERDTree"""""""""""
nnoremap <C-n> :NERDTreeToggle<CR>

""""""""""vim-easy-align"""""""
" Start interactive EasyAlign in visual mode (e.g. vip<Enter>)
vmap <CR> <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. <Leader>aip)
nmap <Leader>a <Plug>(EasyAlign)
