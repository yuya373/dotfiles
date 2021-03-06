if neobundle#tap('vim-fugitive')
  nnoremap <Leader>gg :Gstatus<CR>
  call neobundle#untap()
endif

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
  call neobundle#untap()
endif


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
    let g:choosewin_return_on_single_win = 0
  endfunction
  nmap  `  <Plug>(choosewin)
  call neobundle#untap()
endif

if neobundle#tap('agit.vim')
  function! neobundle#hooks.on_source(bundle)
    let g:agit_localchanges_always_on_top = 0
  endfunction
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

  function! s:agit_mapping() abort
    nmap <buffer> cp <Plug>(agit-git-cherry-pick)
  endfunction

  augroup AgitMapping
    autocmd!
    autocmd FileType agit call s:agit_mapping()
  augroup END
  call neobundle#untap()
endif

if neobundle#tap('vim-easy-align')
  " Start interactive EasyAlign in visual mode (e.g. vip<Enter>)
  vmap <CR> <Plug>(EasyAlign)

  " Start interactive EasyAlign for a motion/text object (e.g. <Leader>aip)
  " nmap <Leader>a <Plug>(EasyAlign)
  call neobundle#untap()
endif

if neobundle#tap('vim-precious')
  function! neobundle#hooks.on_source(bundle)
    let g:precious_enable_switch_CursorMoved = {
          \    '*' : 0,}
    let g:precious_enable_switch_CursorMoved_i = {
          \    '*' : 0,}
  endfunction
  call neobundle#untap()
endif

if neobundle#tap('caw.vim')
  nmap ,, <Plug>(caw:i:toggle)
  vmap ,, <Plug>(caw:i:toggle)
  call neobundle#untap()
endif

if neobundle#tap('alpaca_tags')
  function! neobundle#hooks.on_source(bundle)
    let g:alpaca_tags#ctags_bin = exepath('ctags')
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

if neobundle#tap('diffchar.vim')
  function! neobundle#hooks.on_source(bundle)
    let g:DiffUnit = "Word3"
    let g:DiffUpdate = 1
  endfunction

  if &diff
    augroup PluginDiffchar
      autocmd!
      autocmd VimEnter * execute "%SDChar"
    augroup END
  endif

  call neobundle#untap()
endif

if neobundle#tap('vimshell.vim')
  let g:vimshell_vimshrc_path = "~/dotfiles/.vimshrc"
  nnoremap <Space>ss :VimShellPop -toggle<CR>
  nnoremap <Space>st :VimShellTab<CR>
  call neobundle#untap()
endif

if neobundle#tap('nebula.vim')
  nnoremap <silent>,bl    :<C-u>NebulaPutLazy<CR>
  nnoremap <silent>,bc    :<C-u>NebulaPutConfig<CR>
  nnoremap <silent>,by    :<C-u>NebulaYankOptions<CR>
  nnoremap <silent>,bp    :<C-u>NebulaPutFromClipboard<CR>
  nnoremap <silent>,bt    :<C-u>NebulaYankTap<CR>
  call neobundle#untap()
endif

if neobundle#tap('unite.vim')
  function! neobundle#hooks.on_source(bundle)
    " let g:unite_enable_start_insert = 1
    "  " unite grep に ag(The Silver Searcher) を使う
    if executable('ag')
      let g:unite_source_rec_async_command =
            \ 'ag --follow --nocolor --nogroup --hidden -g ""'
      let g:unite_source_grep_command = 'ag'
      let g:unite_source_grep_default_opts = '--nogroup --nocolor --column'
      let g:unite_source_grep_recursive_opt = ''
    endif
    let g:unite_enable_ignore_case = 1
    let g:unite_enable_smart_case = 1
    call unite#custom#default_action('file' , 'choosewin/open')
    call unite#custom#default_action('buffer' , 'choosewin/open')
    call unite#custom#default_action('grep' , 'choosewin/open')
    let g:unite_source_rec_max_cache_files = 50000
    let g:unite_source_file_rec_max_cache_files = 50000
    call unite#filters#matcher_default#use(['matcher_fuzzy'])
    call unite#filters#sorter_default#use(['sorter_selecta'])
    call unite#custom#profile('default', 'context', {
          \   'start_insert' : 1
          \ })
    call unite#custom#profile('source/quickfix', 'context', {
          \ 'start_insert' : 0,
          \ })

    function! s:unite_gitignore_source()
      let pattern = s:gitignore_source()
      " call unite#custom#source('file_rec', 'ignore_pattern', pattern)
      call unite#custom#source('file_rec/git', 'ignore_pattern', pattern)
      call unite#custom#source('file_rec/async', 'ignore_pattern', pattern)
      " call unite#custom#source('grep', 'ignore_pattern', pattern)
    endfunction

  call s:unite_gitignore_source()

  endfunction

  " The prefix key.
  nnoremap    [unite]   <Nop>
  nmap    ,u [unite]

  nnoremap <silent> [unite]t  :<C-u>Unite tab<CR>
  nnoremap <silent> [unite]o  :<C-u>Unite outline<CR>
  nnoremap <silent> [unite]ma :<C-u>Unite mark<CR>
  nnoremap <silent> [unite]mp :<C-u>Unite mapping<CR>
  nnoremap <silent> [unite]b  :<C-u>Unite buffer<CR>
  nnoremap <silent> [unite]p  :<C-u>Unite -buffer-name=register register<CR>
  nnoremap <silent> [unite]y  :<C-u>Unite yankround<CR>
  nnoremap <silent> [unite]u  :<C-u>Unite file_mru<CR>
  nnoremap <silent> [unite]r  :<C-u>UniteWithProjectDir file file/new directory/new -buffer-name=root<CR>
  nnoremap <silent> [unite]f  :<C-u>UniteWithBufferDir file file/new directory/new -buffer-name=files<CR>
  " grep検索
  nnoremap <silent> ,g  :<C-u>Unite grep:. -buffer-name=search-buffer<CR>
  " カーソル位置の単語をgrep検索
  nnoremap <silent> ,cg :<C-u>Unite grep:. -buffer-name=search-buffer<CR><C-R><C-W><CR>
  " grep検索結果の再呼出
  nnoremap <silent> ,r  :<C-u>UniteResume search-buffer<CR>
  "mark一覧
  nnoremap <silent> ,m :<C-u>Unite mark<CR>
  nnoremap <silent> <C-p> :<C-u>Unite -start-insert file_rec/async:!<CR>
  " nnoremap <silent> <C-p> :<C-u>call AsyncOrGir()<CR>

  function! AsyncOrGir()
    echom 'AsyncOrGir()'
    if isdirectory('./.git')
      echom 'Git'
      exe 'Unite -start-insert file_rec/git'
    else
      echom 'Not a Git'
      exe 'Unite -start-insert file_rec/async:!'
    endif
  endfunction

  function! s:cd_root_and_unite(...)
    let args = join(a:000, ' ')
    execute 'Rooter'
    execute 'Unite -start-insert file_rec/async:!'.' '.args
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
    nnoremap <silent> [unite]rc  :RootAndUnite file file/new directory/new -input=app/controllers/ -buffer-name=controllers<CR>
    nnoremap <silent> [unite]rm  :RootAndUnite file file/new directory/new -input=app/models/ -buffer-name=models<CR>
    nnoremap <silent> [unite]rd  :RootAndUnite file file/new directory/new -input=app/decorators/ -buffer-name=decorators<CR>
    nnoremap <silent> [unite]rv  :RootAndUnite file file/new directory/new -input=app/views/ -buffer-name=views<CR>
    nnoremap <silent> [unite]rj  :RootAndUnite file file/new directory/new -input=app/assets/javascripts/ -buffer-name=js<CR>
    nnoremap <silent> [unite]ra  :RootAndUnite file file/new directory/new -input=app/ -buffer-name=app<CR>
    nnoremap <silent> [unite]rl  :RootAndUnite file file/new directory/new -input=lib/ -buffer-name=lib<CR>
    nnoremap <silent> [unite]rsm :RootAndUnite file file/new directory/new -input=spec/models/ -buffer-name=spec/models<CR>
    nnoremap <silent> [unite]rsl :RootAndUnite file file/new directory/new -input=spec/lib/ -buffer-name=spec/lib<CR>
    nnoremap <silent> [unite]rsr :RootAndUnite file file/new directory/new -input=spec/requests/ -buffer-name=spec/requests<CR>
    nnoremap <silent> [unite]rsf :RootAndUnite file file/new directory/new -input=spec/factories/ -buffer-name=spec/factories<CR>
    nnoremap <silent> [unite]rss :RootAndUnite file file/new directory/new -input=spec/services/ -buffer-name=spec/factories<CR>
    nnoremap <silent> [unite]rS  :RootAndUnite file file/new directory/new -input=spec/ -buffer-name=spec<CR>
  endif


  function! s:unite_my_settings()
    " 単語単位からパス単位で削除するように変更
    nmap <buffer><ESC> <Plug>(unite_exit)
    imap <buffer> <C-w> <Plug>(unite_delete_backward_path)
    let unite = unite#get_current_unite()
    nnoremap <buffer> <expr> <C-f> unite#do_action('choosewin/split')
    inoremap <buffer> <expr> <C-f> unite#do_action('choosewin/split')
    nnoremap <buffer> <expr> <C-v> unite#do_action('choosewin/vsplit')
    inoremap <buffer> <expr> <C-v> unite#do_action('choosewin/vsplit')
    " dwm.vim で開く
    " nnoremap <silent> <buffer> <expr> <c-o> unite#do_action('dwm_new')
    " inoremap <silent> <buffer> <expr> <c-o> unite#do_action('dwm_new')
  endfunction

  augroup UniteMapping
    autocmd!
    autocmd filetype unite call s:unite_my_settings()
  augroup END

  call neobundle#untap()
endif

if neobundle#tap('vim-altr')
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

if neobundle#tap('vim-cpp-enhanced-highlight')
  function! neobundle#hooks.on_source(bundle)
    let g:cpp_class_scope_highlight = 1
    let g:cpp_experimental_template_highlight = 1
  endfunction

  call neobundle#untap()
endif

if neobundle#tap('vim-clang-format')
  function! neobundle#hooks.on_source(bundle)
    let g:clang_format#command = '/usr/local/bin/clang-format'
    let g:clang_format#style_options = {
          \ 'AccessModifierOffset' : -4,
          \ 'AllowShortIfStatementsOnASingleLine' : 'true',
          \ 'AlwaysBreakTemplateDeclarations' : 'true',
          \ 'Standard' : 'C++11',
          \ 'BreakBeforeBraces' : 'Stroustrup',
          \ }
  endfunction
  call neobundle#untap()
endif

if neobundle#tap('vim-markdown')
  function! neobundle#hooks.on_source(bundle)
    let g:vim_markdown_folding_disabled=1
    let g:vim_markdown_math=1
    let g:vim_markdown_frontmatter=1
  endfunction

  call neobundle#untap()
endif

if neobundle#tap('vim-rails')
  function! neobundle#hooks.on_source(bundle)
    let g:rails_default_file='config/database.yml'
    let g:rails_level = 3
    let g:rails_mappings=1
    let g:rails_modelines=0
    let g:rails_some_option = 1
    let g:rails_statusline = 1
    let g:rails_subversion=0
    let g:rails_syntax = 1
    let g:rails_url='http://localhost:3000'
  endfunction

  call neobundle#untap()
endif

if neobundle#tap('vimfiler')
  function! neobundle#hooks.on_source(bundle)
  let g:vimfiler_safe_mode_by_default = 0
  let g:vimfiler_as_default_explorer = 1
  " Like Textmate icons.
  " let g:vimfiler_tree_leaf_icon = ' '
  " let g:vimfiler_tree_opened_icon = '▾'
  " let g:vimfiler_tree_closed_icon = '▸'
  " let g:vimfiler_file_icon = '-'
  " let g:vimfiler_marked_file_icon = '*'
  endfunction

  nnoremap <C-n>  :VimFilerBufferDir -split -horizontal -toggle -quit<CR>
  call neobundle#untap()
endif

if neobundle#tap('neosnippet')

  function! neobundle#hooks.on_source(bundle)
    " Tell Neosnippet about the other snippets
    let g:neosnippet#snippets_directory='~/.vim/bundle/vim-snippets/snippets'
  endfunction


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

  call neobundle#untap()
endif

if neobundle#tap('indentLine')
  " function! neobundle#hooks.on_source(bundle)
    " let g:indentLine_faster=1
    " let g:indentLine_color_term = 239
    " let g:indentLine_color_gui = '#A4E57E'
    " let g:indentLine_char = '┊'
    " let g:indentLine_char = '▸'
    let g:indentLine_showFirstIndentLevel = 2
    let g:indentLine_enabled = 1
  " endfunction

  nnoremap <Leader>ig :IndentLinesToggle<CR>

  call neobundle#untap()
endif

if neobundle#tap('lightline.vim')
  let g:lightline = {
        \ 'colorscheme': 'solarized',
        \ 'active': {
        \   'left': [ [ 'mode', 'paste' ], [ 'fugitive', 'readonly', 'filename', 'modified' ] ],
        \   'right': [ [ 'qfstatusline', 'lineinfo' ], ['percent'], [ 'fileformat', 'fileencoding', 'filetype' ] ]
        \ },
        \ 'component_function': {
        \   'fugitive': 'MyFugitive',
        \   'filename': 'MyFilename',
        \   'fileformat': 'MyFileformat',
        \   'filetype': 'MyFiletype',
        \   'fileencoding': 'MyFileencoding',
        \   'mode': 'MyMode',
        \   'modified': 'MyModified',
        \   'readonly': 'MyReadonly',
        \ },
        \ 'component_expand': {
        \   'qfstatusline': 'qfstatusline#Update',
        \ },
        \ 'component_type': {
        \   'qfstatusline': 'error',
        \ },
        \ 'subseparator': { 'left': '|', 'right': '|' }
        \ }
  let g:tagbar_status_func = 'TagbarStatusFunc'
  let g:unite_force_overwrite_statusline = 0
  let g:vimfiler_force_overwrite_statusline = 0
  let g:vimshell_force_overwrite_statusline = 0

  function! MyModified()
    return &ft =~ 'help' ? '' : &modified ? '+' : &modifiable ? '' : '-'
  endfunction

  function! MyReadonly()
    return &ft !~? 'help' && &readonly ? 'RO' : ''
  endfunction

  function! MyFilename()
    let dname = expand('%:h') "vim/userautoloads
    let fname =  dname.'/'.expand('%:t') "plugin.vim
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
    if exists("*fugitive#head")
      let _ = fugitive#head()
      return strlen(_) ? '⭠ '._ : ''
    endif
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

  function! TagbarStatusFunc(current, sort, fname, ...) abort
    let g:lightline.fname = a:fname
    return lightline#statusline(0)
  endfunction

  call neobundle#untap()
endif

if neobundle#tap('unite-choosewin-actions')
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

  call neobundle#untap()
endif

if neobundle#tap('vim-quickrun')
    let g:quickrun_config = {}
    let g:quickrun_config._ = {
          \ "runner" : "vimproc",
          \ "runner/vimproc/sleep" : 10,
          \ "runner/vimproc/updatetime" : 50,
          \ 'outputter' : 'buffer',
          \ 'outputter/quickfix/open_cmd' : "copen",
          \ 'outputter/quickfix/close_on_empty' : 1,
          \ 'hook/inu/enable' : 1,
          \ 'hook/inu/weight' : 10,
          \ 'hook/inu/echo' : 1,
          \ 'hook/back_tabpage/enable': 1,
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

    augroup QuickRunRspec
      autocmd!
      autocmd BufWinEnter *_spec.rb call s:quickrun_rspec()
    augroup END

    function! s:quickrun_rspec()
      " if executable(getcwd().'/bin/spring')
      "   let b:quickrun_config = { 'type' : 'rspec/spring' }
      " else
        let b:quickrun_config = { 'type' : 'rspec/bundler' }
      " endif

    nnoremap <buffer> ,rc :<C-u>QuickRun<CR>
    nnoremap <buffer> ,rn :<C-u>call QuickRunRspecNearest()<CR>
    endfunction

    function! QuickRunRspecNearest()
      let src = ":".line('.')
      exe 'QuickRun -args '.src
    endfunction

    let g:quickrun_config['rspec/spring'] = {
          \ 'command' : 'rspec',
          \ 'cmdopt' : '--format documentation -c -p 10',
          \ 'outputter' : 'buffer',
          \ 'outputter/buffer/split' : 'bot 10sp',
          \ 'exec' : './bin/spring rspec %o %s%a',
          \ }
    let g:quickrun_config['rspec/bundler'] = {
          \ 'command' : 'rspec',
          \ 'cmdopt' : '--format documentation -c -p 10',
          \ 'outputter' : 'buffer',
          \ 'outputter/buffer/split' : 'bot 10sp',
          \ 'exec' : 'bundle exec rspec %o %s%a',
          \ }

  call neobundle#untap()
endif

if neobundle#tap('vim-watchdogs')
    let g:watchdogs_check_BufWritePost_enable = 1
    let g:watchdogs_check_BufWritePost_enables = {
          \ 'cpp' : 0,
          \ }

    let g:quickrun_config["watchdogs_checker/_"] = {
          \ 'outputter' : 'quickfix',
          \ 'runner/vimproc/updatetime' : 40,
          \ 'hook/copen/enable_exist_data' : 1,
          \ "hook/echo/enable" : 1,
          \ "hook/echo/output_success": "> No Errors Found.",
          \ "hook/qfstatusline_update/enable_exit" : 1,
          \ "hook/qfstatusline_update/priority_exit" : 4,
          \ 'hook/hier_update/enable_exit' : 1,
          \ 'hook/hier_update/priority_exit' : 4,
          \ 'hook/quickfix_status_enable/enable_exit' : 1,
          \ 'outputter/quickfix/open_cmd' : "",
          \ }

          " \ 'hook/unite_quickfix/enable_exist_data' : 1,
          " \ 'hook/unite_quickfix/no_focus' : 1,
          " \ 'hook/unite_quickfix/buffer_name' : 'quickrun-hook-unite-quick-fix',
          " \ 'hook/unite_quickfix/unite_options' : "-no-quit -winheight=10 -max-multi-lines=32 -no-start-insert -default-action=open",
    " quickrun終わったら自動で呼びたい
    " HierUpdate
    " QuickfixStatusEnable
    " QfstatuslineUpdate

    let g:quickrun_config['cpp/watchdogs_checker'] = {
          \ 'type' : 'watchdogs_checker/clang++',
          \ 'cmdopt' : '-std=c++11 --stdlib=libc++ -Wall -Wextra'
          \ }

    let g:quickrun_config['c/watchdogs_checker'] = {
          \ 'type' : 'watchdogs_checker/gcc',
          \ 'cmdopt' : '-Wall'
          \ }

    let g:quickrun_config['ruby/watchdogs_checker'] = {
          \ 'type' : 'rubocop',
          \ 'outputter' : 'quickfix',
          \ 'runner/vimproc/updatetime' : 40,
          \ "hook/echo/enable" : 1,
          \ "hook/echo/output_success": "> No Errors Found.",
          \ "hook/qfstatusline_update/enable_exit" : 1,
          \ "hook/qfstatusline_update/priority_exit" : 4,
          \ 'hook/hier_update/enable_exit' : 1,
          \ 'hook/hier_update/priority_exit' : 4,
          \ 'hook/quickfix_status_enable/enable_exit' : 1,
          \ 'outputter/quickfix/open_cmd' : "",
          \ }

    let g:quickrun_config['watchdogs_checker/rubocop'] = {
          \ }

    call watchdogs#setup(g:quickrun_config)

  call neobundle#untap()
endif

if neobundle#tap('vim-qfsigns')
  function! neobundle#hooks.on_source(bundle)
    let g:qfsigns#AutoJump = 1
  endfunction

  call neobundle#untap()
endif

if neobundle#tap('vim-snowdrop')
  function! neobundle#hooks.on_source(bundle)
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
    endfunction

  call neobundle#untap()
endif

if neobundle#tap('vim-hier')
  function! neobundle#hooks.on_source(bundle)
    let g:hier_enabled = 1
  endfunction

  call neobundle#untap()
endif

if neobundle#tap('vim-json')
  function! neobundle#hooks.on_source(bundle)
    let g:vim_json_syntax_conceal = 0
  endfunction

  call neobundle#untap()
endif

if neobundle#tap('memolist.vim')
  " function! neobundle#hooks.on_source(bundle)
    let g:memolist_path = "~/Dropbox/memo"
    let g:memolist_unite = 1
    let g:memolist_unite_source = "file_rec"
    let g:memolist_unite_option = "-start-insert"
    let g:memolist_memo_date = "%Y-%m-%d-%a %H:%M"
  " endfunction

  nnoremap <Leader>mn  :MemoNew<CR>
  nnoremap <Leader>ml  :MemoList<CR>
  nnoremap <Leader>mg  :MemoGrep<CR>

  call neobundle#untap()
endif

if neobundle#tap('open-browser.vim')
  function! neobundle#hooks.on_source(bundle)
    let g:netrw_nogx = 1 " disable netrw's gx mapping.
  endfunction

  nmap gx <Plug>(openbrowser-smart-search)
  vmap gx <Plug>(openbrowser-smart-search)

  call neobundle#untap()
endif

if neobundle#tap('jazzradio.vim')
  nnoremap <Leader>jz :JazzradioUpdateChannels<CR>
  nnoremap <Leader>jZ :JazzradioStop<CR>
  nnoremap <Leader>uz :Unite jazzradio<CR>

  call neobundle#untap()
endif

if neobundle#tap('vim-over')
  nnoremap <Leader>s :<C-u>OverCommandLine<CR>

  call neobundle#untap()
endif

if neobundle#tap('vim-auto-save')
  let g:auto_save = 1
  let g:auto_save_in_insert_mode = 0

  call neobundle#untap()
endif

if neobundle#tap('context_filetype.vim')
  function! neobundle#hooks.on_source(bundle)
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
  endfunction

  call neobundle#untap()
endif

if neobundle#tap('vim-marching')
  " function! neobundle#hooks.on_source(bundle)
    " clang コマンドの設定
    let g:marching_clang_command = exepath('clang')

    " オプションを追加する場合
    let g:marching_clang_command_option="-std=c++1y"

    " インクルードディレクトリのパスを設定
    let g:marching_include_paths = [
          \ '/Library/Developer/CommandLineTools/usr/include/c++/v1/',
          \ '/usr/include'
          \ ]

    " filter(
    " \ split(glob('/usr/include/c++/*/'), '\n'),
    " \ 'isdirectory(v:val)'
    " \ ) + ['/Library/Developer/CommandLineTools/usr/include/c++/v1/']

    " neocomplete.vim と併用して使用する場合は以下の設定を行う
    let g:marching_enable_neocomplete = 1

  " endfunction

  call neobundle#untap()
endif

if neobundle#tap('lexima.vim')
  inoremap <C-j> <C-r>=lexima#insmode#escape()<CR><Esc>

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

  call neobundle#untap()
endif

if neobundle#tap('neocomplete')
  " function! neobundle#hooks.on_source(bundle)
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

    if !exists('g:neocomplete#force_omni_input_patterns')
      let g:neocomplete#force_omni_input_patterns = {}
    endif

    let g:neocomplete#force_omni_input_patterns.cpp =
          \ '[^.[:digit:] *\t]\%(\.\|->\)\w*\|\h\w*::\w*'
    let g:neocomplete#force_omni_input_patterns.ruby =
          \ '[^. *\t]\.\w*\|\h\w*::'
    let g:neocomplete#force_omni_input_patterns.c =
          \'[^.[:digit:] *\t]\%(\.\|->\)'
    let g:neocomplete#force_omni_input_patterns.erlang =
          \ '[^. *\t]:\w*'

    let g:neocomplete#keyword_patterns['default'] = '\h\w*'
    " Enable heavy omni completion.
    if !exists('g:neocomplete#sources#omni#input_patterns')
      let g:neocomplete#sources#omni#input_patterns = {}
    endif

    let g:neocomplete#sources#omni#input_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'
    let g:neocomplete#sources#omni#input_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'

    let g:neocomplete#force_overwrite_completefunc = 1

    let g:neocomplete#sources#rsense#home_directory = exepath('rsense')
  " endfunction

  inoremap <expr><C-g>     neocomplete#undo_completion()
  imap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
  function! s:my_cr_function()
    return neocomplete#close_popup() . "\<CR>"
    " For no inserting <CR> key.
    " return pumvisible() ? neocomplete#close_popup() : "\<CR>"
  endfunction
  inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
  inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<S-TAB>"
  imap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
  imap <expr><BS> neocomplete#smart_close_popup()."\<BS>"
  " inoremap <expr><C-o>  neocomplete#close_popup()
  inoremap <expr><C-e>  neocomplete#cancel_popup()
  " Close popup by <Space>.
  "inoremap <expr><Space> pumvisible() ? neocomplete#close_popup() : "\<Space>"

  call neobundle#untap()
endif

if neobundle#tap('neocomplcache.vim')
  function! neobundle#hooks.on_source(bundle)
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
    let g:neocomplcache_enable_camel_case_completion = 1
    " Use underbar completion.
    let g:neocomplcache_enable_underbar_completion = 1
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

    if !exists('g:neocomplcache_force_omni_patterns')
      let g:neocomplcache_force_omni_patterns = {}
    endif

    let g:neocomplcache_force_omni_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
    let g:neocomplcache_force_omni_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'
    let g:neocomplcache_force_omni_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'

  endfunction

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

  call neobundle#untap()
endif

if neobundle#tap('neorspec.vim')
  function! neobundle#hooks.on_source(bundle)
    let g:neorspec_command = "Dispatch " . s:rspec_cmd() . " --color --format documentation {spec}"
  endfunction

  function! s:rspec_cmd()
    if executable(getcwd().'/bin/rspec')
      return 'bin/spring rspec'
    else
      return 'bundle exec rspec'
    endif
  endfunction

  call neobundle#untap()
endif

if neobundle#tap('vim-autoft')
  let g:autoft_config = [
        \ { 'filetype' : 'ruby', 'pattern' : 'create_table' }
        \ ]

  call neobundle#untap()
endif

if neobundle#tap('vim-github-dashboard')
  let g:github_dashboard = {
        \ 'username' : 'yuya373'
        \ }
  command! Palmxapi execute('GHA aktsk/palmx-api')
  command! Yuya373 execute('GHD yuya373')
  call neobundle#untap()
endif

if neobundle#tap('github-issues')
  " g:gissues_async_omni = 1
  " g:gissues_lazy_load = 1
  g:github_issues_no_omni = 1
  g:github_same_window = 1
  call neobundle#untap()
endif

if neobundle#tap('w3m.vim')
  nnoremap <Leader>ww :<C-u>W3m
  nnoremap <Leader>wt :<C-u>W3mTab
  nnoremap <Leader>ws :<C-u>W3mSplit
  nnoremap <Leader>wv :<C-u>W3mVSplit

  " let g:w3m#homepage = "http://www.google.co.jp/"

  " function! s:w3m_buffer_map() abort
  "   nnoremap r :W3mReload
  "   nnoremap e :W3mShowExternalBrowser
  "   nnoremap <Leader>h :W3mHistory
  " endfunction
  "
  " augroup PluginW3m
  "   autocmd!
  "   autocmd filetype w3m call s:w3m_buffer_map()
  " augroup END

  call neobundle#untap()
endif

if neobundle#tap('vim-qfstatusline')
  let g:Qfstatusline#UpdateCmd = function('lightline#update')
  call neobundle#untap()
endif

if neobundle#tap('unite-tag')
  function! neobundle#hooks.on_source(bundle)
    let g:unite_source_tag_max_fname_length = 999
  endfunction

  augroup UniteTag
    autocmd!
    autocmd BufEnter *
          \  if empty(&buftype)
          \|     nnoremap <buffer> <C-]> :<C-u>UniteWithCursorWord tag<CR>
          \|  endif
    autocmd BufEnter *
          \  if empty(&buftype)
          \|     nnoremap <buffer> <C-t> :<C-u>Unite jump<CR>
          \|  endif
  augroup END
  call neobundle#untap()
endif

if neobundle#tap('vimerl')
  let erlang_folding = 1
  call neobundle#untap()
endif

if neobundle#tap('golden-ratio')
  let g:golden_ratio_wrap_ignored = 1
  call neobundle#untap()
endif

if neobundle#tap('dash.vim')
  nmap <Space>d <Plug>DashSearch
  call neobundle#untap()
endif

function! s:gitignore_source()
  let sources = []
  if filereadable('./.gitignore')
    for file in readfile('./.gitignore')
      " コメント行と空行は追加しない
      if file !~ "^#\\|^\s\*$"
        call add(sources, file)
      endif
    endfor
  endif
  if isdirectory('./.git')
    call add(sources, '.git')
  endif
  call add(sources, 'jpg')
  call add(sources, 'png')
  call add(sources, 'otf')
  call add(sources, 'csv')
  return escape(join(sources, '|'), './|')
endfunction

if neobundle#tap('vim-expand-region')
  vmap v <Plug>(expand_region_expand)
  vmap <C-v> <Plug>(expand_region_shrink)
  call neobundle#untap()
endif
