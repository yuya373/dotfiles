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
      \ }
NeoBundle 'https://github.com/vim-jp/vimdoc-ja'
NeoBundle 'tpope/vim-fugitive'
" NeoBundleLazy 'tpope/vim-fugitive', {
"       \ 'autoload' : {
"       \ 'commands' : ['Git', 'Git!', 'Gstatus', 'Glog', 'Gblame']
"       \ }
"       \ }
NeoBundleLazy 'Lokaltog/vim-easymotion', {
      \ 'autoload' : {
      \ 'mappings' : '<Plug>'
      \ }
      \ }
NeoBundle 'vim-scripts/vim-auto-save'
NeoBundle 'rking/ag.vim'
NeoBundle 'Yggdroot/indentLine'
NeoBundleLazy 't9md/vim-choosewin', {
      \ 'autoload' : {
      \ 'on_source' : 'unite.vim',
      \ 'mappings' : '<Plug>'
      \ }
      \ }

NeoBundle 'Shougo/neosnippet-snippets'
NeoBundleLazy 'cohama/agit.vim', {
      \ 'autoload' : {
      \ 'commands' : ['Agit', 'AgitFile']
      \ }
      \ }

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

NeoBundle 'Shougo/context_filetype.vim'
NeoBundleLazy 'osyo-manga/vim-precious', {
      \ 'autoload' : {
      \ 'filetypes' : ['markdown', 'vim'],
      \ 'commands' : ['PreciousReset', 'PreciousSwitch', 'PreciousFileType']
      \ }
      \ }

NeoBundle 'mattn/emoji-vim'

NeoBundle "osyo-manga/shabadou.vim", {
  \ 'autoload' : {
  \ 'on_source' : ['vim-watchdogs']
  \ }
  \ }
NeoBundle "osyo-manga/vim-watchdogs", {
      \ 'depends' : ['thinca/vim-quickrun', 'osyo-manga/shabadou.vim']
      \ }
NeoBundle 'cohama/vim-hier'
NeoBundle "dannyob/quickfixstatus"
NeoBundle "KazuakiM/vim-qfstatusline"
NeoBundle 'KazuakiM/vim-qfsigns'

NeoBundleLazy "tyru/caw.vim", {
      \ 'autoload' : {
      \ 'mappings' : ['<Plug>']
      \ }
      \ }

NeoBundleLazy 'alpaca-tc/alpaca_tags', {
      \ 'depends': ['Shougo/vimproc'],
      \ 'autoload' : {
      \   'commands' : [
      \     { 'name' : 'AlpacaTagsBundle', 'complete': 'customlist,alpaca_tags#complete_source' },
      \     { 'name' : 'AlpacaTagsUpdate', 'complete': 'customlist,alpaca_tags#complete_source' },
      \     'AlpacaTagsSet', 'AlpacaTagsCleanCache', 'AlpacaTagsEnable', 'AlpacaTagsDisable', 'AlpacaTagsKillProcess', 'AlpacaTagsProcessStatus',
      \ ],
      \ }}

NeoBundleLazy 'haya14busa/incsearch.vim', {
      \ 'autoload' : {
      \ 'mappings' : '<Plug>'
      \ }
      \ }

NeoBundleLazy 'diffchar.vim', {
      \ 'autoload' : {
      \ 'commands' : 'SDChar'
      \ }
      \ }
NeoBundle 'cohama/lexima.vim'

NeoBundleLazy 'Shougo/vimfiler', {
      \ 'autoload' : {
      \ 'commands' : ['VimFilerBufferDir', 'VimFiler']
      \ }
      \ }

NeoBundleLazy 'Shougo/vimshell.vim', {
  \ 'depends' : [ 'Shougo/vimproc.vim' ],
  \ 'autoload' : {
  \ 'commands' : ['VimShell', 'VimShellPop', 'VimShellTab']
  \ }
  \ }

NeoBundleLazy 'supermomonga/vimshell-pure.vim', {
  \ 'depends' : [ 'Shougo/vimshell.vim' ] ,
  \ 'autoload' : {
  \ 'on_source' : ['vimshell.vim']
  \ }
  \ }

NeoBundleLazy 'LeafCage/nebula.vim', {
      \ 'autoload' : {
      \ 'commands' : [
      \ 'NebulaPutLazy', 'NebulaYankTap', 'NebulaPutConfig',
      \ 'NebulaYankOptions', 'NebulaPutFromClipboard'
      \ ]
      \ }
      \ }

NeoBundle has('lua') ? 'Shougo/neocomplete' : 'Shougo/neocomplcache.vim'

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
NeoBundleLazy 'tacroe/unite-mark', {
      \ 'depends' : 'Shougo/unite.vim',
      \ 'autoload' : {
      \ 'on_source': ['unite.vim']
      \ }
      \ }

NeoBundleLazy 'osyo-manga/unite-choosewin-actions', {
      \ 'depends' : ['Shougo/unite.vim', 't9md/vim-choosewin'],
      \ 'autoload' : {
      \ 'on_source' : ['unite.vim']
      \ }
      \ }
NeoBundleLazy 'Shougo/unite-outline', {
      \ 'depends' : 'Shougo/unite.vim',
      \ 'autoload' : {
      \ 'on_source' : ['unite.vim']
      \ }
      \ }
NeoBundleLazy 'Shougo/unite.vim', {
      \ 'depends' : 'Shougo/vimproc.vim',
      \ 'autoload' : {
      \ 'commands' : [
      \ 'UniteWithBufferDir', 'UniteResume', 'Unite', 'UniteResume'
      \ ]
      \ }
      \ }

NeoBundleLazy 'Shougo/neomru.vim', {
      \ 'depends' : 'unite.vim',
      \ 'autoload' : {
      \ 'on_source' : ['unite.vim']
      \ }
      \ }
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
      \ 'autoload' : {
      \ 'filetypes' : 'cpp'
      \ }
      \ }

NeoBundleLazy 'osyo-manga/vim-marching', {
      \ 'depends' : ['Shougo/vimproc.vim', 'osyo-manga/vim-reunions'],
      \ 'autoload' : {
      \ 'filetypes' : ['c', 'cpp']
      \ }
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

NeoBundleLazy 'kana/vim-altr',{
      \ 'autoload' : {
      \ 'filetypes' : ['cpp', 'c', 'objc'],
      \ 'mappings' : "<Plug>(altr-",
      \ 'commands' : ['A', 'AS', 'AV']
      \ }
      \ }
NeoBundleLazy 'octol/vim-cpp-enhanced-highlight',{
      \   'autoload' : {
      \     'filetypes' : 'cpp'
      \   }
      \ }
NeoBundleLazy 'rhysd/vim-clang-format', {
        \ 'autoload' : { 'filetypes' : ['c', 'cpp', 'objc'] }
        \ }
NeoBundleLazy 'osyo-manga/vim-snowdrop', {
        \ 'autoload' : {
        \ 'filetypes' : ['cpp']
        \ }
        \ }

"""""""""markdown"""""""""
NeoBundleLazy 'rcmdnk/vim-markdown', {
        \ 'autoload' : {
        \ 'filetypes' : ['markdown']
        \ }
        \ }

NeoBundleLazy 'godlygeek/tabular', {
        \ 'autoload' : {
        \ 'on_source' : ['vim-markdown']
        \ }
        \ }
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


NeoBundleLazy 'supermomonga/jazzradio.vim', {
      \   'depends' : [ 'Shougo/unite.vim' ],
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
      \ }

NeoBundleLazy 'severin-lemaignan/vim-minimap', {
      \ 'autoload' : {
      \ 'commands' : ['Minimap', 'MinimapClose']
      \ }
      \ }

NeoBundle 'itchyny/vim-autoft'

NeoBundleLazy 'ryanss/vim-hackernews', {
      \ 'autoload' : {
      \ 'commands' : ['HackerNews']
      \ }
      \ }

NeoBundleLazy 'koron/codic-vim', {
      \ 'autoload' : {
      \ 'commands' : ['Codic']
      \ }
      \ }

NeoBundleLazy 'rhysd/unite-codic.vim', {
      \ 'depends' : ['Shougo/unite.vim', 'koron/codic-vim'],
      \ 'autoload' :{
      \ 'on_source' : ['unite.vim']
      \ }
      \ }

NeoBundleLazy 'junegunn/vim-github-dashboard', {
      \ 'autoload' : {
      \ 'commands' : ['GHA', 'GHD']
      \ }
      \ }

NeoBundle 'supermomonga/thingspast.vim'

NeoBundle 'yuya373/github-issues.vim', 'fix_for_unicode_encodeerror'

NeoBundleLazy 'yuratomo/w3m.vim', {
      \ 'autoload' : {
      \ 'commands' : [
      \ 'W3m', 'W3mTab', 'W3mSplit', 'W3mVSplit'
      \ ]
      \ }
      \ }

NeoBundleCheck

call neobundle#end()
