 " display settings for gvim
 " ----------------------
 " colorscheme railscasts
 set background=light
 colorscheme solarized
 set showtabline=2
 " window size
 if has("win32")
     au GUIEnter * simalt ~x
 else
     set transparency=8
     au GUIEnter * set lines=60
     au GUIEnter * set columns=190
 endif

 " menus
 set guioptions-=T " no tool bar
 set guioptions-=m " no menu bar
 set guioptions-=r " no right scrollbar
 set guioptions-=R " no right scrollbar
 set guioptions-=l " no left scrollbar
 set guioptions-=L " no left scrollbar
 set guioptions+=c
 set guifont=Ricty\ Regular:h20
 set transparency=0
nnoremap <Leader>tT :set transparency=0<CR>
nnoremap <Leader>tt :set transparency=20<CR>
