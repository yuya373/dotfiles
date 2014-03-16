" ------------------------------------------------------------------------------
"
"   neobundle
" ------------------------------------------------------------------------------
"



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
" NeoBundle 'scrooloose/nerdtree'
NeoBundle 'scrooloose/nerdcommenter'
NeoBundle 'itchyny/lightline.vim'
NeoBundle 'surround.vim'
" NeoBundle 'https://github.com/kien/ctrlp.vim.git'
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
" NeoBundle 'yuya373/indentLine'
NeoBundle 'itchyny/thumbnail.vim'
NeoBundle "mbbill/undotree"
NeoBundle "airblade/vim-rooter"
" NeoBundle 'spolu/dwm.vim'
" NeoBundle 'nabezokodaikon/dwm.vim'
" NeoBundle 'kannokanno/unite-dwm'
NeoBundle 'szw/vim-tags'
NeoBundle 't9md/vim-choosewin'
NeoBundle 'Shougo/neosnippet-snippets'
NeoBundle 'AmaiSaeta/closesomewindow.vim'
NeoBundle 'gregsexton/gitv'

"""""""Unite""""""""""""
NeoBundle 'osyo-manga/unite-choosewin-actions'
NeoBundle 'h1mesuke/unite-outline'
NeoBundle 'Shougo/unite.vim'
NeoBundle 'Shougo/neomru.vim'
NeoBundle 'Shougo/vimfiler'

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

"""""""colorscheme""""""""
NeoBundle 'ujihisa/unite-colorscheme'
NeoBundle "wjakob/vim-tomorrow-night"
NeoBundle 'chriskempson/tomorrow-theme'
NeoBundle 'fugalh/desert.vim'
NeoBundle 'altercation/vim-colors-solarized'
NeoBundle 'jpo/vim-railscasts-theme'
NeoBundle '29decibel/codeschool-vim-theme'
NeoBundle 'nanotech/jellybeans.vim'
NeoBundle 'w0ng/vim-hybrid'
NeoBundle 'vim-scripts/twilight'
NeoBundle 'jonathanfilip/vim-lucius'
NeoBundle 'vim-scripts/Wombat'
NeoBundle 'tomasr/molokai'
NeoBundle 'vim-scripts/rdark'


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


" Brief help
" :NeoBundleList          - list configured bundles
" :NeoBundleInstall(!)    - install(update) bundles
" :NeoBundleClean(!)      - confirm(or auto-approve) removal of unused bundles

syntax enable
filetype plugin indent on

" Installation check.
NeoBundleCheck


" display
" ----------------------
set t_Co=256
scriptencoding utf-8


" augroup highlightIdegraphicSpace
  " autocmd!
  " autocmd Colorscheme * highlight IdeographicSpace term=underline ctermbg=DarkGreen guibg=DarkGreen
  " autocmd VimEnter,WinEnter * match IdeographicSpace /　/
" augroup END


set background=dark
" colorscheme railscasts
colorscheme tomorrow-night
" colorscheme hybrid

"""""""インサートモードでカーソルの形を変える""""""""""
"これがないとスマートインプットが機能しない?

let &t_SI = "\e]50;CursorShape=1\x7"
let &t_EI = "\e]50;CursorShape=0\x7"

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
function! s:SID_PREFIX()
  return matchstr(expand('<sfile>'), '<SNR>\d\+_\zeSID_PREFIX$')
endfunction

" Set tabline.
function! s:my_tabline()  "{{{
  let s = ''
  for i in range(1, tabpagenr('$'))
    let bufnrs = tabpagebuflist(i)
    let bufnr = bufnrs[tabpagewinnr(i) - 1]  " first window, first appears
    let no = i  " display 0-origin tabpagenr.
    let mod = getbufvar(bufnr, '&modified') ? '!' : ' '
    let title = fnamemodify(bufname(bufnr), ':t')
    let title = '[' . title . ']'
    let s .= '%'.i.'T'
    let s .= '%#' . (i == tabpagenr() ? 'TabLineSel' : 'TabLine') . '#'
    let s .= no . ':' . title
    let s .= mod
    let s .= '%#TabLineFill# '
  endfor
  let s .= '%#TabLineFill#%T%=%#TabLine#'
  return s
endfunction "}}}
let &tabline = '%!'. s:SID_PREFIX() . 'my_tabline()'
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
" set autoindent
set smartindent
set expandtab
set smarttab
set tabstop=2 shiftwidth=2
set softtabstop=0
set showmatch " show mactch brace
set wildmenu
set autoread
set hidden
set showcmd
set backspace=indent,eol,start
nnoremap p p=`]`]
inoremap <silent> <C-j> <ESC>
augroup auto_comment_off
  autocmd!
  autocmd BufEnter * setlocal formatoptions-=ro
augroup END
nnoremap <CR> o<Esc>
augroup auto_coffe
  autocmd!
  " vimにcoffeeファイルタイプを認識させる
  autocmd BufRead,BufNewFile,BufReadPre *.coffee   set filetype=coffee
  autocmd BufRead,BufNewFile,BufReadPre *.coffee nnoremap <Leader>cf :CoffeeWatch watch vert<CR>
augroup END

" set cursorline
set nocursorcolumn
set nocursorline
syntax sync minlines=256

map <C-j> <Esc>

" set formatoptions=qrn1
" if v:version >= 730
  " set colorcolumn=85 "色づけ
" endif

" nnoremap <Leader>a :Ag<SPACE>


" OSのクリップボードを使う
set clipboard+=unnamed

"""""""""""""""folding""""
" set foldmethod=indent
" set foldlevel=2
" set foldcolumn=3
" nnoremap <Leader>f :set foldmethod=indent<CR>


" 保存時に行末の空白を除去する
autocmd BufWritePre * :%s/\s\+$//ge
" 保存時にtabをスペースに変換する
autocmd BufWritePre * :%s/\t/  /ge


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
nnoremap <C-c> :close<CR>
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
autocmd WinLeave *
      \     let b:vimrc_pattern = @/
      \   | let b:vimrc_hlsearch = &hlsearch
autocmd WinEnter *
      \     let @/ = get(b:, 'vimrc_pattern', @/)
      \   | let &l:hlsearch = get(b:, 'vimrc_hlsearch', &l:hlsearch)
" 「/」「?」「*」「#」が押されたらハイライトをON にしてから「/」「?」「*」「#」
nnoremap / :<C-u>set hlsearch<Return>/
nnoremap ? :<C-u>set hlsearch<Return>?
nnoremap * :<C-u>set hlsearch<Return>*
nnoremap # :<C-u>set hlsearch<Return>#

" no bell
set visualbell
set t_vb=

" backup
" --------------------
set backup
set backupdir=~/.vim/vim_backup
set swapfile
set directory=~/.vim/vim_swap

" key map
" --------------------
map <C-n> :NERDTreeToggle<CR>
nnoremap Q <Nop>
inoremap <C-c> <Esc>
vnoremap <silent> <C-p> "0p<CR>"

" auto command
" --------------------
" augroup BufferAu
  " autocmd!
  " change current directory
  " autocmd BufNewFile,BufRead,BufEnter * if isdirectory(expand("%:p:h")) && bufname("%") !~ "NERD_tree" | cd %:p:h | endif
" augroup END
"autocmd vimenter * NERDTree
" autocmd vimenter * if !argc() | NERDTree | endif
" autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | e
autocmd QuickFixCmdPost *grep* cwindow

" Plugin setting
" --------------------

" NEED Commenter
let NERDShutUp = 1 "no alart undfined filetype

" NERDTree

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
let g:rails_ctags_arguments='--languages=-javascript'
let g:rails_ctags_arguments = ''
function! SetUpRailsSetting()
  nnoremap <buffer><Space>r :R<CR>
  nnoremap <buffer><Space>a :A<CR>
  nnoremap <buffer><Space>m :Rmodel<Space>
  nnoremap <buffer><Space>c :Rcontroller<Space>
  nnoremap <buffer><Space>v :Rview<Space>
  nnoremap <buffer><Space>p :Rpreview<CR>
endfunction
aug MyAutoCmd
  au User Rails call SetUpRailsSetting()
aug END
aug RailsDictSetting
  au!
aug END
autocmd User Rails.view*                 NeoSnippetSource ~/.vim/snippet/ruby.rails.view.snip
autocmd User Rails.controller*           NeoSnippetSource ~/.vim/snippet/ruby.rails.controller.snip
autocmd User Rails/db/migrate/*          NeoSnippetSource ~/.vim/snippet/ruby.rails.migrate.snip
autocmd User Rails/config/routes.rb      NeoSnippetSource ~/.vim/snippet/ruby.rails.route.snip
"}}}


"""""""""""""""vimfiler""""""""""""
let g:vimfiler_safe_mode_by_default = 0
let g:vimfiler_as_default_explorer = 1
" Like Textmate icons.
let g:vimfiler_tree_leaf_icon = ' '
let g:vimfiler_tree_opened_icon = '▾'
let g:vimfiler_tree_closed_icon = '▸'
let g:vimfiler_file_icon = '-'
let g:vimfiler_marked_file_icon = '*'
nmap <C-n>  :VimFiler -split -horizontal -project -toggle -quit<CR>

""" unite.vim
" 起動時にインサートモードで開始
let g:unite_enable_start_insert = 1
let g:unite_enable_short_source_names = 1
" let g:unite_winheight = 10
" let g:unite_split_rule = 'botright'
let g:unite_prompt = '▸▸ '
"  " unite grep に ag(The Silver Searcher) を使う
if executable('ag')
  let g:unite_source_grep_command = 'ag'
  let g:unite_source_grep_default_opts = '--nogroup --nocolor --column'
  let g:unite_source_grep_recursive_opt = ''
endif
"              " 大文字小文字を区別しない
let g:unite_enable_ignore_case = 1
let g:unite_enable_smart_case = 1
" ファイルを開く場合のデフォルトアクションを choosewin にする
call unite#custom#default_action('file' , 'choosewin/open')
call unite#custom#default_action('buffer' , 'choosewin/open')

" The prefix key.
nnoremap    [unite]   <Nop>
nmap    ,u [unite]

let g:unite_source_menu_menus = {}
let g:unite_source_menu_menus.shortcuts= {
      \     'description' : 'shortcutsmenu',
      \ }
let g:unite_source_menu_menus.shortcuts.candidates = {
      \   'vimrc'     : 'vs ~/.vimrc',
      \   'ghci'      : 'VimShellInteractive ghci',
      \ }
function g:unite_source_menu_menus.shortcuts.map(key, value)
  return {
        \       'word' : a:key, 'kind' : 'command',
        \       'action__command' : a:value,
        \     }
endfunction


nnoremap  [unite]s  :<C-u>Unite menu:shortcuts<CR>


" アウトライン
nnoremap <silent> [unite]o  :<C-u>Unite outline<CR>
nnoremap [unite]o :Unite -vertical -winwidth=40 outline<Return>
" マッピング
" nnoremap <silent> [unite]ma :<C-u>Unite mapping<CR>
" メッセージ
" nnoremap <silent> [unite]me :<C-u>Unite output:message<CR>
" バッファ一覧
nnoremap <silent> [unite]b :<C-u>Unite buffer<CR>
" レジスタ一覧
nnoremap <silent> [unite]p :<C-u>Unite -buffer-name=register register<CR>
" ヤンク履歴
nnoremap <silent> [unite]y :<C-u>Unite history/yank<CR>
" 最近使用したファイル一覧
nnoremap <silent> [unite]u :<C-u>Unite file_mru<CR>
" 常用セット
" nnoremap <silent> [unite]u :<C-u>Unite buffer file_mru<CR>
" 全部乗せ
" nnoremap <silent> [unite]a :<C-u>Unite -buffer-name=files buffer file_mru bookmark file<CR>
" ctrlp風
let g:unite_source_file_rec_max_cache_files = 10000
let g:unite_source_file_rec_min_cache_files = 100
" nnoremap <C-p> :Unite -start-insert -winheight=10 -direction=botright file_rec/async<cr>
" call unite#custom#source('file_rec/async', 'ignore_pattern', '\(^\.git\|png\|gif\|jpeg\|jpg\)$')

nnoremap <C-p> :Unite -start-insert file_rec/async<cr>
" ファイル一覧
nnoremap <silent> [unite]f  :<C-u>UniteWithBufferDir  file file/new -buffer-name=files<CR>
nnoremap <silent> [unite]c :<C-u>UniteWithBufferDir  file file/new -input=app/controllers/ -buffer-name=controllers<CR>
nnoremap <silent> [unite]m :<C-u>UniteWithBufferDir  file file/new -input=app/models/ -buffer-name=models<CR>
nnoremap <silent> [unite]v :<C-u>UniteWithBufferDir  file file/new -input=app/views/ -buffer-name=views<CR>
nnoremap <silent> [unite]s :<C-u>UniteWithBufferDir  file file/new -input=spec/ -buffer-name=spec<CR>
nnoremap <silent> [unite]j :<C-u>UniteWithBufferDir  file file/new -input=app/assets/javascript/ -buffer-name=js<CR>
" grep検索
nnoremap <silent> ,g  :<C-u>Unite grep:. -buffer-name=search-buffer<CR>
" カーソル位置の単語をgrep検索
nnoremap <silent> ,cg :<C-u>Unite grep:. -buffer-name=search-buffer<CR><C-R><C-W><CR>
" grep検索結果の再呼出
nnoremap <silent> [unite]r  :<C-u>UniteResume search-buffer<CR>


function! s:unite_my_settings()
  " 単語単位からパス単位で削除するように変更
  imap <buffer> <C-w> <Plug>(unite_delete_backward_path)
  " ESCキーを2回押すと終了する
  nmap <silent><buffer> <ESC><ESC> q
  imap <silent><buffer> <ESC><ESC> <ESC>q
  nnoremap <silent> <buffer> <expr> <C-s> unite#do_action('split')
  inoremap <silent> <buffer> <expr> <C-s> unite#do_action('split')
  nnoremap <silent> <buffer> <expr> <C-v> unite#do_action('vsplit')
  inoremap <silent> <buffer> <expr> <C-v> unite#do_action('vsplit')
  " dwm.vim で開く
  " nnoremap <silent> <buffer> <expr> <c-o> unite#do_action('dwm_new')
  " inoremap <silent> <buffer> <expr> <c-o> unite#do_action('dwm_new')
endfunction
autocmd FileType unite call s:unite_my_settings()



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


""USE RUBOCOP
let g:syntastic_mode_map = { 'mode': 'active',
      \ 'active_filetypes': ['ruby'] }
let g:syntastic_ruby_checkers = ['rubocop']
let g:syntastic_quiet_messages = {'level': 'warnings'}

" vim-eazymotion {{{
" デフォルトだと<Leader><Leader>となってるprefixキーを変更
let g:EasyMotion_leader_key = '\'

" 候補選択: 候補が最初から2キー表示されるので大文字や打ちにくい文字は全面的に消す
" なお、最後の数文字が2キーの時の最初のキーになるので打ちやすいものを選ぶとよさそうです。
let g:EasyMotion_keys='hklyuiopnm,qwertzxcvbasdgjf;'
let g:EasyMotion_do_shade = 1


" 拡張版機能"{{{

" もっともよく使うであろう'<Leadr><Leader>s'motion をsに割り当て
nmap s <Plug>(easymotion-s)
vmap s <Plug>(easymotion-s)
omap z <Plug>(easymotion-s) " surround.vimとかぶるのでz

" keep cursor column
let g:EasyMotion_startofline = 0

" smartcase
let g:EasyMotion_smartcase = 1

""VimFiler
"let g:vimfiler_as_default_explorer = 1
"let g:vimfiler_safe_mode_by_default = 0

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
call smartinput#map_to_trigger('i', '<Plug>(smartinput_CR)', '<Enter>', '<Enter>')
imap <expr> <CR> pumvisible() ?
      \ neocomplete#close_popup() : "\<Plug>(smartinput_CR)"

" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<S-TAB>"
" <C-h>, <BS>: close popup and delete backword char.
"inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
"inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
inoremap <expr><C-y>  neocomplete#close_popup()
inoremap <expr><C-e>  neocomplete#cancel_popup()
" Close popup by <Space>.
"inoremap <expr><Space> pumvisible() ? neocomplete#close_popup() : "\<Space>"



" Enable omni completion.
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

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

"""""""vim-auto-save""""""""
let g:auto_save = 1

"""""""""indentLine""""""""""
"""""""""""""""""""""""""""""
" let g:indentLine_color_term = 239
" let g:indentLine_color_gui = '#A4E57E'
" " let g:indentLine_char = '┊'
" let g:indentLine_char = '▸'
" let g:indentLine_showFirstIndentLevel = 2
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



"""""""""""NERD COMMENTER""""""""""""
let NERDSpaceDelims = 1
nmap ,, <Plug>NERDCommenterToggle
vmap ,, <Plug>NERDCommenterToggle

""""""""""""""""thumbnail"""""""""""""""""""""""

nnoremap <Leader>t :Thumbnail<CR>

""""""""""""lightline"""""""""""""""""""""""
let g:lightline = {
      \ 'colorscheme': 'default',
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

augroup AutoSyntastic
  autocmd!
  autocmd BufWritePost *.c,*.cpp call s:syntastic()
augroup END
function! s:syntastic()
  SyntasticCheck
  call lightline#update()
endfunction

let g:unite_force_overwrite_statusline = 0
let g:vimfiler_force_overwrite_statusline = 0
let g:vimshell_force_overwrite_statusline = 0

"""""""""""""""""neorspec""""""""""""""""""""""
" let g:neorspec_command = "!rspec --color --format documentation {spec}"
let g:neorspec_command = "Dispatch bundle exec spring rspec --color --format documentation {spec}"
" let g:neorspec_command = "Start rspec --color --format documentation {spec}"
function! s:load_rspec_settings()
  nnoremap ,rc  :RSpecCurrent<CR>
  nnoremap ,rn  :RSpecNearest<CR>
  nnoremap ,rl  :RSpecRetry<CR>
  nnoremap ,ra  :RSpecAll<CR>
  nnoremap ,r   :RSpec<Space>
endfunction

augroup RSpecSetting
  autocmd!
  autocmd BufWinEnter *.rb call s:load_rspec_settings()
augroup END


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
" if executable('ag')
" " Use Ag over Grep
" set grepprg=ag\ --nogroup\ --nocolor
" " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
" let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
" endif



"""""""""""""""vim-tags""""""""""""""""""""
let g:vim_tags_project_tags_command = "/usr/local/bin/ctags -R {OPTIONS} {DIRECTORY} 2>/dev/null"
let g:vim_tags_gems_tags_command = "/usr/local/bin/ctags -R {OPTIONS} `bundle show --paths` 2>/dev/null"
" tagsジャンプの時に複数ある時は一覧表示
nnoremap <C-]> g<C-]>

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
nmap  `  <Plug>(choosewin)
" if you want to use overlay feature
let g:choosewin_overlay_enable          = 1

" overlay font broke on mutibyte buffer?
let g:choosewin_overlay_clear_multibyte = 1

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
" nnoremap <Leader>s :VimShellInteractive zsh<CR>
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
"""""""""""""""""""gitv""""""""""""""""""""
function! s:gitv_get_current_hash()
  return matchstr(getline('.'), '\[\zs.\{7\}\ze\]$')
endfunction

autocmd FileType git setlocal nofoldenable foldlevel=0
function! s:toggle_git_folding()
  if &filetype ==# 'git'
    setlocal foldenable!
  endif
endfunction

autocmd FileType gitv call s:my_gitv_settings()
function! s:my_gitv_settings()
  setlocal iskeyword+=/,-,.
  nnoremap <silent><buffer> C :<C-u>Git checkout <C-r><C-w><CR>
  nnoremap <buffer> <Space>rb :<C-u>Git rebase <C-r>=GitvGetCurrentHash()<CR><Space>
  nnoremap <buffer> <Space>R :<C-u>Git revert <C-r>=GitvGetCurrentHash()<CR><CR>
  nnoremap <buffer> <Space>h :<C-u>Git cherry-pick <C-r>=GitvGetCurrentHash()<CR><CR>
  nnoremap <buffer> <Space>rh :<C-u>Git reset --hard <C-r>=GitvGetCurrentHash()<CR>
  " s:my_gitv_settings 内
  nnoremap <silent><buffer> t :<C-u>windo call <SID>toggle_git_folding()<CR>1<C-w>w
endfunction
""""""""""""""ctrlp"""""""""""""""

" let g:ctrlp_prompt_mappings = {
      " \ 'PrtBS()':              ['<bs>', '<c-]>'],
      " \ 'PrtDelete()':          ['<del>'],
      " \ 'PrtDeleteWord()':      ['<c-w>'],
      " \ 'PrtClear()':           ['<c-u>'],
      " \ 'PrtSelectMove("j")':   ['<c-n>', '<down>'],
      " \ 'PrtSelectMove("k")':   ['<c-p>', '<up>'],
      " \ 'PrtSelectMove("t")':   ['<Home>', '<kHome>'],
      " \ 'PrtSelectMove("b")':   ['<End>', '<kEnd>'],
      " \ 'PrtSelectMove("u")':   ['<PageUp>', '<kPageUp>'],
      " \ 'PrtSelectMove("d")':   ['<PageDown>', '<kPageDown>'],
      " \ 'PrtHistory(-1)':       ['<c-j>'],
      " \ 'PrtHistory(1)':        ['<c-k>'],
      " \ 'AcceptSelection("e")': ['<cr>', '<2-LeftMouse>'],
      " \ 'AcceptSelection("h")': ['<c-x>', '<c-cr>', '<c-s>'],
      " \ 'AcceptSelection("t")': ['<c-t>'],
      " \ 'AcceptSelection("v")': ['<c-v>', '<RightMouse>'],
      " \ 'ToggleFocus()':        ['<s-tab>'],
      " \ 'ToggleRegex()':        ['<c-r>'],
      " \ 'ToggleByFname()':      ['<c-d>'],
      " \ 'ToggleType(1)':        ['<c-f>', '<c-up>'],
      " \ 'ToggleType(-1)':       ['<c-b>', '<c-down>'],
      " \ 'PrtExpandDir()':       ['<tab>'],
      " \ 'PrtInsert("c")':       ['<MiddleMouse>', '<insert>'],
      " \ 'PrtInsert()':          ['<c-\>'],
      " \ 'PrtCurStart()':        ['<c-a>'],
      " \ 'PrtCurEnd()':          ['<c-e>'],
      " \ 'PrtCurLeft()':         ['<c-h>', '<left>', '<c-^>'],
      " \ 'PrtCurRight()':        ['<c-l>', '<right>'],
      " \ 'PrtClearCache()':      ['<F5>'],
      " \ 'PrtDeleteEnt()':       ['<F7>'],
      " \ 'CreateNewFile()':      ['<c-y>'],
      " \ 'MarkToOpen()':         ['<c-z>'],
      " \ 'OpenMulti()':          ['<c-o>'],
      " \ 'PrtExit()':            ['<esc>', '<c-c>', '<c-g>'],
      " \ }
"""""""""""vim-json""""""""""""
let g:vim_json_syntax_conceal = 0
