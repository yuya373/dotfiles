 " display settings for gvim
 " ----------------------
 set background=dark
 colorscheme solarized
 set showtabline=2
 set cursorline
 " menus
 set guioptions-=T " no tool bar
 set guioptions-=m " no menu bar
 set guioptions-=r " no right scrollbar
 set guioptions-=R " no right scrollbar
 set guioptions-=l " no left scrollbar
 set guioptions-=L " no left scrollbar
 set guioptions+=c
 set guifont=Ricty\ Regular:h17
 set transparency=0
nnoremap <Leader>tT :set transparency=0<CR>
nnoremap <Leader>tt :set transparency=20<CR>
