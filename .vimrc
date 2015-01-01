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

call neobundle#begin(expand('~/.vim/bundle'))


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
NeoBundle 'mattn/benchvimrc-vim'
NeoBundle 'Shougo/neobundle.vim'
NeoBundle 'Shougo/neosnippet'
NeoBundle 'itchyny/lightline.vim'
NeoBundle 'surround.vim'
NeoBundle 'thinca/vim-quickrun', {
      \ 'depends' : 'mattn/quickrunex-vim',
      \ 'autoload' : {
      \ 'mappings' : '<Plug>',
      \ 'commands' : ['Quickrun']
      \ }
      \ }
NeoBundle 'https://github.com/vim-jp/vimdoc-ja'
NeoBundle 'tpope/vim-fugitive'
" NeoBundleLazy 'tpope/vim-fugitive', {
"       \ 'autoload' : {
"       \ 'commands' : ['Git', 'Git!', 'Gstatus', 'Glog', 'Gblame']
"       \ }
"       \ }
if neobundle#tap('vim-fugitive')
  nnoremap <Leader>gg :Gstatus<CR>
endif
NeoBundleLazy 'Lokaltog/vim-easymotion', {
      \ 'autoload' : {
      \ 'mappings' : '<Plug>'
      \ }
      \ }
if neobundle#tap('vim-easymotion')
  function! neobundle#hooks.on_source(bundle)
    let g:EasyMotion_do_mapping = 0
    let g:EasyMotion_enter_jump_first = 1

    " デフォルトだと<Leader><Leader>となってるprefixキーを変更
    let g:EasyMotion_leader_key = '\'

    " 候補選択: 候補が最初から2キー表示されるので大文字や打ちにくい文字は全面的に消す
    " なお、最後の数文字が2キーの時の最初のキーになるので打ちやすいものを選ぶとよさそうです。
    let g:EasyMotion_keys='hklyuiopnm,qwertzxcvbasdgjf;'
    let g:EasyMotion_do_shade = 1
    " keep cursor column
    let g:EasyMotion_startofline = 0

    " smartcase
    let g:EasyMotion_smartcase = 1
  endfunction

  nmap <silent> s <Plug>(easymotion-s2)
  xmap <silent> s <Plug>(easymotion-s2)
  omap <silent> z <Plug>(easymotion-s2)
  map <silent> f <Plug>(easymotion-bd-fl)
endif
NeoBundle 'vim-scripts/vim-auto-save'
NeoBundle 'rking/ag.vim'
NeoBundle 'Yggdroot/indentLine'
NeoBundleLazy 't9md/vim-choosewin', {
      \ 'autoload' : {
      \ 'on_source' : 'unite.vim',
      \ 'mappings' : '<Plug>'
      \ }
      \ }
if neobundle#tap('vim-choosewin')
  function! neobundle#hooks.on_source(bundle)
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
  endfunction
  nmap  -  <Plug>(choosewin)
  call neobundle#untap()
endif

NeoBundle 'Shougo/neosnippet-snippets'
NeoBundleLazy 'cohama/agit.vim', {
      \ 'autoload' : {
      \ 'commands' : ['Agit', 'AgitFile']
      \ }
      \ }
if neobundle#tap('agit.vim')
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
  nnoremap <Leader>ag :Agit<CR>
  nnoremap <Leader>af :AgitFile<CR>
  call neobundle#untap()
endif

NeoBundle 'LeafCage/foldCC'
NeoBundleLazy 'LeafCage/yankround.vim', {
      \ 'autoload' : {
      \ 'on_source' : 'unite.vim'
      \ }
      \ }
NeoBundle 'osyo-manga/vim-over'
" too slow!!
" NeoBundle 'moznion/hateblo.vim', {
      " \ 'depends': ['mattn/webapi-vim', 'Shougo/unite.vim']
      " \ }
NeoBundle 'airblade/vim-rooter'
NeoBundle 'othree/html5.vim'
NeoBundleLazy 'junegunn/vim-easy-align', {
      \ 'autoload' : {
      \ 'mappings' : '<Plug>(EasyAlign)'
      \ }
      \ }
if neobundle#tap('vim-easy-align')
  " Start interactive EasyAlign in visual mode (e.g. vip<Enter>)
  vmap <CR> <Plug>(EasyAlign)

  " Start interactive EasyAlign for a motion/text object (e.g. <Leader>aip)
  " nmap <Leader>a <Plug>(EasyAlign)
endif

NeoBundle 'Shougo/context_filetype.vim'
NeoBundleLazy 'osyo-manga/vim-precious', {
      \ 'autoload' : {
      \ 'filetypes' : ['markdown', 'vim'],
      \ 'commands' : ['PreciousReset', 'PreciousSwitch', 'PreciousFileType']
      \ }
      \ }
if neobundle#tap('vim-precious')
  function! neobundle#hooks.on_source(bundle)
    let g:precious_enable_switch_CursorMoved = {
          \    '*' : 0,}
    let g:precious_enable_switch_CursorMoved_i = {
          \    '*' : 0,}
  endfunction
  call neobundle#untap()
endif
""""""""""vim-precious"""""""""""""""

NeoBundle 'mattn/emoji-vim'

NeoBundle "osyo-manga/shabadou.vim"
NeoBundle "osyo-manga/vim-watchdogs"
NeoBundle 'cohama/vim-hier'
" NeoBundle "dannyob/quickfixstatus"
NeoBundle "KazuakiM/vim-qfstatusline"
NeoBundle 'KazuakiM/vim-qfsigns'

NeoBundleLazy "tyru/caw.vim", {
      \ 'autoload' : {
      \ 'mappings' : ['<Plug>']
      \ }
      \ }
if neobundle#tap('caw.vim')
  nmap ,, <Plug>(caw:i:toggle)
  vmap ,, <Plug>(caw:i:toggle)
  call neobundle#untap()
endif

NeoBundleLazy 'alpaca-tc/alpaca_tags', {
      \ 'depends': ['Shougo/vimproc'],
      \ 'autoload' : {
      \   'commands' : [
      \     { 'name' : 'AlpacaTagsBundle', 'complete': 'customlist,alpaca_tags#complete_source' },
      \     { 'name' : 'AlpacaTagsUpdate', 'complete': 'customlist,alpaca_tags#complete_source' },
      \     'AlpacaTagsSet', 'AlpacaTagsCleanCache', 'AlpacaTagsEnable', 'AlpacaTagsDisable', 'AlpacaTagsKillProcess', 'AlpacaTagsProcessStatus',
      \ ],
      \ }}
if neobundle#tap('alpaca_tags')
  function! neobundle#hooks.on_source(bundle)
    let g:alpaca_tags#ctags_bin = '/usr/local/bin/ctags'
    let g:alpaca_tags#config = {
          \ '_' : '-R --sort=yes --languages=+Ruby --languages=-js,JavaScript',
          \ 'js' : '--languages=+js',
          \ '-js' : '--languages=-js,JavaScript',
          \ 'vim' : '--languages=+Vim,vim',
          \ 'php' : '--languages=+php',
          \ '-vim' : '--languages=-Vim,vim',
          \ '-style': '--languages=-css,scss,js,JavaScript,html',
          \ 'scss' : '--languages=+scss --languages=-css',
          \ 'css' : '--languages=+css',
          \ 'java' : '--languages=+java $JAVA_HOME/src',
          \ 'ruby': '--languages=+Ruby',
          \ 'coffee': '--languages=+coffee',
          \ '-coffee': '--languages=-coffee',
          \ 'bundle': '--languages=+Ruby',
          \ 'cpp' : '--languages=+cpp'
          \ }
  endfunction
  call neobundle#untap()
endif

NeoBundleLazy 'haya14busa/incsearch.vim', {
      \ 'autoload' : {
      \ 'mappings' : '<Plug>'
      \ }
      \ }
if neobundle#tap('incsearch.vim')
  function! neobundle#hooks.on_source(bundle)
    let g:incsearch#auto_nohlsearch = 1
  endfunction
  set hlsearch
  map /  <Plug>(incsearch-forward)
  map ?  <Plug>(incsearch-backward)
  map g/ <Plug>(incsearch-stay)
  map n  <Plug>(incsearch-nohl-n)
  map N  <Plug>(incsearch-nohl-N)
  map *  <Plug>(incsearch-nohl-*)
  map #  <Plug>(incsearch-nohl-#)
  map g* <Plug>(incsearch-nohl-g*)
  map g# <Plug>(incsearch-nohl-g#)
  call neobundle#untap()
endif

NeoBundleLazy 'diffchar.vim', {
      \ 'autoload' : {
      \ 'commands' : 'SDChar'
      \ }
      \ }
if neobundle#tap('diffchar.vim')
  function! neobundle#hooks.on_source(bundle)
    let g:DiffUnit = "Word3"
    let g:DiffUpdate = 1
  endfunction
  if &diff
    MyAutoCmd VimEnter * execute "%SDChar"
  endif
  call neobundle#untap()
endif

NeoBundle 'cohama/lexima.vim'

NeoBundleLazy 'Shougo/vimfiler', {
      \ 'autoload' : {
      \ 'commands' : ['VimFilerBufferDir', 'VimFiler']
      \ }
      \ }

NeoBundleLazy 'Shougo/vimshell.vim', { 'depends' : [ 'Shougo/vimproc.vim' ] }
if neobundle#tap('vimshell.vim')
  call neobundle#config({
        \   'autoload' : {
        \     'commands' : [ 'VimShell', 'VimShellPop', 'VimShellTab' ]
        \   }
        \ })
  nnoremap <Leader>vst :VimShellTab<CR>
  nnoremap <Leader>vsp :VimShellPop<CR>
  nnoremap <Leader>s :shell<CR>
  call neobundle#untap()
endif

NeoBundleLazy 'supermomonga/vimshell-pure.vim', { 'depends' : [ 'Shougo/vimshell.vim' ] }
if neobundle#tap('vimshell-pure.vim')
  call neobundle#config({
        \   'autoload' : {
        \     'on_source' : [ 'vimshell.vim' ]
        \   }
        \ })
  call neobundle#untap()
endif

NeoBundleLazy 'LeafCage/nebula.vim', {
      \ 'autoload' : {
      \ 'commands' : [
      \ 'NebulaPutLazy', 'NebulaYankTap', 'NebulaPutConfig',
      \ 'NebulaYankOptions', 'NebulaPutFromClipboard'
      \ ]
      \ }
      \ }
if neobundle#tap('nebula.vim')
  nnoremap <silent>,bl    :<C-u>NebulaPutLazy<CR>
  nnoremap <silent>,bc    :<C-u>NebulaPutConfig<CR>
  nnoremap <silent>,by    :<C-u>NebulaYankOptions<CR>
  nnoremap <silent>,bp    :<C-u>NebulaPutFromClipboard<CR>
  nnoremap <silent>,bt    :<C-u>NebulaYankTap<CR>
  call neobundle#untap()
endif

if has("lua") > 0
  NeoBundle 'Shougo/neocomplete'
else
  NeoBundle 'Shougo/neocomplcache.vim'
endif

"""""""ruby && rails""""
NeoBundle 'tpope/vim-rails'
NeoBundleLazy 'tpope/vim-haml', {
  \ 'autoload' : { 'filetypes' : 'haml' }
  \ }
NeoBundleLazy 'alpaca-tc/neorspec.vim', {
      \ 'depends' : 'tpope/vim-rails',
      \ 'autoload' : {
      \   'commands' : [
      \       'RSpecAll', 'RSpecNearest', 'RSpecRetry',
      \       'RSpecCurrent', 'RSpec'
      \ ]}}

"""""""Unite""""""""""""
NeoBundleLazy 'tacroe/unite-mark', { 'depends' : 'Shougo/unite.vim' }
if neobundle#tap('unite-mark')
  call neobundle#config({
        \ 'autoload' : {
          \ 'on_source' : ['unite.vim']
          \ }
        \ })
  call neobundle#untap()
endif

NeoBundleLazy 'osyo-manga/unite-choosewin-actions', { 'depends' : 'Shougo/unite.vim'  }
if neobundle#tap('unite-choosewin-actions')
  call neobundle#config({
        \ 'depends' : 't9md/vim-choosewin',
        \ 'autoload' : {
        \ 'on_source' : ['unite.vim']
        \ }
        \ })
  call neobundle#untap()
endif
NeoBundleLazy 'Shougo/unite-outline', { 'depends' : 'Shougo/unite.vim' }
if neobundle#tap('unite-outline')
  call neobundle#config({
        \ 'autoload' : {
          \ 'on_source' : ['unite.vim']
          \ }
        \ })
  call neobundle#untap()
endif

NeoBundleLazy 'Shougo/unite.vim', { 'depends' : 'Shougo/vimproc.vim' }
if neobundle#tap('unite.vim')
  call neobundle#config({
        \ 'autoload' : {
          \ 'commands' : [
          \ {
          \ 'name' : 'Unite', 'complete' : 'customlist,unite#complete_source'
          \ },
          \ 'UniteWithBufferDir', 'UniteResume',
          \ ]
          \ }
        \})

  function! neobundle#hooks.on_source(bundle)
    let g:unite_enable_start_insert = 1
    let g:unite_enable_short_source_names = 1
    "  " unite grep に ag(The Silver Searcher) を使う
    if executable('ag')
      let g:unite_source_grep_command = 'ag'
      let g:unite_source_grep_default_opts = '--nogroup --nocolor --column'
      let g:unite_source_grep_recursive_opt = ''
    endif
    let g:unite_enable_ignore_case = 1
    let g:unite_enable_smart_case = 1
    call unite#custom#default_action('file' , 'choosewin/open')
    call unite#custom#default_action('buffer' , 'choosewin/open')
    call unite#custom#default_action('grep' , 'choosewin/open')
  endfunction

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

  " The prefix key.
  nnoremap    [unite]   <Nop>
  nmap    ,u [unite]

  nnoremap <silent> [unite]o  :<C-u>Unite outline<CR>
  " nnoremap [unite]o :Unite -vertical -winwidth=30 outline<Return>
  " nnoremap <silent> [unite]ma :<C-u>Unite mapping<CR>
  nnoremap <silent> [unite]b :<C-u>Unite buffer<CR>
  nnoremap <silent> [unite]p :<C-u>Unite -buffer-name=register register<CR>
  nnoremap <silent> [unite]y :<C-u>Unite yankround<CR>
  nnoremap <silent> [unite]u :<C-u>Unite file_mru<CR>
  nnoremap <silent> [unite]r :UniteWithProjectDir file file/new directory/new -buffer-name=root<CR>
  nnoremap <silent> [unite]f :UniteWithBufferDir file file/new directory/new -buffer-name=files<CR>
  " grep検索
  nnoremap <silent> ,g  :<C-u>Unite grep:. -buffer-name=search-buffer<CR>
  " カーソル位置の単語をgrep検索
  nnoremap <silent> ,cg :<C-u>Unite grep:. -buffer-name=search-buffer<CR><C-R><C-W><CR>
  " grep検索結果の再呼出
  nnoremap <silent> ,r  :<C-u>UniteResume search-buffer<CR>
  "mark一覧
  nnoremap <silent> ,m :<C-u>Unite mark<CR>
  nnoremap <silent> <C-p> :<C-u>Unite -start-insert file_rec/async:!<CR>

  function! s:cd_root_and_unite(...)
    let args = join(a:000, ' ')
    execute 'Rooter'
    execute 'Unite'.' '.args
  endfunction
  command! -nargs=* RootAndUnite call s:cd_root_and_unite(<f-args>)

  function! s:railsDetect(...) abort
    if exists('b:rails_root')
      return 1
    endif
    let fn = fnamemodify(a:0 ? a:1 : expand('%'), ':p')
    if !isdirectory(fn)
      let fn = fnamemodify(fn, ':h')
    endif
    let file = findfile('config/environment.rb', escape(fn, ', ').';')
    if !empty(file)
      let b:rails_root = fnamemodify(file, ':p:h:h')
      return 1
    endif
  endfunction

  let b:is_rails = s:railsDetect()
  if b:is_rails
    nnoremap <silent> [unite]c :RootAndUnite file file/new directory/new -input=app/controllers/ -buffer-name=controllers<CR>
    nnoremap <silent> [unite]m :RootAndUnite file file/new directory/new -input=app/models/ -buffer-name=models<CR>
    nnoremap <silent> [unite]d :RootAndUnite file file/new directory/new -input=app/decorators/ -buffer-name=decorators<CR>
    nnoremap <silent> [unite]v :RootAndUnite file file/new directory/new -input=app/views/ -buffer-name=views<CR>
    nnoremap <silent> [unite]j :RootAndUnite file file/new directory/new -input=app/assets/javascripts/ -buffer-name=js<CR>
    nnoremap <silent> [unite]a :RootAndUnite file file/new directory/new -input=app/ -buffer-name=app<CR>
    nnoremap <silent> [unite]s :RootAndUnite file file/new directory/new -input=spec/ -buffer-name=spec<CR>
  endif

  call neobundle#untap()
endif

NeoBundleLazy 'Shougo/neomru.vim', { 'depends' : 'unite.vim' }
if neobundle#tap('neomru.vim')
  call neobundle#config({
        \ 'autoload' : {
        \   'on_source' : ['unite.vim']
        \   }
        \ })
  call neobundle#untap()
endif

"""""""js && coffee""""
NeoBundleLazy 'kchmck/vim-coffee-script', {
      \ 'autoload' : { 'filetypes' : 'coffee' }
      \ }
NeoBundleLazy "vim-scripts/JavaScript-Indent", {
      \ 'autoload' : { 'filetypes' : ['coffee', 'javascript'] }
      \ }
NeoBundle "elzr/vim-json"

"""""""haskell""""""""
NeoBundleLazy 'dag/vim2hs', {
      \ 'autoload' : { 'filetypes' : 'haskell' }
      \ }
NeoBundleLazy 'eagletmt/ghcmod-vim', {
      \ 'autoload' : { 'filetypes' : 'haskell' }
      \ }
NeoBundleLazy 'kana/vim-filetype-haskell', {
      \ 'autoload' : { 'filetypes' : 'haskell' }
      \ }

NeoBundle 'glidenote/memolist.vim'
NeoBundleLazy 'kannokanno/previm', {
      \ 'depends' : 'tyru/open-browser.vim',
      \ 'autoload' : {
      \ 'filetypes' : 'markdown'
      \ }
      \ }
NeoBundleLazy 'tyru/open-browser.vim', {
      \ 'autoload' : {
      \ 'on_source' : ['previm']
      \ }
      \ }

"""""""colorscheme""""""""
NeoBundle 'w0ng/vim-hybrid'
NeoBundle 'chriskempson/vim-tomorrow-theme'
NeoBundle 'ujihisa/unite-colorscheme'
NeoBundle 'altercation/vim-colors-solarized'

"""""""""""cpp""""""""""
NeoBundleLazy 'vim-jp/cpp-vim', {
      \ 'autoload' : {'filetypes' : 'cpp'}
      \ }

NeoBundleLazy 'osyo-manga/vim-marching', {
      \ 'depends' : ['Shougo/vimproc.vim', 'osyo-manga/vim-reunions'],
      \ 'autoload' : {'filetypes' : ['c', 'cpp']}
      \ }

NeoBundle 'rhysd/wandbox-vim'

" too slow!!
" NeoBundleLazy 'osyo-manga/unite-boost-online-doc', {
      " \ 'depends' : [
      " \      'Shougo/unite.vim',
      " \      'tyru/open-browser.vim',
      " \      'mattn/webapi-vim',
      " \   ],
      " \ 'autoload' : {'filetypes' : 'cpp'}
      " \ }

NeoBundleLazy 'kana/vim-altr'
if neobundle#tap('vim-altr')
  call neobundle#config({
        \ 'autoload' : {
        \ 'filetypes' : ['cpp', 'c', 'objc'],
        \ 'mappings' : "<Plug>(altr-",
        \ 'commands' : ['A', 'AS', 'AV']
        \ }
        \ })

  nmap <C-f> <Plug>(altr-forward)
  command! A  call altr#forward()
  command! AS  call s:sp_altr()
  command! AV  call s:vsp_altr()

  function! s:vsp_altr()
    exec 'vs'
    call altr#forward()
  endfunction
  function! s:sp_altr()
    exec 'sp'
    call altr#forward()
  endfunction
  call neobundle#untap()
endif

NeoBundleLazy 'octol/vim-cpp-enhanced-highlight'
if neobundle#tap('vim-cpp-enhanced-highlight')
  call neobundle#config({
        \   'autoload' : {
        \     'filetypes' : 'cpp'
        \   }
        \ })
  let g:cpp_class_scope_highlight = 1
  let g:cpp_experimental_template_highlight = 1

  call neobundle#untap()
endif

NeoBundleLazy 'rhysd/vim-clang-format'
if neobundle#tap('vim-clang-format')
  call neobundle#config({
        \ 'autoload' : { 'filetypes' : ['c', 'cpp', 'objc'] }
        \ })
  let g:clang_format#command = '/usr/local/bin/clang-format'
  let g:clang_format#style_options = {
        \ 'AccessModifierOffset' : -4,
        \ 'AllowShortIfStatementsOnASingleLine' : 'true',
        \ 'AlwaysBreakTemplateDeclarations' : 'true',
        \ 'Standard' : 'C++11',
        \ 'BreakBeforeBraces' : 'Stroustrup',
        \ }
  call neobundle#untap()
endif
NeoBundleLazy 'osyo-manga/vim-snowdrop'

"""""""""markdown"""""""""
NeoBundleLazy 'rcmdnk/vim-markdown'
if neobundle#tap('vim-markdown')
  call neobundle#config({
        \ 'autoload' : {
        \ 'filetypes' : ['markdown']
        \ }
        \})
  function! neobundle#hooks.on_source(bundle)
    let g:vim_markdown_folding_disabled=1
    let g:vim_markdown_math=1
    let g:vim_markdown_frontmatter=1
  endfunction

  call neobundle#untap()
endif

NeoBundleLazy 'godlygeek/tabular'
if neobundle#tap('tabular')
  call neobundle#config({
        \ 'autoload' : {
        \ 'on_source' : ['vim-markdown']
        \ }
        \ })
  call neobundle#untap()
endif

" NeoBundle 'joker1007/vim-markdown-quote-syntax'
" if neobundle#tap('vim-markdown-quote-syntax')
  " call neobundle#config({
    " \ 'autoload' : {
      " \ 'on_source' : ['vim-markdown']
      " \ }
    " \ })
  " call neobundle#untap()
" endif

""""""""""go"""""""""""
NeoBundleLazy 'fatih/vim-go', {
      \ "autoload": {
      \ "filetypes": ['go']
      \ }
      \ }

""""""""""English"""""""""""""""
NeoBundle 'ujihisa/neco-look'

"""""""""""other""""""""""""""""
NeoBundle 'thinca/vim-qfreplace'
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

NeoBundleLazy 'severin-lemaignan/vim-minimap', {
      \ 'autoload' : {
      \ 'commands' : ['Minimap', 'MinimapClose']
      \ }
      \ }


call neobundle#end()


" Brief help
" :NeoBundleList          - list configured bundles
" :NeoBundleInstall(!)    - install(update) bundles
" :NeoBundleClean(!)      - confirm(or auto-approve) removal of unused bundles

syntax on
filetype plugin indent on

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

MyAutoCmd FileType unite call s:unite_my_settings()

" MyAutoCmd BufNewFile,BufRead *.{md,mdwn,mkd,mkdn,mark*} set filetype=markdown
" MyAutoCmd FileType markdown setlocal noautoindent nosmartindent


" display
" ----------------------
set t_Co=256
scriptencoding utf-8

MyAutoCmd Colorscheme * highlight IdeographicSpace term=underline ctermbg=DarkGreen guibg=DarkGreen
MyAutoCmd VimEnter,WinEnter * match IdeographicSpace /　/

set background=dark
colorscheme solarized

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
" tc 新しいタブを一番右に作る
map <silent> T :tabclose<CR>
" T タブを閉じる
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
" inoremap <silent> <C-j> <ESC>

MyAutoCmd BufEnter * setlocal formatoptions-=ro


" vimにcoffeeファイルタイプを認識させる
MyAutoCmd BufRead *.coffee setlocal filetype=coffee
MyAutoCmd BufRead *.coffee nnoremap <buffer> <Leader>cf :CoffeeWatch watch vert<CR>

MyAutoCmd BufEnter *.schema setlocal filetype=ruby

set nocursorline
set nocursorcolumn

hi MatchParen ctermbg=1

nnoremap <CR> o<ESC>
MyAutoCmd FileType qf nnoremap <buffer> <CR> <CR>


" OSのクリップボードを使う
set clipboard+=unnamed

""""""""""gf(Goto File)拡張"""""""""""

" 縦分割版gf
" nnoremap gv :vertical wincmd f<CR>
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

MyAutoCmd FileType vim setlocal foldlevel=0
MyAutoCmd Filetype ruby,coffeescript,cpp setlocal foldlevel=1
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

" key map
" --------------------
nnoremap Q <Nop>

" auto command
" --------------------
MyAutoCmd QuickFixCmdPost *grep* cwindow

" Plugin setting
" --------------------

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
nnoremap <C-n>  :VimFilerBufferDir -split -horizontal -toggle -quit<CR>



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


"""""""""indentLine""""""""""
"""""""""""""""""""""""""""""
" let g:indentLine_faster=1
" let g:indentLine_color_term = 239
" let g:indentLine_color_gui = '#A4E57E'
" let g:indentLine_char = '┊'
" let g:indentLine_char = '▸'
let g:indentLine_showFirstIndentLevel = 2
nnoremap <Leader>ig :IndentLinesToggle<CR>

""""""""""""lightline"""""""""""""""""""""""
" colorscheme default, wombat, jellybeans, solarized, landscape

let g:lightline = {
      \ 'colorscheme': 'solarized',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ], [ 'fugitive', 'filename' ], ['ctrlpmark'] ],
      \   'right': [ [ 'qfstatusline', 'lineinfo' ], ['percent'], [ 'fileformat', 'fileencoding', 'filetype' ] ]
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
      \   'syntaxcheck': 'qfstatusline#Update',
      \ },
      \ 'component_type': {
      \   'syntaxcheck': 'error',
      \ },
      \ 'subseparator': { 'left': '|', 'right': '|' }
      \ }

let g:Qfstatusline#UpdateCmd = function('lightline#update')

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

let g:unite_force_overwrite_statusline = 0
let g:vimfiler_force_overwrite_statusline = 0
let g:vimshell_force_overwrite_statusline = 0

if executable('ag')
  " Use Ag over Grep
  set grepprg=ag\ --nogroup\ --nocolor
  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  " let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
endif


MyAutoCmd BufWritePost Gemfile AlpacaTagsBundle
MyAutoCmd BufEnter * AlpacaTagsSet
MyAutoCmd BufWritePost * AlpacaTagsUpdate
""""""""""Tag Jump拡張"""""""""""
nnoremap <C-]> g<C-]>
" nmap <C-]> :vsp <CR>:exec("tag ".expand("<cword>"))<CR>

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

""""""""""""""""""quickrun"""""""""""""""""""
set splitright
let g:quickrun_config = {}
let b:quickrun_config = {}
let g:quickrun_config._ = {
      \ "runner" : "vimproc",
      \ "runner/vimproc/sleep" : 10,
      \ "runner/vimproc/updatetime" : 500,
      \ 'outputter' : 'quickfix',
      \ "outputter/quickfix/open_cmd" : "copen",
      \ }

let g:quickrun_config['coffee'] = {
      \ 'command' : 'coffee',
      \ 'exec' : ['%c -cbp %s']
      \ }


""USE CLANG++""
if executable("clang++")
  let g:quickrun_config['cpp'] = {
        \ 'command' : 'clang++',
        \ 'cmdopt' : '-std=c++11 --stdlib=libc++ -Wall -Wextra',
        \ 'exec' : '%c %o -o %s:t:r %s:p',
        \ 'hook/quickrunex/enable' : 1,
        \ }

endif


"""""""""""""""vim-watchdogs""""""""
let g:qfsigns#AutoJump = 1

let g:watchdogs_check_BufWritePost_enable = 1
let g:watchdogs_check_BufWritePost_enables = {
      \ 'cpp' : 0,
      \ }
let g:quickrun_config["watchdogs_checker/_"] = {
      \ 'outputter' : 'quickfix',
      \ 'runner/vimproc/updatetime' : 40,
      \ "outputter/quickfix/open_cmd" : "",
      \ 'outputter/quickfix/close_on_empty' : 1,
      \ "hook/copen/enable_exist_data" : 1,
      \ "hook/qfstatusline_update/enable_exit" : 1,
      \ "hook/qfstatusline_update/priority_exit" : 3,
      \ }

let g:quickrun_config['ruby/watchdogs_checker'] = {
      \ 'type' : 'rubocop'
      \}

" let g:quickrun_config['watchdogs_checker/rubocop'] = {
      " \ 'cmdopt' : '-c ~/.rubocop.yml'
      " \}


if neobundle#tap('vim-snowdrop')
  call neobundle#config({
        \ 'autoload' : {
        \ 'filetypes' : ['cpp']
        \ }
        \ })
  " set libclang directory path
  let g:snowdrop#libclang_directory = $LIB_CLANG_DIR

  " set include directory path.
  let g:snowdrop#include_paths = {
        \   "cpp" : []
        \}

  " set clang command options.
  let g:snowdrop#command_options = {
        \   "cpp" : "-std=c++1y",
        \}
  call neobundle#untap()
endif

function! s:cpp()
  setlocal tabstop=4 shiftwidth=4
  """"""""""""vim-cpp"""""""""""
  " setlocal path=.,/usr/include/c++/
  setlocal path+=/Library/Developer/CommandLineTools/usr/include/c++/v1/
  """""""""""unite-boost-online-doc""""
  nnoremap <Space>ub :<C-u>UniteWithCursorWord boost-online-doc
  nnoremap <silent> <Leader>cf :ClangFormat<CR>
  let l:is_cocos_dir = s:cocos2d()
  call s:cpp_watchdogs(l:is_cocos_dir)
endfunction

function! s:cpp_watchdogs(is_cocos_dir)
  let g:quickrun_config['cpp/watchdogs_checker'] = {
        \ 'type' : 'watchdogs_checker/clang++'
        \}

  let g:quickrun_config['watchdogs_checker/clang++'] = {
        \ 'command' : 'clang++',
        \ 'cmdopt' : '--std=c++11 --stdlib=libc++ -Wall -Wextra -I ',
        \ 'exec' : '%c %o -fsyntax-only %s:p',
        \ }
  if a:is_cocos_dir ? 0 : 1
    "have to include cocos2d/cocos/platform/ios and so on
    let l:path_list = map(filter(filter(split(&path, ','),  'isdirectory(v:val)'), 'v:val !~ "^\\.$"'), '"-I " . v:val')
    let l:opt = '--std=c++11 --stdlib=libc++ -Wall -Wextra'
    let g:quickrun_config['watchdogs_checker/clang++'] = {
          \ 'command' : 'clang++',
          \ 'cmdopt' : l:opt . ' ' . join(l:path_list),
          \ 'exec' : '%c %o -fsyntax-only %s:p',
          \ }
  endif
endfunction

function! s:add_marching_include_paths(dirs)
  call extend(g:marching_include_paths, a:dirs)
endfunction

function! s:add_snow_drop_include_paths(dirs)
  call extend(g:snowdrop#include_paths["cpp"], a:dirs)
endfunction

function! s:set_local_path(dirs)
  for dir in a:dirs
    exec 'setlocal path+=' . dir
  endfor
endfunction

function! s:cocos2d()
  execute 'Rooter'
  let b:cocos_dir = globpath(getcwd(), 'cocos2d/cocos/')
  if b:cocos_dir ? 0 : 1
    " call s:add_marching_include_paths(add([], b:cocos_dir))
    " call s:add_snow_drop_include_paths(add([], b:cocos_dir))
    " exec 'setlocal path+=' . b:cocos_dir

    let l:classes_dir = split(globpath(getcwd(), '**/Classes/'), '\n')
    call s:add_marching_include_paths(l:classes_dir)
    call s:set_local_path(l:classes_dir)
    call s:add_snow_drop_include_paths(l:classes_dir)

    let l:palmx_dir = split(globpath(getcwd(), 'PalmXLib/'), '\n')
    call s:add_marching_include_paths(l:palmx_dir)
    call s:set_local_path(l:palmx_dir)
    call s:add_snow_drop_include_paths(l:palmx_dir)
  endif
  return b:cocos_dir
endfunction

MyAutoCmd FileType cpp call s:cpp()

function! s:c()
  setlocal path=.,/usr/include
  setlocal tabstop=4 shiftwidth=4
endfunction

MyAutoCmd FileType c call s:c()

call watchdogs#setup(g:quickrun_config)

"""""""vim-hier""""""""
let g:hier_enabled = 1

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

""""""""""context_filetype.vim"""""""""""
let g:context_filetype#filetypes = {
      \    'html': [
      \        {
      \            'start': '<script>',
      \            'end':   '</script>', 'filetype': 'javascript',},
      \        {
      \            'start': '<script\%( [^>]*\)charset="[^\"]*"\%( [^>]*\)\?>',
      \            'end':   '</script>', 'filetype': 'javascript',},
      \        {
      \            'start': '<script\%( [^>]*\)\? type="text/javascript"\%( [^>]*\)\?>',
      \            'end':   '</script>', 'filetype': 'javascript',},
      \        {
      \            'start': '<script\%( [^>]*\)\? type="text/coffeescript"\%( [^>]*\)\?>',
      \            'end':   '</script>', 'filetype': 'coffee',},
      \        {
      \            'start': '<style\%( [^>]*\)\? type="text/css"\%( [^>]*\)\?>',
      \            'end':   '</style>', 'filetype': 'css',},],}

let g:context_filetype#search_offset = 100

MyAutoCmd InsertEnter * :PreciousSwitch
MyAutoCmd InsertLeave * :PreciousReset
MyAutoCmd User PreciousFileType IndentLinesReset


""""""""""html5"""""""""""
let g:html5_event_handler_attributes_complete = 1
let g:html5_rdfa_attributes_complete = 1
let g:html5_microdata_attributes_complete = 1
let g:html5_aria_attributes_complete = 1

" $CPP_STDLIB よりも下の階層のファイルが開かれて
" filetype が設定されていない場合に filetype=cpp を設定する
MyAutoCmd BufReadPost $CPP_STDLIB/* if empty(&filetype) | set filetype=cpp | endif


""""""""""vim-marching"""""""""""
" clang コマンドの設定
let g:marching_clang_command = "/usr/bin/clang"

" オプションを追加する場合
let g:marching_clang_command_option="-std=c++11"

" インクルードディレクトリのパスを設定
let g:marching_include_paths = ['/Library/Developer/CommandLineTools/usr/include/c++/v1/']

" filter(
      " \ split(glob('/usr/include/c++/*/'), '\n'),
      " \ 'isdirectory(v:val)'
      " \ ) + ['/Library/Developer/CommandLineTools/usr/include/c++/v1/']

" neocomplete.vim と併用して使用する場合は以下の設定を行う
let g:marching_enable_neocomplete = 1

if !exists('g:neocomplete#force_omni_input_patterns')
  let g:neocomplete#force_omni_input_patterns = {}
endif

let g:neocomplete#force_omni_input_patterns.cpp =
      \ '[^.[:digit:] *\t]\%(\.\|->\)\w*\|\h\w*::\w*'

""""""""""lexima.vim"""""""""""""""
inoremap <C-j> <C-r>=lexima#insmode#escape()<CR><Esc>
" if neobundle#tap('lexima.vim')
  " let g:lexima_no_default_rules = 1
  " call lexima#set_default_rules()

  """"""""(  )""""""""""
  " call lexima#add_rule({
        " \   'at': '(\%#)',
        " \   'char': '<Space>',
        " \   'input': '<Space>',
        " \   'input_after': '<Space>',
        " \   })

  " call lexima#add_rule({
        " \   'at': '( \%# )',
        " \   'char': '<BS>',
        " \   'input': '<BS>',
        " \   'delete': 1,
        " \   })

  " call lexima#add_rule({
        " \   'at'    : '\%# )',
        " \   'char'  : ')',
        " \   'leave' : 2
        " \   })

  " """"""""{  }""""""""""
  " call lexima#add_rule({
        " \   'at'    : '{\%#}',
        " \   'char'  : '<Space>',
        " \   'input' : '<Space>',
        " \   'input_after' : '<Space>'
        " \   })

  " call lexima#add_rule({
        " \   'at'    : '{ \%# }',
        " \   'char'  : '<BS>',
        " \   'input' : '<BS>',
        " \   'delete' : 2
        " \   })

  " call lexima#add_rule({
        " \   'at'    : '\%# }',
        " \   'char'  : '}',
        " \   'leave' : 2
        " \   })

  " call lexima#add_rule({
        " \   'at'       : '"\%#"',
        " \   'char'     : '#',
        " \   'input'    : '#{',
        " \   'insert_after' : '}',
        " \   'filetype' : ['ruby'],
        " \ })

  " call neobundle#untap()
" endif

"""""""""NeoComplete || NeoComplcache"""""""
if neobundle#tap('neocomplete')
  let g:neocomplete_text_mode_filetypes = {
        \ 'text' : 1,
        \ 'txt' : 1
        \}
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
        \ 'ruby'    : $HOME.'/.vim/dict/ruby.dict',
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
  imap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
  function! s:my_cr_function()
    return neocomplete#close_popup() . "\<CR>"
    " For no inserting <CR> key.
    " return pumvisible() ? neocomplete#close_popup() : "\<CR>"
  endfunction

  " <TAB>: completion.
  inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
  inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<S-TAB>"
  " <C-h>, <BS>: close popup and delete backword char.
  imap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
  imap <expr><BS> neocomplete#smart_close_popup()."\<BS>"
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
  if !exists('g:neocomplete#sources#omni#input_patterns')
    let g:neocomplete#sources#omni#input_patterns = {}
  endif
  let g:neocomplete#sources#omni#input_patterns.php = '[^.  \t]->\h\w*\|\h\w*::'
  let g:neocomplete#sources#omni#input_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'
  let g:neocomplete#sources#omni#input_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'

  let g:neocomplete#force_overwrite_completefunc = 1
  call neobundle#untap()
endif
if neobundle#tap('neocomplcache.vim')
  let g:acp_enableAtStartup = 0
  " Use neocomplcache.
  let g:neocomplcache_enable_at_startup = 1
  " Use smartcase.
  let g:neocomplcache_enable_smart_case = 1
  " Set minimum syntax keyword length.
  let g:neocomplcache_min_syntax_length = 3
  let g:neocomplcache_lock_buffer_name_pattern = '\*ku\*'

  " Enable heavy features.
  " Use camel case completion.
  "let g:neocomplcache_enable_camel_case_completion = 1
  " Use underbar completion.
  "let g:neocomplcache_enable_underbar_completion = 1

  " Define dictionary.
  let g:neocomplcache_dictionary_filetype_lists = {
        \ 'default' : '',
        \ 'vimshell' : $HOME.'/.vimshell_hist',
        \ 'scheme' : $HOME.'/.gosh_completions'
        \ }

  " Define keyword.
  if !exists('g:neocomplcache_keyword_patterns')
    let g:neocomplcache_keyword_patterns = {}
  endif
  let g:neocomplcache_keyword_patterns['default'] = '\h\w*'

  " Plugin key-mappings.
  inoremap <expr><C-g>     neocomplcache#undo_completion()
  inoremap <expr><C-l>     neocomplcache#complete_common_string()

  " Recommended key-mappings.
  " <CR>: close popup and save indent.
  inoremap <silent> <CR> <C-r>=<SID>cache_my_cr_function()<CR>
  function! s:cache_my_cr_function()
    return neocomplcache#smart_close_popup() . "\<CR>"
    " For no inserting <CR> key.
    "return pumvisible() ? neocomplcache#close_popup() : "\<CR>"
  endfunction

  " <TAB>: completion.
  inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
  inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<S-TAB>"
  " <C-h>, <BS>: close popup and delete backword char.
  imap <expr><C-h> neocomplcache#smart_close_popup()."\<C-h>"
  imap <expr><BS> neocomplcache#smart_close_popup()."\<BS>"
  inoremap <expr><C-y>  neocomplcache#close_popup()
  inoremap <expr><C-e>  neocomplcache#cancel_popup()

  " Enable omni completion.
  autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
  autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
  autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
  autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
  autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

  " Enable heavy omni completion.
  if !exists('g:neocomplcache_force_omni_patterns')
    let g:neocomplcache_force_omni_patterns = {}
  endif
  let g:neocomplcache_force_omni_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
  let g:neocomplcache_force_omni_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'
  let g:neocomplcache_force_omni_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'

  call neobundle#untap()
endif

"""""""""""""""""neorspec""""""""""""""""""""""
function! s:rspec_cmd()
  if executable(getcwd().'/bin/rspec')
    return 'bin/spring rspec'
  else
    return 'bundle exec rspec'
  endif
endfunction

let g:neorspec_command = "Dispatch " . s:rspec_cmd() . " --color --format documentation {spec}"

function! s:load_rspec_settings()
  nnoremap <buffer> ,rc  :RSpecCurrent<CR>
  nnoremap <buffer> ,rn  :RSpecNearest<CR>
  nnoremap <buffer> ,rl  :RSpecRetry<CR>
  nnoremap <buffer> ,ra  :RSpecAll<CR>
  nnoremap <buffer> ,r   :RSpec<Space>
endfunction

MyAutoCmd BufWinEnter *_spec.rb call s:load_rspec_settings()
""""""""""""""go"""""""""""""
" :Fmt などで gofmt の代わりに goimports を使う
" let g:gofmt_command = 'goimports'

" Go に付属の plugin と gocode を有効にする
if $GOROOT != ''
  set rtp+=${GOROOT}/misc/vim
endif
if $GOPATH != ''
  set rtp+=${GOPATH}/src/github.com/nsf/gocode/vim
endif

" 保存時に :Fmt する
au BufWritePre *.go Fmt
au BufNewFile,BufRead *.go set sw=4 noexpandtab ts=4
au FileType go compiler go
